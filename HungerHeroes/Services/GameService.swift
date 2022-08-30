//
// Created by onegray on 27.08.22.
//

import Foundation
import Combine

enum GameUpdateEvent {
    case mapUpdate
    case heroUpdate
    case objectUpdate
}

protocol GameService {

    var game: GameModel? { get }

    var onUpdate: PassthroughSubject<GameUpdateEvent, Never> { get }

    func loadRemoteGame(gameId: String)
}

class AppGameService: GameService {

    let onUpdate = PassthroughSubject<GameUpdateEvent, Never>()

    var game: GameModel?
    let storage: Storage
    let httpClient: HttpClientProtocol

    init(storage: Storage, httpClient: HttpClientProtocol) {
        self.storage = storage
        self.httpClient = httpClient
    }

    func loadRemoteGame(gameId: String) {
        let request = GetGamePackRequest(packName: gameId) { response in
            if case .success = response.status, let gamePack = response.gamePack {
                let gameStore = self.storage.games.get(gameId)
                gameStore.save(gamePack: gamePack, files: response.files)
            }
        }
        self.httpClient.perform(request)
    }
}
