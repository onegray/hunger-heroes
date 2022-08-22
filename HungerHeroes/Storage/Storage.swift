//
//  Storage.swift
//  HungerHeroes
//
//  Created by onegray on 22.08.22.
//

import Foundation

protocol Storage {
    var scenario: PersistentValue<ScenarioDef> { get }
    var map: PersistentValue<MapDef> { get }
}


class FileStorage: Storage {

    let scenario = PersistentValue<ScenarioDef>(filepath: "scenario.json")
    let map = PersistentValue<MapDef>(filepath: "map.json")    
}
