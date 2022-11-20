//
// Created by onegray on 29.09.22.
//

import Foundation
import Combine

protocol PlayerProfilePresenterProtocol {
    var viewModel: PlayerProfileViewModel { get }
    func onWillAppear()
}

class PlayerProfilePresenter: PlayerProfilePresenterProtocol {

    let viewModel: PlayerProfileViewModel
    let playerService: PlayerService
    let imageService: ImageService
    var disposeBag = Set<AnyCancellable>()

    init(viewModel: PlayerProfileViewModel, playerService: PlayerService, imageService: ImageService) {
        self.viewModel = viewModel
        self.playerService = playerService
        self.imageService = imageService

        self.playerService.isRequesting
            .assign(to: &self.viewModel.$isLoading)

        self.playerService.player.compactMap({ $0 })
                .sink { [weak self] player in
                    self?.onUpdatePlayer(player: player)
                }
                .store(in: &self.disposeBag)
    }

    func onWillAppear() {
        self.playerService.requestPlayerProfile()
    }

    func onUpdatePlayer(player: PlayerDef) {
        self.viewModel.name = player.name
        self.viewModel.role = player.speciality.string
        if let avatarId = player.avatar {
            self.viewModel.avatar = self.imageService.getPlayerAvatar(imageId: avatarId)
        } else {
            self.viewModel.avatar = nil
        }
        self.viewModel.efficiency = player.stats?.efficiency ?? 0
        self.viewModel.points = "\(player.stats?.score ?? 0)"
        self.viewModel.frags = "\(player.stats?.frags ?? 0)"
        self.viewModel.gameTime = "\(player.stats?.gameTime ?? 0)"
        self.viewModel.killDeathRate = "\(player.stats?.kdRate ?? 0)"
        self.viewModel.winRate = "\(player.stats?.winRate ?? 0)"
        self.viewModel.looseRate = "\(player.stats?.looseRate ?? 0)"
    }
}
