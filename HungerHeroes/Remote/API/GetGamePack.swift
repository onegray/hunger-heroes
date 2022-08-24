//
//  GetGamePack.swift
//  HungerHeroes
//
//  Created by onegray on 24.08.22.
//

import Foundation

class GetGamePackRequest: HttpRequest {

    init(packName: String, handler: @escaping (GetGamePackResponse) -> Void) {
        super.init(path: "games/\(packName)", method: .get, handler: handler)
    }

    override func prepareHeaders(defaultHeaders: [String : String]?) -> [String : String]? {
        return ["Accept-Encoding" : "gzip"]
    }
}


class GetGamePackResponse: HttpResponse {

    var mapData: Data?

    required init(data: Data?, code: Int) {
        super.init(data: data, code: code)
        if let data = data {
            let files = try? TapeArchive().parseFiles(data: data)
            print(files as Any)
            self.mapData = files?["map/map3x2s.heif"]
        }
    }

    required init(error: Error, code: Int) {
        super.init(error: error, code: code)
    }
}
