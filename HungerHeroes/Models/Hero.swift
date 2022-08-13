//
//  Hero.swift
//  HungerHeroes
//
//  Created by onegray on 3.08.22.
//

import Foundation
import CoreGraphics

class Hero: MapNode {

    let player: Player
    let health: Int
    let ammo: Int
    
    internal init(player: Player, health: Int, ammo: Int) {
        self.player = player
        self.health = health
        self.ammo = ammo
        super.init(location: .zero)
    }
}

