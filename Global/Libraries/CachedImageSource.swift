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
    private var requestingGroup: DispatchGroup?

    init(dataSource: ImageDataSource, imageId: String, store: ImageStore) {
        self.dataSource = dataSource
        self.imageId = imageId
        self.store = store
    }

    func getImage(_ handler: @escaping (CGImage?) -> Void) {
        if let imageSource = self.cachedImageSource ?? self.store.getImage(imageId: self.imageId) {
            self.cachedImageSource = imageSource
            imageSource.getImage(handler)
        } else {
            var group = self.requestingGroup
            if group == nil {
                group = DispatchGroup()
                self.requestingGroup = group
                group!.enter()
                self.dataSource.getData { data in
                    if let imageData = data {
                        self.store.saveImage(imageId: self.imageId, data: imageData) { source in
                            self.cachedImageSource = source
                            group!.leave()
                        }
                    } else {
                        group!.leave()
                        self.requestingGroup = nil
                    }
                }
            }
            group!.notify(queue: .main) {
                if let imageSource = self.cachedImageSource {
                    imageSource.getImage(handler)
                } else {
                    handler(nil)
                }
            }
        }
    }
}
