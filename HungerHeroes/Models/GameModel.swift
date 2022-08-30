//
//  GameModel.swift
//  HungerHeroes
//
//  Created by onegray on 27.08.22.
//

import Foundation

class GameModel {

    let map: MapModel
    let scenario: ScenarioDef
    var heroes: [Hero]
    var objects: [MapNode]

    init(map: MapModel, scenario: ScenarioDef) {
        self.map = map
        self.scenario = scenario
        self.heroes = []
        self.objects = []
    }
}

extension GameModel {

    static func new(gameId: String, store: GameStore) throws -> GameModel {
        guard let gamePack = store.gamePack.get() else {
            throw ModelError.loadError
        }
        let map = try MapModel.new(def: gamePack.map, store: store)
        return GameModel(map: map, scenario: gamePack.scenario)
    }
}
