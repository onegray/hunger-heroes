//
//  M3Client.swift
//  HungerHeroes
//
//  Created by sergeyn on 20.11.22.
//

import Foundation

class M3Client: HttpClient {

    static let host = "https://api.m3o.com/v1/"
    static let api_key = "MmFkYTA1OGItZjgxNy00YzI3LWJiMjktOTViYWJhOTBmYjkw"

    init() {
        super.init(baseUrl: URL(string: Self.host)!)

        self.defaultParamsEncoding = .jsonEncoding

        self.defaultHeaders = [
            "Accept" : "application/json",
            "Content-Type" : "application/json",
            "Authorization" : "Bearer \(Self.api_key)"
        ]
    }
}


class M3HttpRequest: HttpRequest {

}
