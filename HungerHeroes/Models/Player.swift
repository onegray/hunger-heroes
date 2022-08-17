//
//  Player.swift
//  HungerHeroes
//
//  Created by onegray on 3.08.22.
//

import Foundation
import UIKit

struct Player {
    let id: Int
    let team: Int
    let name: String
    let speciality: Speciality
    let avatar: UIImage
    let stats: Stats
}


extension Player {
    
    enum Speciality: Int {
        case killer
        case scout
        case snipper
        case runner
    }

    struct Stats {
        let efficiency: Int
        let score: Int
        let hitRate: Int
        let kdRate: Int
        let frags: Int
        let gameTime: Int
        let winRate: Int
        let looseRate: Int
    }
}

