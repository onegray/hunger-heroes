//
// Created by onegray on 18.08.22.
//

import Foundation

class GetPlayerProfileRequest: HttpRequest {

    init(playerId: Int, handler: @escaping (GetPlayerProfileResponse) -> Void) {
        super.init(path: "\(playerId).json", method: .get, handler: handler)
    }
}


class GetPlayerProfileResponse: HttpResponse {

    required init(data: Data?, code: Int) {
        super.init(data: data, code: code)
        if let data = data, let json = try? JSONSerialization.jsonObject(with: data) {
            print(json)
        }
    }

    required init(error: Error, code: Int) {
        super.init(error: error, code: code)
    }
}

