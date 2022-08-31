//
//  HomePresenter.swift
//  HungerHeroes
//
//  Created by onegray on 27.08.22.
//

import Foundation
import Combine

protocol HomePresenterProtocol {
    var viewModel: HomeViewModel { get }

}

class HomePresenter: HomePresenterProtocol {
    
    var viewModel: HomeViewModel
    var appService: AppService
    var gameService: GameService

    var disposeBag = Set<AnyCancellable>()

    init(viewModel: HomeViewModel, appService: AppService, gameService: GameService) {
        self.viewModel = viewModel
        self.appService = appService
        self.gameService = gameService

        self.appService.appState.compactMap({ $0 })
                .sink { [weak self] appState in
                    if let gameId = appState.activeGameId {
                        self?.openActiveGame(gameId: gameId)
                    } else {
                        self?.openHomeScreen()
                    }
                }
                .store(in: &self.disposeBag)
    }

    func openHomeScreen() {

    }

    func openActiveGame(gameId: String) {

    }
}
