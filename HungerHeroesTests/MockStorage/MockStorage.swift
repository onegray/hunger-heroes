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

    var imageStore: ImageStore {
        return self.mockImageStore
    }

    var appState: AppStateDef? {
        get { nil }
        set { }
    }

    func player(_ playerId: Int) -> PlayerDef? {
        return nil
    }

    func savePlayer(player: PlayerDef) {

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
