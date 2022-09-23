//
// Created by onegray on 03.09.20.
//

import Foundation

protocol StoreDictionaryProtocol {
    init(path: String)
    func load(group: DispatchGroup)
}

class StoreDictionary<KeyType: Hashable, Store: StoreDictionaryProtocol> {

    private var storeDictionary = [KeyType : Store]()
    let rootPath: String
    let queue: DispatchQueue

    init(rootPath: String, queue: DispatchQueue? = nil) {
        self.rootPath = rootPath.hasSuffix("/") ? rootPath : rootPath + "/"
        self.queue = queue ?? DispatchQueue.global()
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

    func readContents() -> [String]? {
        let docDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let url = docDir.appendingPathComponent(self.rootPath, isDirectory: true)
        let contents = try? FileManager.default.contentsOfDirectory(atPath: url.path)
        return contents?.map({ ($0 as NSString).lastPathComponent })
    }

    func loadDirectory(queue completionQueue: DispatchQueue, completion: @escaping ([String]?)->Void) {
        self.queue.async {
            let items = self.readContents()
            completionQueue.async {
                completion(items)
            }
        }
    }

    func load(ids: [KeyType]?, group: DispatchGroup) {
        ids?.forEach { self.get($0).load(group: group) }
    }

    func hasStore(_ storeKey: KeyType) -> Bool {
        return self.storeDictionary[storeKey] != nil
    }
}

extension StoreDictionary where KeyType: LosslessStringConvertible {

    func loadStores(group: DispatchGroup) {
        group.enter()
        self.queue.async {
            if let contents = self.readContents() {
                contents.forEach { (item: String) in
                    if let key = KeyType.init(item) {
                        self.get(key).load(group: group)
                    }
                }
            }
            group.leave()
        }
    }
}
