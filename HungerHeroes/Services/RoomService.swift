//
// Created by onegray on 21.09.22.
//

import Foundation
import Combine

protocol RoomService {
    var room: CurrentValueSubject<GameRoomDef?, Never> { get }
}

class AppRoomService: RoomService {

    let room: CurrentValueSubject<GameRoomDef?, Never>

    let storage: Storage
    let httpClient: HttpClientProtocol

    init(roomId: String, storage: Storage, httpClient: HttpClientProtocol) {
        self.storage = storage
        self.httpClient = httpClient
        self.room = .init(nil)

        self.requestRoom(roomId: roomId)
    }

    func requestRoom(roomId: String) {
        let request = GetGameRoomRequest(roomId: roomId) { response in
            print("GetGameRoomRequest \(response)")
        }
        self.httpClient.perform(request)
    }
}
