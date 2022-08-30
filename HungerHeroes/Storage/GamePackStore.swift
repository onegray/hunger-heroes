//
// Created by onegray on 30.08.22.
//

import Foundation

protocol GamePackStoreProtocol {
    func save(gamePack: GamePackDef, files: [String : Data])
}

class GamePackStore: StoreDictionaryProtocol {

    let gamePack: PersistentValue<GamePackDef>
    let images: ImageStore

    required init(path: String) {
        self.gamePack = .init(path: "game.json")
        self.images = .init(rootPath: "images/")
    }

    func load(completion: (() -> Void)?) {
        self.gamePack.load {
            self.images.load(completion: completion)
        }
    }
}

extension GamePackStore: GamePackStoreProtocol {

    func save(gamePack: GamePackDef, files: [String : Data]) {
        self.gamePack.save(gamePack)
        for (fileId, data) in files {
            self.images.saveImageFile(fileId: fileId, data: data, completion: nil)
        }
    }
}
