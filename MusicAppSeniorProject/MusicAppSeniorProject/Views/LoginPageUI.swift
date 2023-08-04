//
//  LoginPageUI.swift
//  MusicAppSeniorProject
//
//  Created by Samuel Wang on 8/1/23.
//

import SwiftUI

struct LoginPageUI: View {
    // MARK: - Propertiers
    @State private var email = ""
    @State private var password = ""
    @State private var text = ""
    var deviceWidth: CGFloat {
        UIScreen.main.bounds.width
    }
    // MARK: - View
    var body: some View {
        ZStack{
            Image("music_background2")
                .resizable()
//                    .scaledToFill()
                .ignoresSafeArea()
            VStack(spacing: 0) {
                Text("Music Matcher Login ")
                //                    .font(.largeTitle)
                    .font(.custom("MarkerFelt-Wide", size: 50))
                    .minimumScaleFactor(0.01)
                    .frame(maxWidth: 5/6 * deviceWidth)

                    .lineLimit(1)
                    .foregroundColor(.white)
//                    .bold()
//                    .italic()
                Image("app_icon")
                
                HStack {
                    Image(systemName: "envelope")
                    TextField("Email", text: $text)
                        .foregroundColor(.white)
                    
                }.modifier(customViewModifier(roundedCornes: 20, startColor: .orange, endColor: .pink, textColor: .white))
                    .padding(20)
                HStack {
                    Image(systemName: "lock")
                    SecureField("Password", text: $text)
                        .foregroundColor(.white)

                }.modifier(customViewModifier(roundedCornes: 20, startColor: .orange, endColor: .pink, textColor: .white))

                Button("Sign In") {
                    
                }
                Spacer()
            }.padding()
            
            
        }
    }
    
}
struct customViewModifier: ViewModifier {
    var deviceWidth: CGFloat {
        UIScreen.main.bounds.width
    }
    var roundedCornes: CGFloat
    var startColor: Color
    var endColor: Color
    var textColor: Color

    func body(content: Content) -> some View {
        content
            .padding()
            .background(LinearGradient(gradient: Gradient(colors: [startColor, endColor]), startPoint: .topLeading, endPoint: .bottomTrailing))
            .cornerRadius(roundedCornes)
            .frame(maxWidth: 5/6 * deviceWidth)

            .padding(3)
            .foregroundColor(textColor)
            .overlay(RoundedRectangle(cornerRadius: roundedCornes)
                        .stroke(LinearGradient(gradient: Gradient(colors: [startColor, endColor]), startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 2.5))
            .font(.custom("Open Sans", size: 18))

//            .shadow(radius: 10)
    }
}
struct LoginPageUI_Previews: PreviewProvider {
    static var previews: some View {
        LoginPageUI()
    }
}
