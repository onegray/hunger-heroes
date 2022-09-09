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
    @Published var fowMaskImage: CGImage?

    @Published var actor: HeroViewModel?
    @Published var heroes: [HeroViewModel] = []
}

struct HeroViewModel {
    let id: Int?
    let team: Int?
    let name: String?
    let location: Point
}
