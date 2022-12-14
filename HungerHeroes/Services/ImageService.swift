//
// Created by onegray on 27.09.22.
//

import Foundation

protocol ImageService {
    func getPlayerAvatar(imageId: String) -> ImageSource?
}

class AppImageService: ImageService {
    let store: ImageStore
    let httpClient: HttpClientProtocol

    init(store: ImageStore, httpClient: HttpClientProtocol) {
        self.store = store
        self.httpClient = httpClient
    }

    func getPlayerAvatar(imageId: String) -> ImageSource? {
        let ds = RemoteImageDataSource(imageId: imageId, httpClient: self.httpClient)
        return CachedImageSource(dataSource: ds, imageId: imageId, store: self.store)
    }
}

class RemoteImageDataSource: ImageDataSource {

    let httpClient: HttpClientProtocol
    let imageId: String

    init(imageId: String, httpClient: HttpClientProtocol) {
        self.imageId = imageId
        self.httpClient = httpClient
    }

    func getData(_ handler: @escaping (Data?) -> Void) {
        let request = GetImageRequest(imageId: self.imageId) { response in
            if case .success = response.status {
                handler(response.imageData)
            } else {
                handler(nil)
            }
        }
        self.httpClient.perform(request)
    }
}
