//
// Created by onegray on 29.09.22.
//

import UIKit
import SwiftUI
import Combine

class PlayerProfileViewController: UIHostingController<PlayerProfileView> {

    let environment: Environment
    let presenter: PlayerProfilePresenterProtocol
    var viewModel: PlayerProfileViewModel { self.presenter.viewModel }
    var disposeBag = Set<AnyCancellable>()

    init(_ environment: Environment, roomId: String, playerId: Int) {
        let playerProfilePresenter = environment.playerProfilePresenter(playerId: playerId)
        self.environment = environment
        self.presenter = playerProfilePresenter
        super.init(rootView: PlayerProfileView(viewModel: playerProfilePresenter.viewModel))
    }

    required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.presenter.onWillAppear()
    }
}
