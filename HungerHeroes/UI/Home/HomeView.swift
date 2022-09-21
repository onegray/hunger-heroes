//
//  HomeView.swift
//  HungerHeroes
//
//  Created by onegray on 28.08.22.
//

import SwiftUI

protocol HomeViewDelegate: AnyObject {
    func onOpenGameBtn(gameId: String)
    func onGameRoomBtn(roomId: String)
}

struct HomeView: View {

    @ObservedObject var viewModel: HomeViewModel
    weak var delegate: HomeViewDelegate?

    var body: some View {

        VStack() {
            Spacer()

            Button("Open Game") {
                self.delegate?.onOpenGameBtn(gameId: "hg_pack.tar")
            }

            Spacer()

            Button("Room Players") {
                self.delegate?.onGameRoomBtn(roomId: "room42.json")
            }
            .padding()
        }
    }
}

#if DEBUG
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(viewModel: HomeViewModel())
    }
}
#endif
