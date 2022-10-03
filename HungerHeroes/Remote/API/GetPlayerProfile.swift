//
// Created by onegray on 18.08.22.
//

import Foundation

class GetPlayerProfileRequest: HttpRequest {

    init(playerId: Int, handler: @escaping (GetPlayerProfileResponse) -> Void) {
        super.init(path: "players/\(playerId).json", method: .get, handler: handler)
    }
}


class GetPlayerProfileResponse: HttpResponse {
    var player: PlayerDef?

    required init(data: Data?, code: Int) {
        super.init(data: data, code: code)
        if let data = data {
            self.player = try? JSONDecoder().decode(PlayerDef.self, from: data)
        }
    }

    required init(error: Error, code: Int) {
        super.init(error: error, code: code)
    }
}
