//
// Created by onegray on 1.09.22.
//

import Foundation

struct ScoutSteps {
    var points: [Point]
    let radius: Int

    init(radius: Int) {
        self.radius = radius
        self.points = []
    }
}

extension ScoutSteps {

    var isEmpty: Bool {
        return self.points.isEmpty
    }

    mutating func step(to point: Point) {
        self.points.append(point)
    }

    mutating func clear() {
        self.points = []
    }
}
