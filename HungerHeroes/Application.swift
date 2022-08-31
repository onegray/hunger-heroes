//
//  Application.swift
//  HungerHeroes
//
//  Created by onegray on 27.08.22.
//

import Foundation

protocol Application {

    var gameService: GameService { get }
    var appService: AppService { get }

}


class ApplicationCore: Application {

    let storage = JsonStorage()
    let httpClient = RemoteClient()

    let gameService: GameService
    let appService: AppService

    init() {
        self.appService = CoreAppService(storage: self.storage, httpClient: self.httpClient)
        self.gameService = AppGameService(storage: self.storage, httpClient: self.httpClient)
    }
}
