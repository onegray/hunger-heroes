//
//  PresentationEnvironment.swift
//  HungerHeroes
//
//  Created by onegray on 27.08.22.
//

import Foundation

protocol PresentationEnvironment {
    func homePresenter() -> HomePresenterProtocol
    func gameRoomPresenter(roomId: String) -> GameRoomPresenterProtocol
    func playerProfilePresenter(roomId: String, playerId: Int) -> PlayerProfilePresenterProtocol
    func mapPresenter() -> MapPresenterProtocol
}
typealias Environment = PresentationEnvironment


class AppUserEnvironment {

    let app: Application

    init(app: Application) {
        self.app = app
    }
}

extension AppUserEnvironment: PresentationEnvironment {

    func homePresenter() -> HomePresenterProtocol {
        HomePresenter(viewModel: HomeViewModel(), appService: self.app.appService, gameService: self.app.gameService)
    }

    func gameRoomPresenter(roomId: String) -> GameRoomPresenterProtocol {
        let vm = GameRoomViewModel()
        let roomService = self.app.getRoomService(roomId: roomId)
        let imageService = self.app.imageService
        return GameRoomPresenter(viewModel: vm, roomService: roomService, imageService: imageService)
    }

    func playerProfilePresenter(roomId: String, playerId: Int) -> PlayerProfilePresenterProtocol {
        let vm = PlayerProfileViewModel()
        let roomService = self.app.getRoomService(roomId: roomId)
        let imageService = self.app.imageService
        return PlayerProfilePresenter(viewModel: vm, roomService: roomService, imageService: imageService)
    }

    func mapPresenter() -> MapPresenterProtocol {
        MapPresenter(viewModel: MapViewModel(), gameService: self.app.gameService)
    }
}
