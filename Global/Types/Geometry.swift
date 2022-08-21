//
//  Geometry.swift
//  HungerHeroes
//
//  Created by onegray on 21.08.22.
//

import Foundation

struct Point: Equatable, Codable {
    let x: Int
    let y: Int
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
