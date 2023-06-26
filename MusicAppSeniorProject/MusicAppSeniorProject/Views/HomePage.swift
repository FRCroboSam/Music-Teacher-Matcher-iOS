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
            VStack(alignment: .leading) {
                Text("Music Lessons for Everybody")
                    .font(.system(size: 50))
                    .fontWeight(.bold)
                Text("First time using the app as a student looking for a music teacher?")
                NavigationLink(destination: CreateStudentProfilePage()){
                    Text("Click here")
                        .backgroundStyle(.green)
                }
                .buttonStyle(.bordered)
                
                Text("Music Teacher who wants to find students?")
                NavigationLink(destination: CreateTeacherProfilePage()){
                    Text("Click here")
                        .backgroundStyle(.green)
                    //                        .navigationBarBackButtonHidden(true)
                    
                }
                .buttonStyle(.bordered)
                Text("Already created an account?")
                NavigationLink(destination: LoginPage()){
                    
                    Text("Log in")
                }
                .buttonStyle(.bordered)
                Spacer()
                NavigationLink(destination: TestView()){
                    Text("Test View")
                }
                .buttonStyle(.bordered)
                Spacer()
                
                
            }
            .padding(10)
            Spacer()
            
            
        }.navigationBarBackButtonHidden(true)
    }
}

struct HomePage_Previews: PreviewProvider {
    static var previews: some View {
        HomePage()

    }
}
