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
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
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
                .environmentObject(ModelData())
                .environmentObject(TeacherModelData())
        }
    }
}
