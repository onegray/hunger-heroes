//
// Created by onegray on 21.09.22.
//

import Foundation
import Combine

protocol RoomService {
    var room: CurrentValueSubject<GameRoomDef?, Never> { get }
    func requestRoom()
}

class AppRoomService: RoomService {

    let roomId: String
    let room: CurrentValueSubject<GameRoomDef?, Never>

    let storage: Storage
    var roomStore: RoomStore { self.storage.roomStore(roomId: self.roomId) }
    let httpClient: HttpClientProtocol

    init(roomId: String, storage: Storage, httpClient: HttpClientProtocol) {
        self.roomId = roomId
        self.storage = storage
        self.httpClient = httpClient
        self.room = .init(nil)

        self.storage.loadStorage {
            if let loadedRoom = self.roomStore.room {
                self.roomStore.room = loadedRoom
                self.room.value = loadedRoom
            }
        }
    }

    func requestRoom() {
        let request = GetGameRoomRequest(roomId: self.roomId) { response in
            if case .success = response.status {
                self.room.value = response.gameRoom
                self.storage.loadStorage {
                    self.roomStore.room = response.gameRoom
                }
            } else if case .failure(let err) = response.status {
                print(err)
            }
        }
        self.httpClient.perform(request)
    }
}
