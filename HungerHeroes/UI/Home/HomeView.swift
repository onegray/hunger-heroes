//
//  HomeView.swift
//  HungerHeroes
//
//  Created by onegray on 28.08.22.
//

import SwiftUI

protocol HomeViewDelegate: AnyObject {
    func onOpenGameBtn(gameId: String)
    func onViewGameBtn(gameId: String)
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

            Button("View Players") {
                self.delegate?.onViewGameBtn(gameId: "hg_pack.tar")
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
