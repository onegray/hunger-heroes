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
    
    init(viewModel: GameRoomViewModel) {
        self.viewModel = GameRoomView_previews.testViewModel
    }
}
