//
//  MockApiClient.swift
//  HungerHeroesTests
//
//  Created by sergeyn on 23.11.22.
//

import Foundation

class MockApiClient: HttpClientProtocol {

    var mockResponses = [String : HttpResponse]()

    func setResponse(_ response: HttpResponse, for requestClass: HttpRequest.Type) {
        let requestName = String(describing: requestClass)
        self.mockResponses[requestName] = response
    }

    func perform(_ request: HttpRequest) {

        DispatchQueue.main.async {

            let requestName = String(describing: type(of: request))

            if let response = self.mockResponses[requestName] {

                request.handler(response)

            } else {

                let response = request.responseType.init(error: MockApiError.defaulError, code: 999)
                request.handler(response)
            }
        }
    }
}

extension MockApiClient {

    enum MockApiError: Error {
        case defaulError
    }
}
