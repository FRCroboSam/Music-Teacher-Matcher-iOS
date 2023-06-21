//
//  MusicAppSeniorProjectApp.swift
//  MusicAppSeniorProject
//
//  Created by Samuel Wang on 1/27/23.
//

import SwiftUI
import Firebase

//this class is new
class AppDelegate: NSObject, UIApplicationDelegate {
  var loggedIn = false;
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
      if(Auth.auth().currentUser != nil){
          loggedIn = true
      }
    return true
  }
}

@main
struct MusicAppSeniorProjectApp: App {
    @StateObject private var modelData = ModelData()
    //this is new 
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

//    init(){
//        FirebaseApp.configure()
//    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(modelData)
                .environmentObject(TeacherModelData())
                .environmentObject(ProfileModel())
                .onAppear{
                    modelData.loggedIn = delegate.loggedIn
                    let handle = Auth.auth().addStateDidChangeListener { auth, user in
                                if let user = user {
                                    print("User is already logged in")
                                    let uid = user.uid
                                    modelData.uid = uid
                                    print("USER UID IS: "  + uid)
                                    modelData.createStudentFromId(uid: uid) { isCreated in
                                        if isCreated {
                                            modelData.fetchTeacherData() {
                                            }
                                            modelData.fetchImage{_ in
                                            }
                                        } else {
                                            modelData.loggedIn = false
                                        }
                                    }
                                    
                                }
                            }
                }
        }
    }
}
