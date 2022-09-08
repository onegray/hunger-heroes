//
// Created by onegray on 1.09.22.
//

import Foundation

struct ScoutSteps {
    var polyLine: PolyLine

    init(radius: Int) {
        self.polyLine = PolyLine(points: [], width: radius)
    }
}

extension ScoutSteps {

    var isEmpty: Bool {
        return self.polyLine.points.isEmpty
    }

    mutating func step(to point: Point) {
        self.polyLine.points.append(point)
    }

    mutating func clear() {
        self.polyLine.points = []
    }
}
