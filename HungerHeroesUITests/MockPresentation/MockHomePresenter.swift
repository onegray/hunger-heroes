//
//  MockHomePresenter.swift
//  HungerHeroesUITests
//
//  Created by sergeyn on 20.11.22.
//

import Foundation

#if DEBUG

class MockHomePresenter: HomePresenterProtocol {

    var viewModel = HomeViewModel()

    func login(username: String, password: String) {
        self.viewModel.loginStatus = .signed
    }
}

#endif
