//
//  Geometry.swift
//  HungerHeroes
//
//  Created by onegray on 21.08.22.
//

import Foundation
import CoreGraphics

struct Point: Equatable, Codable {
    var x: Int
    var y: Int
}

struct Size: Equatable, Codable {
    let width: Int
    let height: Int
}

struct Rect: Equatable, Codable {
    let origin: Point
    let size: Size
}

struct Circle: Equatable, Codable {
    let origin: Point
    let radius: Int
}

struct Vector: Equatable, Codable {
    let dx: Int
    let dy: Int
}

struct PolyLine: Equatable, Codable {
    var points: [Point]
    let width: Int
}


extension Point {
    var cgPoint: CGPoint {
        return CGPoint(x: self.x, y: self.y)
    }
}
