//
// Created by onegray on 30.08.22.
//

import Foundation

protocol ImageStore {
    func getImage(imageId: String) -> ImageSource?
    func saveImage(imageId: String, data: Data, completion: ((ImageSource?)->Void)?)
}

class ImageFileStore: ImageStore {

    private let files: FileRegistry

    init(rootPath: String) {
        self.files = .init(rootPath: rootPath)
    }

    func getImage(imageId: String) -> ImageSource? {
        if self.files.fileList.contains(imageId) {
            return ImageFileSource(fileUrl: self.files.fileUrl(fileId: imageId))
        }
        return nil
    }

    func saveImage(imageId: String, data: Data, completion: ((ImageSource?)->Void)?) {
        self.files.save(fileId: imageId, fileData: data, queue: .main) { url in
            let image = url != nil ? ImageFileSource(fileUrl: url!) : nil
            completion?(image)
        }
    }

    func load(group: DispatchGroup) {
        self.files.load(group: group)
    }
}
