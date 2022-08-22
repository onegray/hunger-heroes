//
//  Created by sergeyn on 03.09.20.
//

import Foundation

class PersistentDictionary<K: Codable & Hashable, T: Codable> {

    let persistentDictionary: PersistentValue<[K:T]>

    init(filepath: String, dispatchQueue: DispatchQueue? = nil) {
        persistentDictionary = PersistentValue<[K:T]>(filepath: filepath, dispatchQueue: dispatchQueue)
    }

    func get(by key: K) -> T? {
        if let dictionary = persistentDictionary.get() {
            return dictionary[key]
        }
        return nil
    }

    func getValues() -> [T]? {
        if let dictionary = persistentDictionary.get() {
            return Array(dictionary.values)
        }
        return nil
    }

    func getKeys() -> [K]? {
        if let dictionary = persistentDictionary.get() {
            return Array(dictionary.keys)
        }
        return nil
    }

    func getDictionary() -> [K:T] {
        return persistentDictionary.cachedValue ?? [K:T]()
    }

    func save(_ value: T, by key: K) {
        var dictionary = getDictionary()
        dictionary[key] = value
        persistentDictionary.save(dictionary)
    }

    func load(completion: (()->())? = nil) {
        persistentDictionary.load(completion: completion)
    }
}
