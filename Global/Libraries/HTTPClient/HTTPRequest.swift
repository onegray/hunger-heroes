//
//  HTTPRequest.swift
//  HungerHeroes
//
//  Created by onegray on 15.08.22.
//

import Foundation

class HTTPRequest {

    var path: String
    var method: HTTPMethod
    var headers: [String: String]?
    var params: [String: String]?
    var paramsEncoding: ParamsEncoding?

    init(path: String, method: HTTPMethod) {
        self.path = path
        self.method = method
    }
}

extension HTTPRequest {

    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case delete = "DELETE"
    }

    enum ParamsEncoding {
        case urlEncoding
        case jsonEncoding
    }

    enum HTTPRequestError: Error {
        case malformedUrl
        case malformedParams
        case encodingError
    }
}

extension HTTPRequest {

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
            throw HTTPRequestError.malformedUrl
        }

        if self.method != .post && self.method != .put && self.params?.isNotEmpty == true {
            guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
                throw HTTPRequestError.malformedUrl
            }
            components.queryItems = self.prepareQueryItems()
            guard let urlWithParams = components.url(relativeTo: baseUrl) else {
                throw HTTPRequestError.malformedParams
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
                throw HTTPRequestError.malformedParams
            }
            guard let data = queryString.data(using: .utf8) else {
                throw HTTPRequestError.encodingError
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
