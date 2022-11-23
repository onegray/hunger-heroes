//
//  MockStorage.swift
//  HungerHeroesTests
//
//  Created by sergeyn on 23.11.22.
//

import Foundation

class MockStorage: Storage {

    var mockRoomStore = MockRoomStore()
    var mockGameStore = MockGameStore()
    var mockImageStore = MockImageStore()

    var mockAppState: AppStateDef?
    var mockPlayer: PlayerDef?

    var imageStore: ImageStore {
        return self.mockImageStore
    }

    var appState: AppStateDef? {
        get { self.mockAppState }
        set { self.mockAppState = newValue }
    }

    func player(_ playerId: Int) -> PlayerDef? {
        return self.mockPlayer
    }

    func savePlayer(player: PlayerDef) {
        self.mockPlayer = player
    }

    func roomStore(roomId: String) -> RoomStore {
        return self.mockRoomStore
    }

    func gameStore(gameId: String) -> GameStore {
        return self.mockGameStore
    }

    func gameExists(gameId: String) -> Bool {
        return true
    }

    func loadStorage(completion: @escaping () -> Void) {
        completion()
    }
}
