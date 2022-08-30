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

    func load(completion: (()->Void)? = nil) {
        self.queue.async {
            let documentsDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
            let dirPath = documentsDir + "/" + self.rootPath
            let content = try? FileManager.default.contentsOfDirectory(atPath: dirPath)
            DispatchQueue.main.async {
                if content != nil {
                    self.fileList = .init(content!)
                }
                completion?()
            }
        }
    }

    func save(fileId: String, fileData: Data, completion: ((URL?)->Void)?) {
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
            DispatchQueue.main.async {
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
