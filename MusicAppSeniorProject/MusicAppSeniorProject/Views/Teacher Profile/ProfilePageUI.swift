//
//  ProfilePageUI.swift
//  MusicAppSeniorProject
//
//  Created by Samuel Wang on 8/27/23.
//

import SwiftUI

struct ProfilePageUI: View {
    var deviceHeight: CGFloat {
        UIScreen.main.bounds.height
    }
    var deviceWidth: CGFloat {
        UIScreen.main.bounds.width
    }
    var body: some View {
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


                            ProfileImageFromURL(url: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR_S75NOcV00QDQhv2pGbbaNHx6CyvuVTIkhw&usqp=CAU")
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
                            Image(systemName: "star.circle")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .background(Color.white)
                                .clipShape(Circle())
                                .foregroundColor(Color.yellow)
                                .zIndex(6)
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
                            .frame(height: 30)
                        Text("Victoria Dawson")
                            .font(.system(size: 35))
                            .bold()
                        HStack{
                            Text("Cello Teacher")
                                .font(.system(size: 20))
                                .italic()
                                .foregroundColor(.gray)
                        }
                        Divider()
                            .padding(.top, -10)
                        VStack(alignment: .leading){
                            Spacer()
                            HStack{
                                Image("years_of_exp_icon")
                                    .resizable()
                                    .renderingMode(.template)
                                    .foregroundColor(Color.blue)
                                    .frame(width: 30, height: 30)
                                Text("5 years of experience")
                                    .font(.system(size: 20))
                                
                            }
                            Spacer()
                                .frame(height: 10)
                            HStack{
                                Image(systemName: "graduationcap.fill")
                                    .resizable()
                                    .foregroundColor(Color.brown)
                                    .frame(width: 30, height: 30)
                                Text("Julliard School of Music ")
                                    .font(.system(size: 20))
                                
                            }
                            HStack{
                                Image(systemName: "house")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30, height: 30)
                                Text("Seattle, Washington")
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
                        Text("Preferred Students")
                            .font(.system(size: 35))
                            .bold()
                        Spacer()
                            .frame(height: 5)
                        HStack{
                            Text(" Intermediate ")
                                .foregroundColor(.green)
                                .background{
                                    RoundedRectangle(cornerRadius: 10)
                                        .strokeBorder(Color.green, lineWidth: 1)
                                        .background(Color.green)
                                        .opacity(0.5)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                        .brightness(0.2)
                                        
                                }
                            Text(" Advanced ")
                                .foregroundColor(.red)
                                .background{
                                    RoundedRectangle(cornerRadius: 10)
                                        .strokeBorder(Color.red, lineWidth: 1)
                                        .background(Color.red)
                                        .opacity(0.5)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                        .brightness(0.2)
                                }
                        }
                        Divider()
                        Text("Looking for students who already have a solid grasp on the basics and can play pieces like Hadyn Cello Concerto and Suzuki book 2")
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

                            Text("Specializing in classical pedagogy with a focus on relaxed, effortless technique.")
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
                                Image(systemName: "dollarsign.circle")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(Color.green)
                                Text("$60 per hour")
                            }
                            HStack{
                                Image(systemName: "calendar.circle")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(Color.teal)
                                Text("3 weekly lessons per month")
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
}

struct ProfilePageUI_Previews: PreviewProvider {
    static var previews: some View {
        ProfilePageUI()
    }
}
struct ScrollViewConfigurator: UIViewRepresentable {
    let configure: (UIScrollView?) -> ()
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        DispatchQueue.main.async {
            configure(view.enclosingScrollView())
        }
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}
extension UIView {
    func enclosingScrollView() -> UIScrollView? {
        var next: UIView? = self
        repeat {
            next = next?.superview
            if let scrollview = next as? UIScrollView {
                return scrollview
            }
        } while next != nil
        return nil
    }
}
