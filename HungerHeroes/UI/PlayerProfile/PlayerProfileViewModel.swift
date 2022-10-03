//
// Created by onegray on 29.09.22.
//

import Foundation

class PlayerProfileViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var role: String = ""
    @Published var avatar: ImageSource? = nil
    @Published var efficiency: Int = 0
    @Published var points: String = ""
    @Published var killDeathRate: String = ""
    @Published var frags: String = ""
    @Published var gameTime: String = ""
    @Published var winRate: String = ""
    @Published var looseRate: String = ""
}
