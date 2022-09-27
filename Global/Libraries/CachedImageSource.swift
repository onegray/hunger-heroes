//
// Created by onegray on 27.09.22.
//

import Foundation
import CoreGraphics

protocol ImageDataSource: AnyObject {
    func getData(_ handler: @escaping (Data?)->Void)
}

class CachedImageSource: ImageSource {
    let imageId: String
    let store: ImageStore
    let dataSource: ImageDataSource
    private var cachedImageSource: ImageSource?

    init(dataSource: ImageDataSource, imageId: String, store: ImageStore) {
        self.dataSource = dataSource
        self.imageId = imageId
        self.store = store
    }

    func getImage(_ handler: @escaping (CGImage?) -> Void) {
        if let cachedSource = self.cachedImageSource ?? self.store.getImage(fileId: self.imageId) {
            self.cachedImageSource = cachedSource
            cachedSource.getImage(handler)
        } else {
            self.dataSource.getData { data in
                if let imageData = data {
                    self.store.saveImageFile(fileId: self.imageId, data: imageData) { source in
                        if let imageSource = source {
                            imageSource.getImage(handler)
                        } else {
                            handler(nil)
                        }
                    }
                } else {
                    handler(nil)
                }
            }
        }
    }
}
