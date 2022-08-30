//
// Created by onegray on 30.08.22.
//

import Foundation

protocol GameStoreProtocol {
    func save(gamePack: GamePackDef, files: [String : Data], completion: (()->Void)?)
}

class GameStore: StoreDictionaryProtocol {

    let gamePack: PersistentValue<GamePackDef>
    let images: ImageStore

    required init(path: String) {
        self.gamePack = .init(path: path + "/game.json")
        self.images = .init(rootPath: path + "/images/")
    }

    func load(completion: (() -> Void)?) {
        self.gamePack.load {
            self.images.load(completion: completion)
        }
    }
}

extension GameStore: GameStoreProtocol {

    func save(gamePack: GamePackDef, files: [String : Data], completion: (()->Void)?) {
        self.gamePack.save(gamePack)
        for (fileId, data) in files {
            self.images.saveImageFile(fileId: fileId, data: data) { _ in
                completion?()
            }
        }
    }
}
