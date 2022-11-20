//
//  MockPlayerProfilePresenter.swift
//  HungerHeroesUITests
//
//  Created by sergeyn on 20.11.22.
//

import Foundation

#if DEBUG

class MockPlayerProfilePresenter: PlayerProfilePresenterProtocol {

    var viewModel = PlayerProfileViewModel()

    func onWillAppear() {

    }
}

#endif
