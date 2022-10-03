//
//  Hero.swift
//  HungerHeroes
//
//  Created by onegray on 3.08.22.
//

import Foundation

class HeroModel: MapNode {

    let player: PlayerDef
    let team: Int
    var health: Int
    var ammo: Int
    var scouting: Int
    var scoutSteps: ScoutSteps

    init(player: PlayerDef, team: Int) {
        self.player = player
        self.team = team
        self.health = 0
        self.ammo = 0
        self.scouting = 250
        self.scoutSteps = ScoutSteps(radius: self.scouting)
        super.init()
    }
}

extension HeroModel {

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
