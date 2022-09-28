//
// Created by onegray on 28.09.22.
//

import Foundation

extension PlayerDef.Speciality {
    var string: String {
        switch self {
        case .assassin:
            return "Assassin"
        case .killer:
            return "Killer"
        case .scout:
            return "Scout"
        case .snipper:
            return "Snipper"
        case .runner:
            return "Runer"
        }
    }
}
