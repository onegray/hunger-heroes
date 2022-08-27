//
//  MapViewModel.swift
//  HungerHeroes
//
//  Created by onegray on 27.08.22.
//

import Foundation
import CoreGraphics

class MapViewModel: ObservableObject {

    @Published var mapSize: CGSize = .zero
    @Published var mapImage: CGImage?
    @Published var fowImage: CGImage?

    @Published var actor: VMPlayer?
    @Published var players: [VMPlayer] = []
}


extension MapViewModel {
    struct VMPlayer {
        let id: Int
        let team: Int
        let name: String
    }
}
