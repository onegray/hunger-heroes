//
// Created by onegray on 9.09.22.
//

import UIKit

class MapObjectView: UIImageView {

    var location: Point = Point(x: 0, y: 0)
    {
        didSet {
            self.updatePosition()
        }
    }

    var mapZoom: CGFloat = 1.0
    {
        didSet {
            self.updatePosition()
        }
    }

    func updatePosition() {
        let x = CGFloat(self.location.x) * self.mapZoom
        let y = CGFloat(self.location.y) * self.mapZoom
        self.center = CGPoint(x: x, y: y)
    }
}
