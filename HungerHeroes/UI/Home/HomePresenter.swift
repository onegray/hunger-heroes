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
    var gameService: GameService
    
    init(viewModel: HomeViewModel, gameService: GameService) {
        self.viewModel = viewModel
        self.gameService = gameService

        self.gameService.loadRemoteGame(gameId: "hg_pack.tar")
    }
}
