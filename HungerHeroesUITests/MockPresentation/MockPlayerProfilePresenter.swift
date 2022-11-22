//
//  MockPlayerProfilePresenter.swift
//  HungerHeroesUITests
//
//  Created by sergeyn on 20.11.22.
//

import Foundation
import UIKit

#if DEBUG

class MockPlayerProfilePresenter: PlayerProfilePresenterProtocol {

    var viewModel = MockPlayerProfilePresenter.testViewModel

    func onWillAppear() {

    }
}

extension MockPlayerProfilePresenter {

    static var testViewModel: PlayerProfileViewModel {
        let vm = PlayerProfileViewModel()
        vm.avatar = UIImage(named: "avatar-placeholder")?.cgImage
        vm.name = "Scorpion"
        vm.role = "assassin"
        vm.efficiency = 142
        vm.points = "1642"
        vm.killDeathRate = "1.42"
        vm.frags = "94"
        vm.gameTime = "168"
        vm.winRate = "42"
        vm.looseRate = "34"
        return vm
    }
}

#endif
