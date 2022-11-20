//
//  MockMapPresenter.swift
//  HungerHeroesUITests
//
//  Created by sergeyn on 20.11.22.
//

import Foundation

#if DEBUG

class MockMapPresenter: MapPresenterProtocol {

    var viewModel = MapViewModel()

    func loadGame(gameId: String) {

    }
}

#endif
