//
//  MockPresentationEnvironment.swift
//  HungerHeroesUITests
//
//  Created by sergeyn on 22.11.22.
//

import Foundation

#if DEBUG

class MockPresentationEnvironment: PresentationEnvironment {

    func homePresenter() -> HomePresenterProtocol {
        MockHomePresenter()
    }

    func gameRoomPresenter(roomId: String) -> GameRoomPresenterProtocol {
        MockGameRoomPresenter()
    }

    func playerProfilePresenter(playerId: Int) -> PlayerProfilePresenterProtocol {
        MockPlayerProfilePresenter()
    }

    func mapPresenter() -> MapPresenterProtocol {
        MockMapPresenter()
    }
}

#endif
