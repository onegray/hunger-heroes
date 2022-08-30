//
//  Storage.swift
//  HungerHeroes
//
//  Created by onegray on 22.08.22.
//

import Foundation

protocol Storage {

    var games: StoreDictionary<String, GamePackStore> { get }

    func loadStorage(completion: (()->Void)? )
}


class FileStorage: Storage {

    let games = StoreDictionary<String, GamePackStore>(rootPath: "games/")

    init() {
#if DEBUG
        let docDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        print("FileStorage initialised at:\n" + docDir.description)
#endif
    }

    func loadStorage(completion: (()->Void)? ) {
        self.games.loadDirectory { contents in
            self.games.load(ids: contents, completion: completion)
        }
    }
}
