//
// Created by onegray on 27.08.22.
//

import Foundation
import Combine

enum GameUpdateEvent {
    case newGame
    case startGame
    case mapUpdate
    case heroUpdate
    case objectUpdate
}

protocol GameService {

    var game: GameModel? { get }

    var onUpdate: PassthroughSubject<GameUpdateEvent, Never> { get }
    var onError: PassthroughSubject<Error, Never> { get }

    func loadGame(gameId: String)
    func loadRemoteGame(gameId: String, completion: (()->Void)?)
    func startGame(setup: GameSetupDef)
}

class AppGameService: GameService {

    let onUpdate = PassthroughSubject<GameUpdateEvent, Never>()
    let onError = PassthroughSubject<Error, Never>()

    var game: GameModel?
    let storage: Storage
    let httpClient: HttpClientProtocol

    init(storage: Storage, httpClient: HttpClientProtocol) {
        self.storage = storage
        self.httpClient = httpClient
    }

    func newGame(gameId: String) {
        let gameStore = self.storage.gameStore(gameId: gameId)
        do {
            self.game = try GameModel.new(gameId: gameId, store: gameStore)
        } catch let e {
            self.onError.send(e)
            return
        }

        self.game!.reset {
            self.onUpdate.send(.newGame)
        }
    }

    func loadRemoteGame(gameId: String, completion: (()->Void)?) {
        let request = GetGamePackRequest(packName: gameId) { response in
            if case .success = response.status, let gamePack = response.gamePack {
                let gameStore = self.storage.gameStore(gameId: gameId)
                gameStore.save(gamePack: gamePack, files: response.files, completion: completion)
            } else {
                self.onError.send(ModelError.remoteLoadError)
            }
        }
        self.httpClient.perform(request)
    }

    func loadGame(gameId: String) {
        if self.storage.gameExists(gameId: gameId) {
            self.newGame(gameId: gameId)
        } else {
            self.loadRemoteGame(gameId: gameId) {
                self.newGame(gameId: gameId)
            }
        }
    }

    func startGame(setup: GameSetupDef) {
        if let game = self.game {
            game.start(setup: setup) {
                self.onUpdate.send(.startGame)
            }
        }
    }
}
