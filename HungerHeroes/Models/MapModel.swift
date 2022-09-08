//
//  MapModel.swift
//  HungerHeroes
//
//  Created by onegray on 27.08.22.
//

import Foundation
import CoreGraphics

class MapModel {

    let name: String
    let image: ImageSource
    let size: Size
    let location: LocationPoint

    var fowImage: CGImage?

    init(name: String, image: ImageSource, size: Size, location: LocationPoint) {
        self.name = name
        self.image = image
        self.size = size
        self.location = location
    }
}

extension MapModel {

    static func new(def: MapDef, store: GameStore) throws -> MapModel {
        guard let image = store.getImage(fileId: def.imageId) else {
            throw ModelError.loadError
        }
        return MapModel(name: def.name, image: image, size: def.size, location: def.location)
    }

    func createFow(completion: (()->Void)?) {
        let sz = self.size
        DispatchQueue.global().async {
            let fowImage = CGImage.blankAlphaOnlyImage(width: sz.width / 16, height: sz.height / 16)
            DispatchQueue.main.async {
                self.fowImage = fowImage
                completion?()
            }
        }
    }

    func updateFow(updates: [ScoutSteps], completion: (()->Void)?) {
        let sourceFow = self.fowImage
        DispatchQueue.global().async {
            let lines = updates.map { (scout) -> PolyLine in
                let lineWidth = (scout.polyLine.width + 15) / 16
                let points = scout.polyLine.points.map({ Point(x: $0.x/16, y: $0.y/16) })
                return PolyLine(points: points, width: lineWidth)
            }
            let updatedFow = sourceFow?.imageClearLines(lines)
            DispatchQueue.main.async {
                self.fowImage = updatedFow
                completion?()
            }
        }
    }
}
