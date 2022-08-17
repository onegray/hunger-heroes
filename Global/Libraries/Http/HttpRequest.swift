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
    var paramsEncoding: ParamsEncoding?

    init(path: String, method: HttpMethod,
         handler: @escaping (HttpResponse) -> Void,
         responseType: HttpResponse.Type)
    {
        self.path = path
        self.method = method
        self.handler = handler
        self.responseType = responseType
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
    }

    enum FormationError: Error {
        case malformedUrl
        case malformedParams
        case encodingError
    }
}

extension HttpRequest {

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

        if let params = self.params, !params.isEmpty, self.method != .post, self.method != .put {
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
        return allHeaders
    }

    func prepareHttpBody(defaultParamsEncoding: ParamsEncoding?) throws -> Data? {
        if self.method == .post || self.method == .put {
            let paramsEncoding = self.paramsEncoding ?? defaultParamsEncoding ?? .urlEncoding
            if paramsEncoding == .urlEncoding {
                return try self.urlEncodedBody()
            } else if paramsEncoding == .jsonEncoding {
                return try self.jsonEncodedBody()
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

    func prepareQueryItems() -> [URLQueryItem]? {
        self.params?.map { URLQueryItem(name: $0, value: $1) }
    }
}
