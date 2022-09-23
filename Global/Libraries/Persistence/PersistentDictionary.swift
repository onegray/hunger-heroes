//
//  Created by sergeyn on 03.09.20.
//

import Foundation

class PersistentDictionary<K: Codable & Hashable, T: Codable> {

    private let persistentDictionary: PersistentValue<[K:T]>

    init(filepath: String, dispatchQueue: DispatchQueue? = nil) {
        self.persistentDictionary = PersistentValue<[K:T]>(path: filepath, dispatchQueue: dispatchQueue)
    }

    func get(by key: K) -> T? {
        if let dictionary = self.persistentDictionary.get() {
            return dictionary[key]
        }
        return nil
    }

    func getValues() -> [T]? {
        if let dictionary = self.persistentDictionary.get() {
            return Array(dictionary.values)
        }
        return nil
    }

    func getKeys() -> [K]? {
        if let dictionary = self.persistentDictionary.get() {
            return Array(dictionary.keys)
        }
        return nil
    }

    func getDictionary() -> [K:T] {
        if self.persistentDictionary.isLoaded(),
           let dictionary = self.persistentDictionary.get() {
            return dictionary
        }
        return [K:T]()
    }

    func save(_ value: T, by key: K) {
        var dictionary = getDictionary()
        dictionary[key] = value
        self.persistentDictionary.save(dictionary)
    }

    func load(group: DispatchGroup) {
        self.persistentDictionary.load(group: group)
    }

    func load(queue: DispatchQueue, completion: @escaping ()->Void) {
        self.persistentDictionary.load(queue: queue, completion: completion)
    }
}
