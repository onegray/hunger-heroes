//
// Created by onegray on 17.09.22.
//

import UIKit
import SwiftUI
import Combine

class GameRoomViewController: UIHostingController<GameRoomView>, GameRoomViewDelegate {

    let roomId: String
    let environment: Environment
    let presenter: GameRoomPresenterProtocol
    var viewModel: GameRoomViewModel { self.presenter.viewModel }
    var disposeBag = Set<AnyCancellable>()

    init(_ environment: Environment, roomId: String) {
        let gameRoomPresenter = environment.gameRoomPresenter(roomId: roomId)
        self.roomId = roomId
        self.environment = environment
        self.presenter = gameRoomPresenter
        super.init(rootView: GameRoomView(viewModel: gameRoomPresenter.viewModel))

        self.viewModel.$roomTitle
                .sink { [unowned self] title in
                    self.title = title
                }
                .store(in: &self.disposeBag)
    }

    required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        self.rootView.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.presenter.onWillAppear()
    }

    func onSelectPlayer(playerId: Int) {
        let vc = PlayerProfileViewController(self.environment, roomId: self.roomId, playerId: playerId)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
