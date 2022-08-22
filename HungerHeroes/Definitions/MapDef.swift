//
//  MapDef.swift
//  HungerHeroes
//
//  Created by onegray on 22.08.22.
//

import Foundation

struct MapDef: Equatable, Codable {
    let mapId: Int
    let imageId: String
    let name: String
    let size: Size
    let location: LocationPoint
}
