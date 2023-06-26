//
//  ContentView.swift
//  MusicAppSeniorProject
//
//  Created by Samuel Wang on 1/27/23.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct ContentView: View {
    @EnvironmentObject var modelData: ModelData
    @State private var isUserLoggedIn = false
    enum VIEW_TYPE{
        case HOME_PAGE
        case PROFILE_PAGE
    }
    var body: some View {
        Group{
            if modelData.loggedIn == true{
//                if(!(modelData.isStudent ?? true)){
//                    TeacherAppPage()
//                }
//                else{
//                    StudentAppPage()
//                }
//                HomePage()
                LoginPage()
            }
            else{
                HomePage()
            }
        }
        
    }
//    func asdf(){
//        Auth.auth().createUser(withEmail: "DF", password: "DF"){
//            result error in code
//        }
        //https://www.youtube.com/watch?v=6b2WAePdiqA
//    }
    
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ModelData())
    }
}

