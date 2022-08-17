//
// Created by onegray on 18.08.22.
//

import Foundation

class RemoteClient: HttpClient {

    static let host = "https://raw.githubusercontent.com/onegray/hunger-heroes/mockups/"

    init() {
        super.init(baseUrl: URL(string: Self.host)!)

        self.defaultParamsEncoding = .jsonEncoding

        self.defaultHeaders = [
            "Accept" : "application/json",
            "Content-Type" : "application/json"]
    }
}

