//
// Created by onegray on 3.10.22.
//

import Foundation
import Combine

protocol PlayerService {
    var player: CurrentValueSubject<PlayerDef?, Never> { get }
    var isRequesting: CurrentValueSubject<Bool, Never> { get }
    func requestPlayerProfile()
}

class AppPlayerService: PlayerService {

    let playerId: Int
    let player = CurrentValueSubject<PlayerDef?, Never>(nil)
    let isRequesting = CurrentValueSubject<Bool, Never>(false)

    let storage: Storage
    let httpClient: HttpClientProtocol

    init(playerId: Int, storage: Storage, httpClient: HttpClientProtocol) {
        self.playerId = playerId
        self.storage = storage
        self.httpClient = httpClient
        self.storage.loadStorage {
            if let player = self.storage.player(self.playerId) {
                self.player.value = player
            }
        }
    }

    func requestPlayerProfile() {
        guard self.isRequesting.value == false else { return }
        self.isRequesting.value = true

        let request = GetPlayerProfileRequest(playerId: self.playerId) { response in
            self.isRequesting.value = false
            if case .success = response.status, let player = response.player {
                self.player.value = player
                self.storage.loadStorage {
                    self.storage.savePlayer(player: player)
                }
            } else if case .failure(let err) = response.status {
                print(err)
            }
        }
        self.httpClient.perform(request)
    }
}
