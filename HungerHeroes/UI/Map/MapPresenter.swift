//
//  MapPresenter.swift
//  HungerHeroes
//
//  Created by onegray on 27.08.22.
//

import Foundation
import Combine
import CoreGraphics

protocol MapPresenterProtocol {
    var viewModel: MapViewModel { get }
}

class MapPresenter: MapPresenterProtocol {

    var viewModel: MapViewModel
    var gameService: GameService
    var disposeBag = Set<AnyCancellable>()

    init(viewModel: MapViewModel, gameService: GameService) {
        self.viewModel = viewModel
        self.gameService = gameService

        self.gameService.onUpdate.filter { $0 == .mapUpdate }
                .sink { [weak self] _ in
                    self?.onMapUpdate(map: self?.gameService.game?.map)
                }
                .store(in: &self.disposeBag)

    }

    func onMapUpdate(map: MapModel?) {
        if let map = map {
            self.viewModel.mapSize = CGSize(width: map.size.width, height: map.size.height)
            self.viewModel.mapImage = nil
            map.image.getImage { image in
                self.viewModel.mapImage = image
            }
        }
    }
}
