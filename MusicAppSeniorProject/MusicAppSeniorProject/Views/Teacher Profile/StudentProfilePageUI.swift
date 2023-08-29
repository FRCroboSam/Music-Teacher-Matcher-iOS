//
//  ProfilePageUI.swift
//  MusicAppSeniorProject
//
//  Created by Samuel Wang on 8/27/23.
//

import SwiftUI

struct StudentProfilePageUI: View {
    var deviceHeight: CGFloat {
        UIScreen.main.bounds.height
    }
    var deviceWidth: CGFloat {
        UIScreen.main.bounds.width
    }
    var body: some View {
        var yearsExperience: Int = 0
        var location: String = ""
        var email: String = ""
        var skillLevel: Int = 0
        var priorPiecesPlayed: String = ""
        var format: Int = 2
        var schedule: String = ""
        ScrollView(showsIndicators: false){
            ZStack{
                VStack{
                    VStack{
                        Image("music_background")
                            .resizable()
                            .scaledToFill()
                            .frame(height: 2/5 * deviceHeight)
                            .mask(Rectangle().edgesIgnoringSafeArea(.top))
                        
                        
                    }.frame(maxHeight: 1/4 * deviceHeight)
                    VStack(alignment: .center){
                        HStack{
                            Spacer()


                            ProfileImageFromURL(url: "https://previews.123rf.com/images/gosphotodesign/gosphotodesign1308/gosphotodesign130801942/22722703-little-kid-peeling-a-banana-against-white-background.jpg")
                                .scaleEffect(x: 1.75, y: 1.75)
                                .offset(y: -50)
                                .zIndex(4)

                            Spacer()
                        }
                        HStack{
                            Image(systemName:"x.circle")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .foregroundColor(Color.red)
                                .zIndex(6)
                                .background(Color.white)
                                .clipShape(Circle())
                            Spacer()
                                .frame(width: 30)
                            
                            Image(systemName:"checkmark.circle")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .background(Color.white)
                                .clipShape(Circle())
                                .foregroundColor(Color.green)
                                .zIndex(6)
                        }.background{
                            RoundedRectangle(cornerRadius: 30)
                                .fill(Color.white)
                                .shadow(radius: 5)
                                .padding(-10)

                        }
                        Spacer()
                            .frame(height: 20)
                        Text("Jeremy Donald")
                            .font(.system(size: 35))
                            .bold()
                        Spacer()
                            .frame(height: 10)
                        HStack{
                            Text(" Beginner ")
                                .font(.system(size: 20))

                                .foregroundColor(.green)
                                .background{
                                    RoundedRectangle(cornerRadius: 10)
                                        .strokeBorder(Color.green, lineWidth: 1)
                                        .background(Color.green)
                                        .opacity(0.5)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                        .brightness(0.2)
                                    
                                }
                            Text(" Cello ")
                                .font(.system(size: 20))
                                .foregroundColor(Color.brown)
                                .background{
                                    RoundedRectangle(cornerRadius: 10)
                                        .strokeBorder(Color.brown, lineWidth: 1)
                                        .background(Color.brown)
                                        .opacity(0.5)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                        .brightness(0.2)
                                    
                                }
                            Text(" 5+ ")
                                .font(.system(size: 20))
                                .foregroundColor(Color.teal)
                                .background{
                                    RoundedRectangle(cornerRadius: 10)
                                        .strokeBorder(Color.teal, lineWidth: 1)
                                        .background(Color.teal)
                                        .opacity(0.5)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                        .brightness(0.2)
                                    
                                }
                        }
                        Spacer()
                            .frame(height: 20)
                    
                        Divider()

                        VStack(alignment: .leading){
                            Spacer()
                            
                            HStack{
                                Image("years_of_exp_icon")
                                    .resizable()
                                    .renderingMode(.template)
                                    .foregroundColor(Color.blue)
                                    .frame(width: 30, height: 30)
                                Text("1 years of experience")
                                    .font(.system(size: 20))
                                
                            }
                            Spacer()
                                .frame(height: 10)
                            HStack{
                                Image(systemName: "house")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30, height: 30)
                                Text("Seattle, Washington")
                                    .font(.system(size: 20))
                                
                                
                            }
                            HStack{
                                Image(systemName: "envelope")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30, height: 30)
                                Text("jdonald@gmail.com")
                                    .font(.system(size: 20))
                                
                                
                            }

                            
                            Spacer()
                                .frame(height: 10)
                        }
                    }
                    .zIndex(0)
                    .frame(width: 7/8 * deviceWidth)
                    .background(
                        RoundedRectangle(cornerRadius: 40)
                            .fill(Color.white)
                            .shadow(radius: 5)
                        
                    )
                    Spacer()
                        .frame(height: 30)
                    VStack{
                        Spacer()
                            .frame(height: 15)
                        Text("Prior Pieces Played")
                            .font(.system(size: 35))
                            .bold()
                        Spacer()
                            .frame(height: 5)
                        HStack{

                        }
                        Divider()
                        Text("Hadyn Cello Concerto, Suzuki Book 1, Twinkle Twinkle Little Star")
                            .multilineTextAlignment(.leading)
                            .frame(width: 3/4 * deviceWidth)
                            .font(.system(size: 22, weight: .light, design: .rounded))
                            .foregroundColor(.gray)
                        Spacer()
                            .frame(height: 10)
                        
                    }.frame(width: 7/8 * deviceWidth)
                        .background(
                            RoundedRectangle(cornerRadius: 40)
                                .fill(Color.white)
                                .shadow(radius: 5)
                            
                        )
                    Spacer()
                        .frame(height: 20)
                    VStack(){
                        Spacer()
                            .frame(height: 15)
                            Text("About")
                                .font(.system(size: 35))
                                .bold()
                                .padding(-5)
                            
                            Divider()
                                .frame(width: 300)
                                .overlay(Color.orange)

                            Text("Looking for a flexible teacher who can instill good practice habits.")
                                .multilineTextAlignment(.leading)
                                .frame(width: 3/4 * deviceWidth)
                                .font(.system(size: 22, weight: .light, design: .rounded))
                                .foregroundColor(.gray)
                            Spacer()
                                .frame(height: 10)
                            
                        
                    }.frame(width: 7/8 * deviceWidth)
                        .background(
                            RoundedRectangle(cornerRadius: 40)
                                .fill(Color.white)
                                .shadow(radius: 5)
                                .padding(.bottom, -10))
                    Spacer()
                        .frame(height: 30)
                    VStack{
                        Spacer()
                            .frame(height: 10)
                        Text("Lesson Format")
                            .font(.system(size: 35))
                            .bold()
                            .padding(-5)
                        Divider()
                            .frame(width: 300)
                        Spacer()
                            .frame(height: 10)
                        
                        VStack(alignment: .leading){
                            HStack{
                                Image(systemName: "person.circle")
                                    .resizable()
                                    .foregroundColor(.orange)
                                    .frame(width: 30, height: 30)
                                    Text(" In Person ")
                                        .foregroundColor(.green)
                                        .background{
                                            RoundedRectangle(cornerRadius: 10)
                                                .strokeBorder(Color.green, lineWidth: 1)
                                                .background(Color.green)
                                                .opacity(0.5)
                                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                                .brightness(0.2)
                                                
                                        }
                                    Text(" OR ")
                                        .foregroundColor(.red)
                                    Text(" Online ")
                                        .foregroundColor(.blue)
                                        .background{
                                            RoundedRectangle(cornerRadius: 10)
                                                .strokeBorder(Color.blue, lineWidth: 1)
                                                .background(Color.blue)
                                                .opacity(0.5)
                                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                                .brightness(0.2)
                                        }
//                                    Spacer()

                            }
                            

                            HStack{
                                Image(systemName: "calendar.circle")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(Color.teal)
                                Text("Flexible weekly lessons per month")
                            }
                        }

                    }.frame(width: 7/8 * deviceWidth)
                        .background(
                            RoundedRectangle(cornerRadius: 40)
                                .fill(Color.white)
                                .shadow(radius: 5)
                                .padding(.bottom, -10))

                    Spacer(minLength: 500)
                }
                    .background(ScrollViewConfigurator {
                        $0?.bounces = false               // << here !!
                    })
            }
//            Image("music_background")
//                .resizable()
//                .scaledToFill()
//                .edgesIgnoringSafeArea(.all)
//                .mask(Rectangle().edgesIgnoringSafeArea(.top))
            
        }
    }
    func populateInfo(){
        
    }
}

struct StudentProfilePageUI_Previews: PreviewProvider {
    static var previews: some View {
        StudentProfilePageUI()
    }
}
