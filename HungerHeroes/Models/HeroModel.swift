//
//  Hero.swift
//  HungerHeroes
//
//  Created by onegray on 3.08.22.
//

import Foundation

class HeroModel: MapNode {

    let player: Player?
    var health: Int
    var ammo: Int
    var scouting: Int
    var scoutSteps: ScoutSteps

    init(player: Player?) {
        self.player = player
        self.health = 0
        self.ammo = 0
        self.scouting = 100
        self.scoutSteps = ScoutSteps(radius: self.scouting)
        super.init()
    }
}

extension HeroModel {

    static func new() -> HeroModel {
        return HeroModel(player: nil)
    }

    func updateLocation(location: Point) {
        self.location = location
        self.scoutSteps.step(to: location)
    }

    func pullScoutSteps(acc: inout [ScoutSteps]) {
        if !self.scoutSteps.isEmpty {
            acc.append(self.scoutSteps)
            self.scoutSteps.clear()
        }
    }
}
