//
//  GameRoomPresenter.swift
//  HungerHeroes
//
//  Created by onegray on 17.09.22.
//

import Foundation

protocol GameRoomPresenterProtocol {
    var viewModel: GameRoomViewModel { get }
}

class GameRoomPresenter: GameRoomPresenterProtocol {

    let viewModel: GameRoomViewModel
    let roomService: RoomService

    init(viewModel: GameRoomViewModel, roomService: RoomService) {
        self.viewModel = GameRoomView_previews.testViewModel
        self.roomService = roomService
    }
}
