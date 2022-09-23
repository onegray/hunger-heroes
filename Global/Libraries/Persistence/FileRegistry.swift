//
// Created by onegray on 03.09.20.
//

import Foundation


class FileRegistry {

    let rootPath: String
    let queue: DispatchQueue
    var fileList = Set<String>()

    init(rootPath: String, queue: DispatchQueue? = nil) {
        self.rootPath = rootPath.hasSuffix("/") ? rootPath : rootPath + "/"
        self.queue = queue ?? DispatchQueue(label: "FileRegistry.queue")
    }

    func readContents() -> [String]? {
        let documentsDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let dirPath = documentsDir + "/" + self.rootPath
        return try? FileManager.default.contentsOfDirectory(atPath: dirPath)
    }

    func load(group: DispatchGroup) {
        group.enter()
        self.queue.async {
            if let content = self.readContents() {
                self.fileList = .init(content)
            }
            group.leave()
        }
    }

    func load(queue completionQueue: DispatchQueue, completion: (()->Void)? = nil) {
        self.queue.async {
            let content = self.readContents()
            completionQueue.async {
                if let content = content {
                    self.fileList = .init(content)
                }
                completion?()
            }
        }
    }

    func save(fileId: String, fileData: Data, queue completionQueue: DispatchQueue, completion: ((URL?)->Void)?) {
        self.queue.async {
            var url: URL? = self.fileUrl(fileId: fileId)
            do {
                try fileData.write(to: url!, options: .atomic)
            } catch {
                do {
                    let dir = url!.deletingLastPathComponent()
                    try FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
                    try fileData.write(to: url!, options: .atomic)
                } catch let e {
                    url = nil
                    assert(false, "\(type(of: self)):  \(e)")
                }
            }
            completionQueue.async {
                if url != nil {
                    self.fileList.insert(fileId)
                }
                completion?(url)
            }
        }
    }

    func fileUrl(fileId: String) -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                .appendingPathComponent(self.rootPath, isDirectory: true)
                .appendingPathComponent(fileId, isDirectory: false)
    }
}
