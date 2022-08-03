//
//  Artifact.swift
//  HungerHeroes
//
//  Created by onegray on 3.08.22.
//

import Foundation
import CoreGraphics

class Artifact: MapNode {

    let title: String
    
    internal init(title: String) {
        self.title = title
        super.init(location: .zero)
    }
}


