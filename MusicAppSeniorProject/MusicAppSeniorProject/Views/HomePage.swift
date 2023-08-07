//
//  HomePage.swift
//  MusicAppSeniorProject
//
//  Created by Samuel Wang on 1/27/23.
//

import SwiftUI

struct HomePage: View {
    var deviceWidth: CGFloat {
        UIScreen.main.bounds.width
    }

    var deviceHeight: CGFloat {
        UIScreen.main.bounds.height
    }

    var body: some View {
        NavigationStack{
            GeometryReader{geometry in
                ZStack{
                    Image("music_background2")
                        .resizable()
                    //                    .scaledToFill()
                        .ignoresSafeArea()
                    VStack(spacing: 15){
                        Image("app_icon")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height:200)
                            .padding(.top, 30)
                            .padding(.bottom,-30)
                        Text("Music Matcher")
                        //                    .font(.largeTitle)
                            .font(.custom("MarkerFelt-Wide", size: 50))
                            .foregroundColor(.white)
//                            .bold()
//                            .italic()
                        ZStack{
                            RoundedRectangle(cornerRadius:10).strokeBorder(Color.white, lineWidth: 3)
                                .frame(maxWidth: 7/8 * deviceWidth)
                                .frame(maxHeight: 1/7 * deviceHeight)
//                                .padding(10)
                            Text("Matching students to music teachers in their area ")
                                .multilineTextAlignment(.center)
                                .font(.system(size: 26))
                                .minimumScaleFactor(0.01)
                                .frame(maxWidth: 5/6 * deviceWidth)

                                .foregroundColor(.white)
                                .italic()
//                                .overlay(RoundedRectangle(cornerRadius: 20)                                .strokeBorder(Color.white,lineWidth: 5)
//                                    .padding(-10)
//                                )


                            
                            
                            
                        }.offset(y:15)

                        Spacer(minLength: 20)
                        NavigationLink(destination: LoginPage()){
                            Text("Sign In")
                        }.buttonStyle(BigButtonStyle(color:.orange))
                            .padding(10)
                        NavigationLink(destination: CreateStudentProfilePage()){
                            Text("Student Sign Up")
                        }.buttonStyle(BigButtonStyle(color:.orange))
                            .padding(10)
                        NavigationLink(destination: CreateTeacherProfilePage()){
                            Text("Teacher Sign Up")
                        }.buttonStyle(BigButtonStyle(color:.orange))
                            .padding(10)
//                        Button("Student Sign Up"){
//                            NavigationLink(CreateStudentProfilePage())
//                        }
//                        Button("Teacher Sign Up"){
//                        }.buttonStyle(BigButtonStyle(color:.orange))
//                            .padding(10)
//                        Button("Sign In"){
//                        }.buttonStyle(BigButtonStyle(color:.orange))
//                            .padding(10)
                        Spacer()
                    }
                    
                }.frame(maxWidth: geometry.size.width)
                    .navigationBarBackButtonHidden(true)
            }
        }
    }
}

struct HomePage_Previews: PreviewProvider {
    static var previews: some View {
        HomePage()

    }
}
