//
//  MockGameRoomPresenter.swift
//  HungerHeroesUITests
//
//  Created by sergeyn on 20.11.22.
//

import Foundation
import UIKit

#if DEBUG

class MockGameRoomPresenter: GameRoomPresenterProtocol {

    var viewModel = MockGameRoomPresenter.testViewModel

    func onWillAppear() {

    }
}

extension MockGameRoomPresenter {

    static var testViewModel: GameRoomViewModel {
        let vm = GameRoomViewModel()
        vm.gameTitle = "Free For All"
        vm.mapName = "Battlefield v1"
        let iconImage = UIImage(systemName: "person")!.cgImage!
        vm.teams = [
            GameRoomTeam(id: 0, title: "Team 1", players: [
                GameRoomPlayer(id: 1, name: "Player1", avatar: iconImage, role: "assasin"),
                GameRoomPlayer(id: 2, name: "Player2", avatar: iconImage, role: "killer")
            ]),
            GameRoomTeam(id: 1, title: "Team 2", players: [
                GameRoomPlayer(id: 3, name: "Player3", avatar: iconImage, role: "stalker"),
                GameRoomPlayer(id: 4, name: "Player4", avatar: iconImage, role: "warrior")
            ])
        ]
        return vm
    }
}

#endif
