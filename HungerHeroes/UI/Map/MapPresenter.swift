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
    func loadGame(gameId: String)
}

class MapPresenter: MapPresenterProtocol {

    var viewModel: MapViewModel
    var gameService: GameService
    var disposeBag = Set<AnyCancellable>()

    init(viewModel: MapViewModel, gameService: GameService) {
        self.viewModel = viewModel
        self.gameService = gameService

        self.gameService.onUpdate
                .sink { [weak self] event in
                    guard let self = self, let game = self.gameService.game else { return }
                    switch (event) {
                    case .newGame:
                        self.onNewGame(game: game)
                    case .startGame:
                        self.onStartGame(game: game)
                    case .mapUpdate:
                        self.onMapUpdate(map: game.map)
                    case .heroesUpdate:
                        self.onHeroesUpdate(heroes: game.heroes)
                        self.onFowUpdate(fowImage: game.map.fowImage)
                    default:
                        ()
                    }
                }
                .store(in: &self.disposeBag)
    }

    func onNewGame(game: GameModel) {
        self.onMapUpdate(map: game.map)
        let setup = GameSetupDef(playersNum: 12)
        self.gameService.startGame(setup: setup)
    }

    func onStartGame(game: GameModel) {
        self.onMapUpdate(map: game.map)
        self.onHeroesUpdate(heroes: game.heroes)
    }

    func onMapUpdate(map: MapModel?) {
        if let map = map {
            let mapSize = CGSize(width: map.size.width, height: map.size.height)
            self.viewModel.mapImage = nil
            map.image.getImage { image in
                if let image = image {
                    self.viewModel.mapImage = MapImageViewModel(image: image, size: mapSize)
                }
            }
            self.viewModel.fowMaskImage = map.fowImage
        }
    }

    func onHeroesUpdate(heroes: [HeroModel]) {
        self.viewModel.heroes = heroes.map { (model) -> HeroViewModel  in
            return HeroViewModel(id: model.player.id,
                                 team: model.player.team,
                                 name: model.player.name,
                                 location: model.location)
        }
    }

    func onFowUpdate(fowImage: CGImage?) {
        self.viewModel.fowMaskImage = fowImage
    }

    func loadGame(gameId: String) {
        self.gameService.loadGame(gameId: gameId)
    }
}
