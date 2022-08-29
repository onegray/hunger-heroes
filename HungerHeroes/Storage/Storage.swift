//
//  Storage.swift
//  HungerHeroes
//
//  Created by onegray on 22.08.22.
//

import Foundation

protocol Storage {

    var games: PersistentDictionary<String, GamePackDef> { get }

    func loadStorage(completion: (()->())? )
}


class FileStorage: Storage {

    let games = PersistentDictionary<String, GamePackDef>(filepath: "games.json")

    init() {
#if DEBUG
        let dir = games.persistentDictionary.fileURL.deletingLastPathComponent()
        print("FileStorage initialised at:\n" + dir.description)
#endif
    }

    func loadStorage(completion: (()->())? ) {
        self.games.load(completion: completion)
    }
}
