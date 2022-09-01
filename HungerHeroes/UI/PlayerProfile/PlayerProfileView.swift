//
//  PlayerProfileView.swift
//  HungerHeroes
//
//  Created by onegray on 5.08.22.
//

import SwiftUI

struct PlayerProfileView: View {
    var body: some View {
        
        GeometryReader() { geometry in
            
            VStack() {

                HStack(alignment: .top) {
                    Spacer()
                        .frame(width: 20)

                    Image("avatar-placeholder")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: geometry.size.width * 0.45)

                    Spacer()
                        .frame(width: 20)

                    VStack(alignment: .leading) {
                        Spacer()
                            .frame(height: 10)
                        Text("Scorpion 123")
                            .font(.title2)
                        Text("assassin")
                            .font(.subheadline).italic()
                        
                        Spacer()
                            .frame(height: 10)
                        
                        EfficiencyChartView(value: 0.8)
                            .frame(height: geometry.size.width * 0.1)

                        Text("Efficiency: 142%")
                            .font(.subheadline)
                    }
                    
                    Spacer()
                }
                
                
                HStack() {

                    VStack(alignment: .leading) {
                        SkillView(iconName: "waveform.path.ecg", title: "Points", value: "1642")
                            .padding()

                        SkillView(iconName: "sum", title: "Frags:", value: "94")
                            .padding()

                        SkillView(iconName: "flag", title: "Win", value: "42")
                            .padding()
                    }

                    Spacer()

                    VStack(alignment: .leading) {
                        SkillView(iconName: "f.cursive", title: "K/D", value: "1.42")
                            .padding()


                        SkillView(iconName: "timer", title: "Time playing:", value: "168")
                            .padding()

                        SkillView(iconName: "nosign", title: "Loose", value: "34")
                            .padding()

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
            PieSector(start: 0.0, end: value)
                .fill(.orange)

            PieSector(start: value, end: 1.0)
                .fill(Color(UIColor.lightGray))
        }
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

                Image(systemName: iconName)
                    .foregroundColor(.orange)
                    .font(.custom("HelveticaNeue", size: 32, relativeTo: .title3)
                        .weight(.light))

                VStack(alignment: .leading) {
                    Text(title).lineLimit(1)
                        .font(.caption)
                        .foregroundColor(.gray)
                        .padding(EdgeInsets(top: 3, leading: 0, bottom: 0, trailing: 0))

                    Text(value)
                        .font(.title3).fontWeight(.semibold)
                        .foregroundColor(.black)
                }
            }
        }
    }
}


struct PlayerProfileView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerProfileView()
    }
}
