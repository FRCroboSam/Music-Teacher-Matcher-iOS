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
                        ProfileImageFromURL(url: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR_S75NOcV00QDQhv2pGbbaNHx6CyvuVTIkhw&usqp=CAU")
                        
                            .scaleEffect(x: 1.75, y: 1.75)
                            .offset(y: -50)
                            .zIndex(4)
                        Spacer()
                            .frame(height: 30)
                        Text("Victoria Dawson")
                            .font(.system(size: 35))
                            .bold()
                        VStack(alignment: .leading){
                            Spacer()
                                .frame(height: 10)
                            HStack{
                                Image("cello_icon")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30, height: 30)
                                Text("Cello Teacher")
                                    .font(.system(size: 20))
                            }
                            HStack{
                                Image("map_pin")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40)
                                    .padding(.all, -15)
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
                            .frame(height: 10)
                        Text("About")
                            .font(.system(size: 35))
                            .bold()
                        Text("5 years teaching experience")
                        Spacer()
                            .frame(height: 10)
                    }.frame(width: 7/8 * deviceWidth)
                        .background(
                            RoundedRectangle(cornerRadius: 40)
                                .fill(Color.white)
                                .shadow(radius: 5)
                            
                        )
                    
                    Spacer()
                        .frame(height: 500)
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
