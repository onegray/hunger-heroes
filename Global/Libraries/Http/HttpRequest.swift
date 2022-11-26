//
//  HttpRequest.swift
//  HungerHeroes
//
//  Created by onegray on 15.08.22.
//

import Foundation

class HttpRequest {

    let responseType: HttpResponse.Type
    let path: String
    let method: HttpMethod
    let handler: (HttpResponse) -> Void

    var headers: [String: String]?
    var params: [String: String]?
    var formParams: [FormParam]?
    var paramsEncoding: ParamsEncoding?

    static let boundary = "Boundary$0Ux8kQ3"

    init<Response: HttpResponse>(path: String, method: HttpMethod,
                                 handler: @escaping (Response) -> Void)
    {
        self.path = path
        self.method = method
        self.responseType = Response.self
        self.handler = { response in
            handler(response as! Response)
        }
    }

    func createUrlRequest(baseUrl: URL, defaultHeaders: [String:String]?,
                          defaultParamsEncoding: ParamsEncoding?) throws -> URLRequest {
        var request = URLRequest(url: try self.prepareUrl(baseUrl: baseUrl))
        request.httpMethod = self.method.rawValue
        request.allHTTPHeaderFields = self.prepareHeaders(defaultHeaders: defaultHeaders)
        request.httpBody = try self.prepareHttpBody(defaultParamsEncoding: defaultParamsEncoding)
        return request
    }

    func prepareUrl(baseUrl: URL) throws -> URL {
        guard let url = URL(string: self.path, relativeTo: baseUrl) else {
            throw FormationError.malformedUrl
        }

        if let params = self.params, !params.isEmpty, self.method == .get || self.method == .head {
            guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
                throw FormationError.malformedUrl
            }
            components.queryItems = self.prepareQueryItems()
            guard let urlWithParams = components.url(relativeTo: baseUrl) else {
                throw FormationError.malformedParams
            }
            return urlWithParams
        } else {
            return url
        }
    }

    func prepareHeaders(defaultHeaders: [String:String]?) -> [String:String]? {
        var allHeaders = defaultHeaders ?? [:]
        if let headers = self.headers {
            allHeaders.merge(headers) { $1 }
        }
        if self.paramsEncoding == .formDataEncoding && allHeaders["Content-Type"] == nil {
            allHeaders["Content-Type"] = "multipart/form-data; boundary=" + Self.boundary
        }
        return allHeaders
    }

    func prepareHttpBody(defaultParamsEncoding: ParamsEncoding?) throws -> Data? {
        if self.method == .post || self.method == .put {
            let paramsEncoding = self.paramsEncoding ?? defaultParamsEncoding ?? .urlEncoding
            if paramsEncoding == .urlEncoding {
                return try self.urlEncodedBody()
            } else if paramsEncoding == .jsonEncoding {
                return try self.jsonEncodedBody()
            } else if paramsEncoding == .formDataEncoding {
                return try self.multipartFormBody()
            }
        }
        return nil
    }

    func urlEncodedBody() throws -> Data? {
        if let queryItems = self.prepareQueryItems() {
            var components = URLComponents()
            components.queryItems = queryItems
            guard let queryString = components.query else {
                throw FormationError.malformedParams
            }
            guard let data = queryString.data(using: .utf8) else {
                throw FormationError.encodingError
            }
            return data
        }
        return nil
    }

    func jsonEncodedBody() throws -> Data? {
        if let params = self.params {
            return try JSONEncoder().encode(params)
        }
        return nil
    }

    func multipartFormBody() throws -> Data? {
        guard self.params?.isEmpty == false || self.formParams?.isEmpty == false else {
            return nil
        }

        var body = Data()

        func appendString(_ string: String) throws {
            guard let data = string.data(using: .utf8) else {
                throw FormationError.malformedParams
            }
            body.append(data)
        }

        if let params = self.params {
            for (key, value) in params {
                try appendString("--\(Self.boundary)\r\n")
                try appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                try appendString("\(value)\r\n")
            }
        }

        if let formParams = self.formParams {
            for partParams in formParams {
                try appendString("--\(Self.boundary)\r\n")
                try appendString("Content-Disposition: form-data; name=\"\(partParams.name)\"; filename=\"\(partParams.filename)\"\r\n")
                if let mimetype = partParams.mimetype {
                    try appendString("Content-Type: \(mimetype)\r\n")
                }
                try appendString("\r\n")
                body.append(partParams.data)
                try appendString("\r\n")
            }
        }

        try appendString("--\(Self.boundary)--\r\n")

        return body
    }

    func prepareQueryItems() -> [URLQueryItem]? {
        self.params?.map { URLQueryItem(name: $0, value: $1) }
    }

    func addFormPart(data: Data, name: String, filename: String, mimetype: String? = nil) {
        let part = FormParam(name: name, filename: filename, mimetype: mimetype, data: data)
        if self.formParams != nil {
            self.formParams?.append(part)
        } else {
            self.formParams = [part]
        }
    }
}

extension HttpRequest {

    enum HttpMethod: String {
        case head = "HEAD"
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case delete = "DELETE"
    }

    enum ParamsEncoding {
        case urlEncoding
        case jsonEncoding
        case formDataEncoding
    }

    struct FormParam {
        let name: String
        let filename: String
        let mimetype: String?
        let data: Data
    }

    enum FormationError: Error {
        case malformedUrl
        case malformedParams
        case encodingError
    }
}
