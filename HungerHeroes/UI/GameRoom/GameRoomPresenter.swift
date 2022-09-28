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
    let imageService: ImageService
    var disposeBag = Set<AnyCancellable>()

    init(viewModel: GameRoomViewModel, roomService: RoomService, imageService: ImageService) {
        self.viewModel = GameRoomView_previews.testViewModel
        self.roomService = roomService
        self.imageService = imageService

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
        self.viewModel.roomTitle = "Room\(room.roomId)"
        self.viewModel.gameTitle = room.roomTitle
        self.viewModel.mapName = room.mapName

        var teams = [Int : GameRoomTeam]()
        for playerDef in room.players {
            var avatar: ImageSource? = nil
            if let avatarImageId = playerDef.avatar {
                avatar = self.imageService.getPlayerAvatar(imageId: avatarImageId)
            }
            let player = GameRoomPlayer(id: playerDef.id, name: playerDef.name,
                                        avatar: avatar, role: playerDef.speciality.string)
            var team = teams[playerDef.team] ?? GameRoomTeam(id: playerDef.team, title: "", players: [])
            team.players.append(player)
            teams[playerDef.team] = team
        }
        self.viewModel.teams = teams.values.sorted { $0.id > $1.id }
    }
}
