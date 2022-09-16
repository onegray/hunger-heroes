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
    let fowScale: Int = 16
    var fowImage: ImageSource?

    init(name: String, image: ImageSource, size: Size, location: LocationPoint) {
        self.name = name
        self.image = image
        self.size = size
        self.location = location
    }

    private var cgFowImage: CGImage? // Accessible only from fowQueue
    private let fowQueue: DispatchQueue = DispatchQueue(label: "fow.queue")
}

extension MapModel {

    static func new(def: MapDef, store: GameStore) throws -> MapModel {
        guard let image = store.getImage(fileId: def.imageId) else {
            throw ModelError.loadError
        }
        return MapModel(name: def.name, image: image, size: def.size, location: def.location)
    }

    func createFow() {
        let sz = Size(width: self.size.width / self.fowScale,
                      height: self.size.height / self.fowScale)
        let asyncImage = ImageAsyncSource(queue: self.fowQueue) {
            self.cgFowImage = CGImage.blankAlphaOnlyImage(width: sz.width, height: sz.height)
            return self.cgFowImage
        }
        asyncImage.preload()
        self.fowImage = asyncImage
    }

    func updateFow(updates: [ScoutSteps]) {
        let scale = self.fowScale
        let asyncImage = ImageAsyncSource(queue: self.fowQueue) {
            let lines = updates.map { (scout) -> PolyLine in
                let lineWidth = (scout.polyLine.width + scale - 1) / scale
                let points = scout.polyLine.points.map { Point(x: $0.x/scale, y: $0.y/scale) }
                return PolyLine(points: points, width: lineWidth)
            }
            self.cgFowImage = self.cgFowImage?.imageClearLines(lines)
            return self.cgFowImage
        }
        asyncImage.preload()
        self.fowImage = asyncImage
    }
}
