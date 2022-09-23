//
//  Created by sergeyn on 03.09.20.
//

import Foundation

class PersistentValue<T: Codable> {

    let fileURL: URL
    let queue: DispatchQueue
    private var cachedValue: T?
    private let version = AtomicCounter()

    init(path: String, dispatchQueue: DispatchQueue? = nil) {
        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        self.fileURL = directory.appendingPathComponent(path, isDirectory: false)
        self.queue = dispatchQueue ?? DispatchQueue(label: "PersistentValue<\(T.self)>.queue")
    }

    func isLoaded() -> Bool {
        return self.version.get() > 0
    }

    func get() -> T? {
        assert(isLoaded() || !FileManager.default.fileExists(atPath: self.fileURL.path),
               "Getting value of not loaded file: \(self.fileURL.lastPathComponent)")
        return self.cachedValue
    }

    func save(_ value: T?) {
        if self.cachedValue == nil && value == nil {
            return
        }
        self.cachedValue = value
        let valueVersion = self.version.get(increment: true)

        self.queue.async {

            if valueVersion == self.version.get() {

                if value == nil {

                    do {
                        try FileManager.default.removeItem(at: self.fileURL)
                    } catch let e {
                        assert(false, "PersistentValue<\(T.self)> delete failed: \(e)")
                    }

                } else if let jsonData = try? JSONEncoder().encode(value!) {

                    do {
                        try jsonData.write(to: self.fileURL, options: [.atomic])
                    } catch {
                        do {
                            let dirPath = self.fileURL.deletingLastPathComponent()
                            try FileManager.default.createDirectory(
                                at: dirPath, withIntermediateDirectories: true, attributes: nil)
                            try jsonData.write(to: self.fileURL, options: [.atomic])
                        } catch let e {
                            assert(false, "\(type(of: self)):  \(e)")
                        }
                    }

                } else {
                    assert(false, "PersistentValue<\(T.self)> encode failed")
                }
            }
        }
    }

    func readValue() -> T? {
        if let jsonData = try? Data(contentsOf: self.fileURL) {
            return try? JSONDecoder().decode(T.self, from: jsonData)
        }
        return nil
    }

    func load(group: DispatchGroup) {
        group.enter()
        self.queue.async {
            assert(self.version.get(increment: true) == 1, "Value updated while loading")
            self.cachedValue = self.readValue()
            group.leave()
        }
    }

    func load(queue completionQueue: DispatchQueue, completion: @escaping ()->Void) {
        self.queue.async {
            let value = self.readValue()
            completionQueue.async {
                assert(self.version.get(increment: true) == 1, "Value updated while loading")
                self.cachedValue = value
            }
        }
    }
}

extension PersistentValue {

    class AtomicCounter {
        private var value: Int = 0
        private let accessSemaphore = DispatchSemaphore(value: 1)

        func get(increment: Bool = false) -> Int {
            self.accessSemaphore.wait()
            defer { self.accessSemaphore.signal() }
            if increment {
                self.value = self.value.addingReportingOverflow(1).partialValue
            }
            return self.value
        }
    }
}
