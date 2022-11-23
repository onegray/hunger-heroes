//
//  MockApiClient.swift
//  HungerHeroesTests
//
//  Created by sergeyn on 23.11.22.
//

import Foundation

class MockApiClient: HttpClientProtocol {

    var mockResponses = [String : HttpResponse]()

    func perform(_ request: HttpRequest) {

        DispatchQueue.main.async {

            if let response = self.mockResponses[request.path] {

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
