//
//  GetGamePack.swift
//  HungerHeroes
//
//  Created by onegray on 24.08.22.
//

import Foundation

class GetGamePackRequest: HttpRequest {

    init(packName: String, handler: @escaping (GetGamePackResponse) -> Void) {
        super.init(path: "games/" + packName, method: .get, handler: handler)
    }

    override func prepareHeaders(defaultHeaders: [String : String]?) -> [String : String]? {
        return ["Accept-Encoding" : "gzip"]
    }
}


class GetGamePackResponse: HttpResponse {

    var gamePack: GamePackDef?
    var files = [String : Data]()

    required init(data: Data?, code: Int) {
        super.init(data: data, code: code)
        if let data = data {
            let responseFiles = try? TapeArchive().parseFiles(data: data)
            print(responseFiles as Any)

            guard let scenarioData = responseFiles?["scenario.json"] else { return }
            let scenario = try! JSONDecoder().decode(ScenarioDef.self, from: scenarioData)

            guard let mapData = responseFiles?["map/map.json"] else { return }
            let map = (try! JSONDecoder().decode(MapResponse.self, from: mapData)).mapDef

            guard let mapImage = responseFiles?["map/" + map.imageId] else { return }
            self.files[map.imageId] = mapImage

            self.gamePack = GamePackDef(scenario: scenario, map: map, date: .now)
        }
    }

    required init(error: Error, code: Int) {
        super.init(error: error, code: code)
    }
}

extension GetGamePackResponse {
    struct MapResponse: Decodable {
        let id: Int
        let name: String
        let file: String
        let size: Size
        let location: LocationPoint
    }
}

extension GetGamePackResponse.MapResponse {
    var mapDef: MapDef {
        MapDef(mapId: self.id, imageId: self.file, name: self.name,
               size: self.size, location: self.location)
    }
}
