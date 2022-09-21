//
//  Application.swift
//  HungerHeroes
//
//  Created by onegray on 27.08.22.
//

import Foundation

protocol Application {

    var gameService: GameService { get }
    var appService: AppService { get }

    func getRoomService(roomId: String) -> RoomService
}


class ApplicationCore: Application {

    let storage = JsonStorage()
    let httpClient = RemoteClient()

    var roomServices = [String : RoomService]()

    let gameService: GameService
    let appService: AppService

    init() {
        self.appService = CoreAppService(storage: self.storage, httpClient: self.httpClient)
        self.gameService = AppGameService(storage: self.storage, httpClient: self.httpClient)
    }

    func getRoomService(roomId: String) -> RoomService {
        return self.roomServices[roomId] ?? {
            let service = AppRoomService(roomId: roomId, storage: self.storage, httpClient: self.httpClient)
            self.roomServices[roomId] = service
            return service
        }()
    }
}
