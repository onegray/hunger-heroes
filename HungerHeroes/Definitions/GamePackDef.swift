//
// Created by onegray on 29.08.22.
//

import Foundation

struct GamePackDef: Equatable, Codable  {
    let scenario: ScenarioDef
    let map: MapDef
    let date: Date
}
