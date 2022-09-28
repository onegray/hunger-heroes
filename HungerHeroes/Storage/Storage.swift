//
//  Storage.swift
//  HungerHeroes
//
//  Created by onegray on 22.08.22.
//

import Foundation

protocol Storage {

    var appState: AppStateDef? { get set }

    var imageStore: ImageStore { get }

    func roomStore(roomId: String) -> RoomStore

    func gameStore(gameId: String) -> GameStore

    func gameExists(gameId: String) -> Bool

    func loadStorage(completion: @escaping ()->Void)
}


class JsonStorage: Storage {

    let appStateJson = PersistentValue<AppStateDef>(path: "app_state.json")
    let roomStores = StoreDictionary<String, JsonRoomStore>(rootPath: "rooms")
    let gameStores = StoreDictionary<String, JsonGameStore>(rootPath: "games")
    let imageFileStore = ImageFileStore(rootPath: "images")

    private var loadingGroup: DispatchGroup?

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

    var imageStore: ImageStore {
        return self.imageFileStore
    }

    func roomStore(roomId: String) -> RoomStore {
        return self.roomStores.get(roomId)
    }

    func gameStore(gameId: String) -> GameStore {
        return self.gameStores.get(gameId)
    }

    func gameExists(gameId: String) -> Bool {
        return self.gameStores.hasStore(gameId)
    }

    func loadStorage(completion: @escaping ()->Void) {
        if self.loadingGroup == nil {
            self.loadingGroup = DispatchGroup()
            self.roomStores.loadStores(group: self.loadingGroup!)
            self.gameStores.loadStores(group: self.loadingGroup!)
            self.appStateJson.load(group: self.loadingGroup!)
            self.imageFileStore.load(group: self.loadingGroup!)
        }
        self.loadingGroup!.notify(queue: .main, execute: completion)
    }
}
