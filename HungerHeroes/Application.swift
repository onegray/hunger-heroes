//
//  Application.swift
//  HungerHeroes
//
//  Created by onegray on 27.08.22.
//

import Foundation

protocol Application {

    var gameService: GameService { get }

}


class ApplicationCore: Application {

    let storage = FileStorage()
    let httpClient = RemoteClient()

    let gameService: GameService

    init() {
        self.gameService = AppGameService(storage: self.storage, httpClient: self.httpClient)
        self.storage.loadStorage(completion: nil)
    }
}
