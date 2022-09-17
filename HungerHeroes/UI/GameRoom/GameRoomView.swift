//
// Created by onegray on 17.09.22.
//

import SwiftUI

struct GameRoomView: View {

    @ObservedObject var viewModel: GameRoomViewModel

    var body: some View {
        VStack {
            Text(self.viewModel.gameTitle)
            Text(self.viewModel.mapName)
                .font(.caption)

            List {
                ForEach(self.viewModel.teams) { team in
                    Section(header: Text(team.title)) {
                        ForEach(team.players) { player in
                            GameRoomPlayerView(player: player)
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
            Image(uiImage: UIImage(cgImage: player.icon))
                .frame(width: 42, height: 42, alignment: .center)

            VStack {
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

    static var testViewModel: GameRoomViewModel {
        let vm = GameRoomViewModel()
        vm.gameTitle = "Free For All"
        vm.mapName = "Battlefield v1"
        let iconImage = UIImage(systemName: "person")!.cgImage!
        vm.teams = [
            GameRoomTeam(id: 0, title: "Team 1", players: [
                GameRoomPlayer(id: 1, name: "Player1", icon: iconImage, role: "assasin"),
                GameRoomPlayer(id: 2, name: "Player2", icon: iconImage, role: "killer")
            ]),
            GameRoomTeam(id: 1, title: "Team 2", players: [
                GameRoomPlayer(id: 3, name: "Player3", icon: iconImage, role: "stalker"),
                GameRoomPlayer(id: 4, name: "Player4", icon: iconImage, role: "warrior")
            ])
        ]
        return vm
    }

    static var previews: some View {
        GameRoomView(viewModel: self.testViewModel)
    }
}
#endif
