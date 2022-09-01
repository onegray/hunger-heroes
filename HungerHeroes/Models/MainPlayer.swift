//
//  MainPlayer.swift
//  HungerHeroes
//
//  Created by onegray on 3.08.22.
//

import Foundation

class MainPlayer: MapNode {
    let player: Player

    var health: Int
    var gameAge: Int
    var attack: Int
    var defence: Int

    internal init(player: Player) {
        self.player = player
        self.health = 100
        self.gameAge = 0
        self.attack = 0;
        self.defence = 0;
        super.init()
    }
}
