//
// Created by onegray on 03.09.20.
//

import Foundation

protocol StoreDictionaryProtocol {
    init(path: String)
    func load(completion: (()->Void)?)
}

class StoreDictionary<KeyType: Hashable, Store: StoreDictionaryProtocol> {

    var storeDictionary = [KeyType : Store]()
    let rootPath: String

    init(rootPath: String) {
        self.rootPath = rootPath.hasSuffix("/") ? rootPath : rootPath + "/"
    }

    func storePath(_ storeKey: KeyType) -> String {
        return self.rootPath + "\(storeKey)"
    }

    func get(_ storeKey: KeyType) -> Store {
        if let store = self.storeDictionary[storeKey] {
            return store
        } else {
            let store = Store(path: self.storePath(storeKey))
            self.storeDictionary[storeKey] = store
            return store
        }
    }

    func load(ids: [KeyType]?, completion: (()->Void)?) {
        guard var expectation = ids?.count, expectation > 0 else {
            completion?()
            return
        }
        ids?.forEach { storeKey in
            let store = get(storeKey)
            store.load {
                expectation -= 1
                if expectation == 0 {
                    completion?()
                }
            }
        }
    }

    func loadDirectory(completion: @escaping ([String]?)->Void) {
        DispatchQueue.global().async {
            let docDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let url = docDir.appendingPathComponent(self.rootPath, isDirectory: true)
            let contents = try? FileManager.default.contentsOfDirectory(atPath: url.path)
            let items = contents?.map({ ($0 as NSString).lastPathComponent })
            DispatchQueue.main.async {
                completion(items)
            }
        }
    }

    func hasStore(_ storeKey: KeyType) -> Bool {
        return self.storeDictionary[storeKey] != nil
    }
}
