//
// Created by onegray on 17.09.22.
//

import Foundation
import CoreGraphics

class GameRoomViewModel: ObservableObject {
    @Published var gameTitle: String = ""
    @Published var mapName: String = ""
    @Published var teams: [GameRoomTeam] = []
}

struct GameRoomTeam: Identifiable {
    let id: Int
    let title: String
    let players: [GameRoomPlayer]
}

struct GameRoomPlayer: Identifiable {
    let id: Int
    let name: String
    let icon: CGImage
    let role: String
}
