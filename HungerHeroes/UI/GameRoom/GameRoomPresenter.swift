//
//  GameRoomPresenter.swift
//  HungerHeroes
//
//  Created by onegray on 17.09.22.
//

import UIKit
import Combine

protocol GameRoomPresenterProtocol {
    var viewModel: GameRoomViewModel { get }
    func onWillAppear()
}

class GameRoomPresenter: GameRoomPresenterProtocol {

    let viewModel: GameRoomViewModel
    let roomService: RoomService
    var disposeBag = Set<AnyCancellable>()

    init(viewModel: GameRoomViewModel, roomService: RoomService) {
        self.viewModel = GameRoomView_previews.testViewModel
        self.roomService = roomService

        self.roomService.room.compactMap({ $0 })
                .sink { [weak self] room in
                    self?.onUpdateRoom(room)
                }
                .store(in: &self.disposeBag)
    }

    func onWillAppear() {
        self.roomService.requestRoom()
    }

    func onUpdateRoom(_ room: GameRoomDef) {
        self.viewModel.gameTitle = room.roomTitle
        self.viewModel.mapName = room.mapName

        var teams = [Int : GameRoomTeam]()
        for playerDef in room.players {
            let iconImage = UIImage(systemName: "person")!.cgImage!
            let player = GameRoomPlayer(id: playerDef.id, name: playerDef.name,
                                        icon: iconImage, role: "")
            var team = teams[player.id] ?? GameRoomTeam(id: player.id, title: "", players: [])
            team.players.append(player)
            teams[player.id] = team
        }
        self.viewModel.teams = teams.values.sorted { $0.id > $1.id }
    }
}
