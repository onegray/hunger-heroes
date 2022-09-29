//
// Created by onegray on 29.09.22.
//

import Foundation
import Combine

protocol PlayerProfilePresenterProtocol {
    var viewModel: PlayerProfileViewModel { get }
}

class PlayerProfilePresenter: PlayerProfilePresenterProtocol {

    let viewModel: PlayerProfileViewModel
    let roomService: RoomService
    let imageService: ImageService
    var disposeBag = Set<AnyCancellable>()

    init(viewModel: PlayerProfileViewModel, roomService: RoomService, imageService: ImageService) {
        self.viewModel = PlayerProfileView_Previews.testViewModel
        self.roomService = roomService
        self.imageService = imageService
    }

    func onWillAppear() {
    }
}
