//
//  PresentationEnvironment.swift
//  HungerHeroes
//
//  Created by onegray on 27.08.22.
//

import Foundation

protocol PresentationEnvironment {
    func homePresenter() -> HomePresenterProtocol
    func mapPresenter() -> MapPresenterProtocol
}
typealias Environment = PresentationEnvironment


class AppUserEnvironment {

    let app: Application

    init(app: Application) {
        self.app = app
    }
}

extension AppUserEnvironment: PresentationEnvironment {

    func homePresenter() -> HomePresenterProtocol {
        HomePresenter(viewModel: HomeViewModel(), appService: app.appService, gameService: app.gameService)
    }
    
    func mapPresenter() -> MapPresenterProtocol {
        MapPresenter(viewModel: MapViewModel(), gameService: app.gameService)
    }
}
