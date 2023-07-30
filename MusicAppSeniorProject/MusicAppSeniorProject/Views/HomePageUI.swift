//
//  HomePageUI.swift
//  MusicAppSeniorProject
//
//  Created by Samuel Wang on 7/30/23.
//

import SwiftUI

struct HomePageUI: View {

    var body: some View {
        ZStack{
            Image("music_background2")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            VStack{
                Image("app_icon")
                    .frame(height:200)
                Text("Music Matcher")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .bold()
                    .italic()
                Button("Hello"){
                    
                }.buttonStyle(BigButtonStyle(color:.orange))
            }
            
        }
    }
}

struct HomePageUI_Previews: PreviewProvider {
    static var previews: some View {
        HomePageUI()
    }
}

struct BigButtonStyle: ButtonStyle {

    @State var color: Color = .indigo
    @Environment(\.isEnabled) private var isEnabled: Bool
    var deviceWidth: CGFloat {
        UIScreen.main.bounds.width
    }

    var deviceHeight: CGFloat {
        UIScreen.main.bounds.height
    }
    func makeBody(configuration: Configuration) -> some View {
            configuration.label
            .font(.title.bold())
            .padding()
            .frame(maxWidth: 3/4 * deviceWidth)
            .foregroundColor(isEnabled ? .white : Color(UIColor.systemGray3))
            .background(isEnabled ? color : Color(UIColor.systemGray5))
            .cornerRadius(12)
            .overlay {
                if configuration.isPressed {
                    Color(white: 1.0, opacity: 0.2)
                        .cornerRadius(12)
                }
            }
    }
}
