//
// Created by onegray on 29.09.22.
//

import Foundation

class PlayerProfileViewModel: ObservableObject {
    @Published var playerName: String = ""
    @Published var playerAvatar: ImageSource? = nil
    @Published var playerRole: String = ""

}
