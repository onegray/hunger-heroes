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
    var imageService: ImageService { get }

    func getPlayerService(playerId: Int) -> PlayerService
    func getRoomService(roomId: String) -> RoomService
}


class ApplicationCore: Application {

    let storage = JsonStorage()
    let httpClient = APIClient()

    var playerServices = [Int : PlayerService]()
    var roomServices = [String : RoomService]()

    let gameService: GameService
    let appService: AppService
    let imageService: ImageService

    init() {
        self.appService = CoreAppService(storage: self.storage, httpClient: self.httpClient)
        self.gameService = AppGameService(storage: self.storage, httpClient: self.httpClient)
        self.imageService = AppImageService(store: self.storage.imageFileStore, httpClient: self.httpClient)
    }

    func getPlayerService(playerId: Int) -> PlayerService {
        return self.playerServices[playerId] ?? {
            let service = AppPlayerService(playerId: playerId, storage: self.storage, httpClient: self.httpClient)
            self.playerServices[playerId] = service
            return service
        }()
    }

    func getRoomService(roomId: String) -> RoomService {
        return self.roomServices[roomId] ?? {
            let service = AppRoomService(roomId: roomId, storage: self.storage, httpClient: self.httpClient)
            self.roomServices[roomId] = service
            return service
        }()
    }
}
