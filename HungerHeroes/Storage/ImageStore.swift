//
// Created by onegray on 30.08.22.
//

import Foundation

class ImageStore {

    let files: FileRegistry

    init(rootPath: String) {
        self.files = .init(rootPath: rootPath)
    }

    func getImage(fileId: String) -> ImageSource? {
        if self.files.fileList.contains(fileId) {
            return ImageFileSource(fileUrl: self.files.fileUrl(fileId: fileId))
        }
        return nil
    }

    func saveImageFile(fileId: String, data: Data, completion: ((ImageSource?)->Void)?) {
        self.files.save(fileId: fileId, fileData: data) { url in
            let image = url != nil ? ImageFileSource(fileUrl: url!) : nil
            completion?(image)
        }
    }

    func load(completion: (()->Void)?) {
        self.files.load(completion: completion)
    }
}
