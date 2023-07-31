//
//  HomePageUI.swift
//  MusicAppSeniorProject
//
//  Created by Samuel Wang on 7/30/23.
//

import SwiftUI

struct HomePageUI: View {
    var deviceWidth: CGFloat {
        UIScreen.main.bounds.width
    }
    var body: some View {
        GeometryReader{geometry in
            ZStack{
                Image("music_background2")
                    .resizable()
//                    .scaledToFill()
                    .ignoresSafeArea()
                VStack(spacing: 10){
                    
                    Image("app_icon")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height:200)
                        .padding(.top, 30)
                        .padding(.bottom,-30)
                    Text("Music Matcher")
                    //                    .font(.largeTitle)
                        .font(.system(size: 50))
                        .foregroundColor(.white)
                        .bold()
                        .italic()

                    ZStack{
                        RoundedRectangle(cornerRadius:10).strokeBorder(Color.white, lineWidth: 3)
                            .padding(20)
                        Text("Matching students to music teachers in their area ")
                            .multilineTextAlignment(.center)
                            .font(.system(size: 26))
                            .foregroundColor(.white)
                            .italic()



                    }

                        
                    Button("Student Sign Up"){
                    }.buttonStyle(BigButtonStyle(color:.orange))
                        .padding(10)
                    Button("Teacher Sign Up"){
                    }.buttonStyle(BigButtonStyle(color:.orange))
                        .padding(10)
                    Button("Sign In"){
                    }.buttonStyle(BigButtonStyle(color:.orange))
                        .padding(10)
                    Spacer()
                }
                
            }.frame(maxWidth: geometry.size.width)
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
