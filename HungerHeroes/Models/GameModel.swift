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
    var heroes: [HeroModel]
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
        guard let gamePack = store.gamePack else {
            throw ModelError.loadError
        }
        let map = try MapModel.new(def: gamePack.map, store: store)
        return GameModel(map: map, scenario: gamePack.scenario)
    }

    func reset(completion: (()->Void)?) {
        self.heroes = []
        self.objects = []
        self.map.createFow(completion: completion)
    }

    func start(setup: GameSetupDef) {
        let sz = self.map.size
        self.heroes = (0..<setup.playersNum).map({ _ in
            let hero = HeroModel.new()
            let location = Point(x: Int(arc4random()) % sz.width,
                                 y: Int(arc4random()) % sz.height)
            hero.updateLocation(location: location)
            return hero
        })

        self.updateFow()
    }

    func updateFow() {
        var scoutUpdates = [ScoutSteps]()
        for hero in self.heroes {
            hero.pullScoutSteps(acc: &scoutUpdates)
        }
        if scoutUpdates.isNotEmpty {
            self.map.updateFow(updates: scoutUpdates)
        }
    }
}
