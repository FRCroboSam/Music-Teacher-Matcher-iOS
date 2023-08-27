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
                                                    //TODO: Restructure to more efficient method of fetching photo urls
                                                    modelData.fetchUserImage(url: "data:image/png;base64,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")
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
