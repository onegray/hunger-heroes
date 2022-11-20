//
//  HomeViewController.swift
//  HungerHeroes
//
//  Created by onegray on 28.08.22.
//

import UIKit
import SwiftUI

class HomeViewController: UIHostingController<HomeView>, HomeViewDelegate {
    
    let environment: Environment
    let presenter: HomePresenterProtocol
    var viewModel: HomeViewModel { self.presenter.viewModel }

    init(environment: Environment) {
        self.environment = environment
        self.presenter = environment.homePresenter()
        super.init(rootView: HomeView(viewModel: self.presenter.viewModel))
        self.rootView.delegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func onSignInBtn() {
        self.presenter.login(username: self.viewModel.username, password: self.viewModel.password)
    }

    func onViewPlayersBtn() {
        let roomId = "room42.json"
        let vc = GameRoomViewController(self.environment, roomId: roomId)
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func onOpenGameBtn() {
        let gameId = "hg_pack.tar"
        let vc = MapViewController(self.environment, gameId: gameId)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
