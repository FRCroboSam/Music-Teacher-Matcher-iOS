//
//  MusicAppSeniorProjectApp.swift
//  MusicAppSeniorProject
//
//  Created by Samuel Wang on 1/27/23.
//

import SwiftUI
import Firebase

//this class is new
import FirebaseAppCheck
class AppDelegate: NSObject, UIApplicationDelegate {
  var loggedIn = false;
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
      let providerFactory = YourSimpleAppCheckProviderFactory()
      AppCheck.setAppCheckProviderFactory(providerFactory)
      FirebaseApp.configure()
      Database.database().isPersistenceEnabled = true

      if(Auth.auth().currentUser != nil){
          loggedIn = true
      }
    return true
  }
}
class YourSimpleAppCheckProviderFactory: NSObject, AppCheckProviderFactory {
  func createProvider(with app: FirebaseApp) -> AppCheckProvider? {
    return AppAttestProvider(app: app)
  }
}

@main
struct MusicAppSeniorProjectApp: App {
    @StateObject private var modelData = ModelData()
    @StateObject private var profileModel = ProfileModel()
    @StateObject private var teacherModelData = TeacherModelData()
    //this is new
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

//    init(){
//        FirebaseApp.configure()
//    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(modelData)
                .environmentObject(teacherModelData)
                .environmentObject(profileModel)
                .onAppear{
                    modelData.loggedIn = delegate.loggedIn

                    let handle = Auth.auth().addStateDidChangeListener { auth, user in
                                if let user = user {
                                    print("User is already logged in")
                                    let uid = user.uid
                                    modelData.uid = uid
                                    modelData.email = user.email
                                    teacherModelData.email = user.email
                                    teacherModelData.uid = uid
                                    print("USER UID IS: "  + uid)
                                    modelData.userIsStudent { isStudent in
                                        if(isStudent){
                                            modelData.createStudentFromId(uid: uid) { isCreated in
                                                if isCreated {
                                                    print("FIRST TIME FETCHING TEACHER DATA")
                                                    modelData.fetchTeacherData() {
                                                    }
                                                    //TODO: SUNDAY -> MAKE THE STUDENT APP PAGE UI FIRST ON FIGMA
                                                    modelData.fetchUserImage(url: "data:image/jpeg;base64,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")
                                                } else {
                                                    modelData.loggedIn = false
                                                }
                                            }
                                            modelData.isStudent = true;
                                        }
                                        else{
                                            modelData.isStudent = false;
                                            teacherModelData.createTeacherFromId(uid: uid) { isCreated in
                                                if isCreated {
                                                    teacherModelData.fetchStudentData() {
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
    }
}
