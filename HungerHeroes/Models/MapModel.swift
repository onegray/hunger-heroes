//
//  MapModel.swift
//  HungerHeroes
//
//  Created by onegray on 27.08.22.
//

import Foundation

struct MapModel {
    let name: String
    let image: ImageSource
    let size: Size
    let location: LocationPoint
}

extension MapModel {

    static func new(def: MapDef, store: GameStore) throws -> MapModel {
        guard let image = store.getImage(fileId: def.imageId) else {
            throw ModelError.loadError
        }
        return MapModel(name: def.name, image: image, size: def.size, location: def.location)
    }
}
