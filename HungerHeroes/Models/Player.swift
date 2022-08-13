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
        let frags: Int
        let kdrate: Int
        let accuracy: Int
        let points: Int
    }
}
