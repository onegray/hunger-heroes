//
// Created by onegray on 17.09.22.
//

import SwiftUI

protocol GameRoomViewDelegate: AnyObject {
    func onSelectPlayer(playerId: Int)
}

struct GameRoomView: View {

    @ObservedObject var viewModel: GameRoomViewModel
    weak var delegate: GameRoomViewDelegate?

    var body: some View {
        VStack {
            Text(self.viewModel.gameTitle)
            Text(self.viewModel.mapName)
                .font(.caption)

            List {
                ForEach(self.viewModel.teams) { team in
                    Section(header: Text(team.title)) {
                        ForEach(team.players) { player in
                            Button {
                                self.delegate?.onSelectPlayer(playerId: player.id)
                            } label: {
                                GameRoomPlayerView(player: player)
                            }
                        }
                    }
                }
            }
        }
    }
}

struct GameRoomPlayerView: View {
    let player: GameRoomPlayer
    var body: some View {
        HStack {
            ImageView(imageSource: player.avatar)
                    .frame(width: 32, height: 32, alignment: .center)

            VStack(alignment: .leading) {
                Text(player.name)

                Text(player.role)
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
        }
    }
}


#if DEBUG
struct GameRoomView_previews: PreviewProvider {

    static var previews: some View {
        GameRoomView(viewModel: MockGameRoomPresenter.testViewModel)
    }
}
#endif
