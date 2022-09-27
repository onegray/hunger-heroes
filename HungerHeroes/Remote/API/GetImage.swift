//
// Created by onegray on 27.09.22.
//

import Foundation

class GetImageRequest: HttpRequest {
    init(imageId: String, handler: @escaping (GetImageResponse)->Void) {
        super.init(path: "images/\(imageId).png", method: .get, handler: handler)
    }
}

class GetImageResponse: HttpResponse {

    var imageData: Data?

    required init(data: Data?, code: Int) {
        super.init(data: data, code: code)
        self.imageData = data
    }

    required init(error: Error, code: Int) {
        super.init(error: error, code: code)
    }
}


