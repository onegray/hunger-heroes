//
//  Player.swift
//  HungerHeroes
//
//  Created by onegray on 3.08.22.
//

import Foundation

struct PlayerDef: Codable, Equatable {
    let id: Int
    let name: String
    let speciality: Speciality
    let avatar: String?
    let stats: Stats?
}


extension PlayerDef {

    enum Speciality: Int, Codable {
        case assassin
        case killer
        case scout
        case snipper
        case runner
    }

    struct Stats: Codable, Equatable {
        let efficiency: Int
        let score: Int
        let hitRate: Int
        let kdRate: Int
        let frags: Int
        let gameTime: Int
        let winRate: Int
        let looseRate: Int
    }
}

extension PlayerDef {
    static func testPlayer(id: Int) -> PlayerDef {
        return PlayerDef(id: id, name: "Player\(id)",
                         speciality: .scout, avatar: nil, stats: nil)
    }
}
