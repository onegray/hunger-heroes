//
//  HttpClient.swift
//  HungerHeroes
//
//  Created by onegray on 15.08.22.
//

import Foundation

protocol HttpClientProtocol {
    func perform(_ request: HttpRequest)
}

protocol HttpClientDelegate: AnyObject {
    func shouldStartRequest(_ request: HttpRequest) -> Bool
    func shouldCompleteRequest(_ request: HttpRequest) -> Bool
}

extension HttpClientDelegate {
    func shouldStartRequest(_ request: HttpRequest) -> Bool { true }
    func shouldCompleteRequest(_ request: HttpRequest) -> Bool { true }
}

class HttpClient {

    var baseUrl: URL
    var defaultHeaders: [String:String]?
    var defaultParamsEncoding: HttpRequest.ParamsEncoding = .jsonEncoding

    weak var delegate: HttpClientDelegate?

    init(baseUrl: URL) {
        self.baseUrl = baseUrl
    }
}

extension HttpClient: HttpClientProtocol {

    func perform(_ request: HttpRequest) {

        if self.delegate?.shouldStartRequest(request) == false {
            return
        }

        let urlRequest: URLRequest
        do {
            urlRequest = try request.createUrlRequest(baseUrl: self.baseUrl,
                                                      defaultHeaders: self.defaultHeaders,
                                                      defaultParamsEncoding: self.defaultParamsEncoding)
        } catch let error {
            assert(false, "Unable to create URLRequest: \(error)")
            let response = request.responseType.init(error: error, code: 0)
            request.handler(response)
            return
        }

        let task = URLSession.shared.dataTask(with: urlRequest) { data, urlResponse, error in

            let statusCode = (urlResponse as? HTTPURLResponse)?.statusCode ?? 0
            let response: HttpResponse

            if error == nil {
                response = request.responseType.init(data: data, code: statusCode)
            } else {
                response = request.responseType.init(error: error!, code: statusCode)
            }

            DispatchQueue.main.async {
                if self.delegate?.shouldCompleteRequest(request) != false {
                    request.handler(response)
                }
            }
        }
        task.resume()
    }
}
