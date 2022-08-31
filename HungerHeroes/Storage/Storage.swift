//
//  Storage.swift
//  HungerHeroes
//
//  Created by onegray on 22.08.22.
//

import Foundation

protocol Storage {

    var appState: AppStateDef? { get set }

    func gameStore(gameId: String) -> GameStore

    func gameExists(gameId: String) -> Bool

    func loadStorage(completion: (()->Void)? )
}


class JsonStorage: Storage {

    let appStateJson = PersistentValue<AppStateDef>(path: "app_state.json")
    let gameStoreDictionary = StoreDictionary<String, JsonGameStore>(rootPath: "games/")

    init() {
#if DEBUG
        let docDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        print("FileStorage initialised at:\n" + docDir.description)
#endif
    }

    var appState: AppStateDef? {
        get { self.appStateJson.get() }
        set { self.appStateJson.save(newValue) }
    }

    func gameStore(gameId: String) -> GameStore {
        return self.gameStoreDictionary.get(gameId)
    }

    func gameExists(gameId: String) -> Bool {
        return self.gameStoreDictionary.hasStore(gameId)
    }

    func loadStorage(completion: (()->Void)? ) {
        self.gameStoreDictionary.loadDirectory { contents in
            self.gameStoreDictionary.load(ids: contents, completion: completion)
        }
    }
}
