//
// Created by onegray on 24.09.22.
//

import Foundation

protocol RoomStore: AnyObject {

    var room: GameRoomDef? { get set }

}

class JsonRoomStore: StoreDictionaryProtocol {

    var roomJson: PersistentValue<GameRoomDef>
    let imageStore: ImageFileStore

    required init(path: String) {
        self.roomJson = .init(path: path + "/room.json")
        self.imageStore = .init(rootPath: path + "/images")
    }

    func load(group: DispatchGroup) {
        self.roomJson.load(group: group)
        self.imageStore.load(group: group)
    }
}

extension JsonRoomStore: RoomStore {
    var room: GameRoomDef? {
        get { self.roomJson.get() }
        set { self.roomJson.save(newValue) }
    }
}
