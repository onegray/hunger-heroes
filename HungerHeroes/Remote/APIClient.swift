//
//  APIClient.swift
//  HungerHeroes
//
//  Created by sergeyn on 20.11.22.
//

import Foundation

class APIClient: HttpClientProtocol {

    let appApiClient = RemoteClient()

    let m3Client = M3Client()

    func perform(_ request: HttpRequest) {
        switch request {
        case let request as M3HttpRequest:
            self.m3Client.perform(request)
        default:
            self.appApiClient.perform(request)
        }
    }
}
