//
//  MockGameRoomPresenter.swift
//  HungerHeroesUITests
//
//  Created by sergeyn on 20.11.22.
//

import Foundation

#if DEBUG

class MockGameRoomPresenter: GameRoomPresenterProtocol {

    var viewModel = GameRoomViewModel()

    func onWillAppear() {

    }
}

#endif
