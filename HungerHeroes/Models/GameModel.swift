//
//  GameModel.swift
//  HungerHeroes
//
//  Created by onegray on 27.08.22.
//

import Foundation


class GameModel {
    
    let map: MapModel
    var heroes: [Hero] = []
    var objects: [MapNode] = []
    
    init(map: MapModel) {
        self.map = map
    }
}

