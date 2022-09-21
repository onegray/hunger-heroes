//
// Created by onegray on 21.09.22.
//

import Foundation

class GetGameRoomRequest: HttpRequest {
    init(roomId: String, handler: @escaping (GetGameRoomResponse) -> ()) {
        super.init(path: "rooms/" + roomId, method: .get, handler: handler)
    }
}

class GetGameRoomResponse: HttpResponse {
    var gameRoom: GameRoomDef?

    required init(data: Data?, code: Int) {
        super.init(data: data, code: code)
        if let data = data {
            self.gameRoom = try? JSONDecoder().decode(GameRoomDef.self, from: data)
        }
    }

    required init(error: Error, code: Int) {
        super.init(error: error, code: code)
    }
}
