//
// Created by onegray on 18.08.22.
//

import Foundation

class RemoteClient: HttpClient {

    //static let host = "https://raw.githubusercontent.com/onegray/hunger-heroes/mockups/"
    static let host = "https://bitbucket.org/onegray/resources/raw/hh/"

    init() {
        super.init(baseUrl: URL(string: Self.host)!)

        self.defaultParamsEncoding = .jsonEncoding

        self.defaultHeaders = [
            "Accept" : "application/json",
            "Content-Type" : "application/json"]
    }
}
