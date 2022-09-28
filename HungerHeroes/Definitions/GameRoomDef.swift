//
//  GameRoomDef.swift
//  HungerHeroes
//
//  Created by onegray on 21.09.22.
//

import Foundation

struct GameRoomDef: Codable, Equatable {

    let roomId: Int
    let roomTitle: String
    let gamePackId: String
    let mapName: String

    let players: [RoomPlayerDef]
}

extension GameRoomDef {

    struct RoomPlayerDef: Codable, Equatable {
        let id: Int
        let team: Int
        let name: String
        let speciality: PlayerDef.Speciality
        let avatar: String?
    }
}
