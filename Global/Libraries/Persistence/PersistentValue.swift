//
//  Created by sergeyn on 03.09.20.
//

import Foundation

class PersistentValue<T: Codable> {

    let fileURL: URL

    var cachedValue: T?
    var isLoaded: Bool = false
    let version = AtomicCounter()

    let queue: DispatchQueue

    init(filepath: String, dispatchQueue: DispatchQueue? = nil) {
        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        fileURL = directory.appendingPathComponent(filepath)
        queue = dispatchQueue ?? DispatchQueue(label: "PersistentValue<\(T.self)>.queue")
    }

    func get() -> T? {
        return cachedValue
    }

    func save(_ value: T?, completion: (()->())? = nil) {
        isLoaded = true

        if cachedValue == nil && value == nil {
            return
        }

        cachedValue = value
        let versionValue = self.version.get(increment: true)

        queue.async {

            var lastVersion: Int = 0
            lastVersion = self.version.get()

            if versionValue == lastVersion {

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

            if completion != nil {
                DispatchQueue.main.async { completion?() }
            }
        }
    }

    func load(completion: (()->())? = nil) {
        isLoaded = false
        queue.async {
            var value: T? = nil
            if let jsonData = try? Data(contentsOf: self.fileURL) {
                value = try? JSONDecoder().decode(T.self, from: jsonData)
            }

            DispatchQueue.main.async {
                if !self.isLoaded {
                    self.cachedValue = value
                    self.isLoaded = true
                }
                completion?()
            }
        }
    }
}

extension PersistentValue {

    class AtomicCounter {
        var value: Int = 0
        let accessSemaphore = DispatchSemaphore(value: 1)

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
