//
//  HTTPClient.swift
//  HungerHeroes
//
//  Created by onegray on 15.08.22.
//

import Foundation

class HTTPClient {

    var baseUrl: URL
    var baseHeaders: [String:String]?

    init(baseUrl: URL) {
        self.baseUrl = baseUrl
    }
}
