//
//  M3LoginRequest.swift
//  HungerHeroes
//
//  Created by sergeyn on 20.11.22.
//

import Foundation

class M3LoginRequest: M3HttpRequest {
    init(username: String, password: String, handler: @escaping (M3LoginResponse) -> Void) {
        super.init(path: "user/Login", method: .get, handler: handler)
        self.params = ["username" : username, "password" : password]
    }
}


class M3LoginResponse: HttpResponse {

    enum LoginError: LocalizedError {
        case invalidNameOrPassword
        case unexpectedResponse

        var errorDescription: String? {
            switch self {
            case .invalidNameOrPassword:
                return "Invalid username or password"
            case .unexpectedResponse:
                return "Unexpected server response"
            }
        }
    }

    struct Response: Decodable {
        struct UserSession: Decodable {
            let id: String
            let userId: String
        }

        let session: UserSession
    }

    var session: Response.UserSession?

    required init(data: Data?, code: Int) {
        super.init(data: data, code: code)
        if let data = data, code == 200 {
            if let response = try? JSONDecoder().decode(Response.self, from: data) {
                self.session = response.session
            } else {
                self.status = .failure(LoginError.unexpectedResponse)
            }
        } else {
            self.status = .failure(LoginError.invalidNameOrPassword)
        }
    }

    required init(error: Error, code: Int) {
        super.init(error: error, code: code)
    }
}
