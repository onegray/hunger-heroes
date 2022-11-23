//
//  MockGameStore.swift
//  HungerHeroesTests
//
//  Created by sergeyn on 23.11.22.
//

import Foundation

class MockGameStore: GameStore {

    var gamePack: GamePackDef?

    func getImage(fileId: String) -> ImageSource? {
        return nil
    }

    func save(gamePack: GamePackDef, files: [String : Data], completion: (()->Void)?) {
        completion?()
    }
}
