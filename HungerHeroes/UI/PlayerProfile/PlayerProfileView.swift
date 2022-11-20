//
//  PlayerProfileView.swift
//  HungerHeroes
//
//  Created by onegray on 5.08.22.
//

import SwiftUI

struct PlayerProfileView: View {

    @ObservedObject var viewModel: PlayerProfileViewModel

    func gridColumns(width: CGFloat) -> [GridItem] {
        let colNum = width < 480 ? 2 : 3
        return .init(repeating: GridItem(.flexible(), alignment: .leading), count: colNum)
    }

    var body: some View {

        GeometryReader() { geometry in

            VStack() {

                HStack(alignment: .top) {
                    Spacer()
                        .frame(width: 20)

                    ImageView(imageSource: self.viewModel.avatar)
                        .frame(maxWidth: geometry.size.width * 0.45, maxHeight: geometry.size.width * 0.45)

                    Spacer()
                        .frame(width: 20)

                    VStack(alignment: .leading) {
                        Spacer()
                            .frame(height: 10)
                        Text(self.viewModel.name)
                            .font(.title2)
                        Text(self.viewModel.role)
                            .font(.subheadline).italic()

                        Spacer()
                            .frame(height: 10)

                        if !self.viewModel.isLoading {
                            EfficiencyChartView(value: 0.8)
                                .frame(height: geometry.size.width * 0.1)

                            Text("Efficiency: \(self.viewModel.efficiency)%")
                                .font(.subheadline)
                        }
                    }

                    Spacer()
                }
                .fixedSize(horizontal: false, vertical: true)

                ScrollView() {

                    if self.viewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(.circular)
                            .padding()
                    } else {
                        LazyVGrid(columns: self.gridColumns(width: geometry.size.width)) {
                            SkillView(iconName: "waveform.path.ecg", title: "Points",
                                      value: self.viewModel.points)
                                .padding()

                            SkillView(iconName: "f.cursive", title: "K/D",
                                      value: self.viewModel.killDeathRate)
                                .padding()

                            SkillView(iconName: "sum", title: "Frags:",
                                      value: self.viewModel.frags)
                                .padding()

                            SkillView(iconName: "timer", title: "Time playing:",
                                      value: self.viewModel.gameTime)
                                .padding()

                            SkillView(iconName: "flag", title: "Win",
                                      value: self.viewModel.winRate)
                                .padding()

                            SkillView(iconName: "nosign", title: "Loose",
                                      value: self.viewModel.looseRate)
                                .padding()
                        }
                    }

                }

                Spacer()
            }
        }
    }
}


struct EfficiencyChartView: View {

    let value: Double

    var body: some View {
        ZStack {
            Image(systemName: "circle")
                .font(.title)
                .hidden()

            PieSector(start: 0.0, end: value)
                .fill(.orange)

            PieSector(start: value, end: 1.0)
                .fill(Color(UIColor.lightGray))
        }
        .fixedSize(horizontal: false, vertical: true)
    }

    struct PieSector: Shape {
        let start: Double
        let end: Double

        func path(in rect: CGRect) -> Path {
            Path { path in
                let r = min(rect.size.width/2, rect.size.height)
                let p = CGPoint(x: r, y: rect.height)
                path.addArc(center: p, radius: r,
                            startAngle: Angle(degrees: 180 + 180*start),
                            endAngle: Angle(degrees: 180 + 180*end),
                            clockwise: false)
                path.addLine(to: p)
                path.closeSubpath()
            }
        }
    }
}


struct SkillView: View {

    var iconName: String
    var title: String
    var value: String

    var body: some View {

        VStack() {

            HStack(alignment: .center) {

                GeometryReader { geometry in
                    Image(systemName: self.iconName)
                        .font(.custom("HelveticaNeue", size: 32, relativeTo: .title3)
                            .weight(.light))
                        .foregroundColor(.orange)
                        .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
                }
                .scaledToFill()

                VStack(alignment: .leading) {
                    Text(self.title).lineLimit(1)
                        .font(.caption)
                        .foregroundColor(.gray)
                        .padding(EdgeInsets(top: 3, leading: 0, bottom: 0, trailing: 0))

                    Text(self.value)
                        .font(.title3).fontWeight(.semibold)
                        .foregroundColor(.black)
                }
            }
            .fixedSize()
        }
    }
}

#if DEBUG
struct PlayerProfileView_Previews: PreviewProvider {

    static var testViewModel: PlayerProfileViewModel {
        let vm = PlayerProfileViewModel()
        vm.avatar = UIImage(named: "avatar-placeholder")?.cgImage
        vm.name = "Scorpion"
        vm.role = "assassin"
        vm.efficiency = 142
        vm.points = "1642"
        vm.killDeathRate = "1.42"
        vm.frags = "94"
        vm.gameTime = "168"
        vm.winRate = "42"
        vm.looseRate = "34"
        return vm
    }

    static var previews: some View {
        PlayerProfileView(viewModel: self.testViewModel)
    }
}
#endif
