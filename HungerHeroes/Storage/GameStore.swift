//
// Created by onegray on 30.08.22.
//

import Foundation

protocol GameStore {
    var gamePack: GamePackDef? { get }
    func save(gamePack: GamePackDef, files: [String : Data], completion: (()->Void)?)
    func getImage(fileId: String) -> ImageSource?
}

class JsonGameStore: StoreDictionaryProtocol {

    let gamePackJson: PersistentValue<GamePackDef>

    let imageStore: ImageStore

    required init(path: String) {
        self.gamePackJson = .init(path: path + "/game.json")
        self.imageStore = .init(rootPath: path + "/images/")
    }

    func load(completion: (() -> Void)?) {
        self.gamePackJson.load {
            self.imageStore.load(completion: completion)
        }
    }
}


extension JsonGameStore: GameStore {

    var gamePack: GamePackDef? { self.gamePackJson.get() }

    func getImage(fileId: String) -> ImageSource? {
        return self.imageStore.getImage(fileId: fileId)
    }

    func save(gamePack: GamePackDef, files: [String : Data], completion: (()->Void)?) {
        self.gamePackJson.save(gamePack)
        for (fileId, data) in files {
            self.imageStore.saveImageFile(fileId: fileId, data: data) { _ in
                completion?()
            }
        }
    }
}
