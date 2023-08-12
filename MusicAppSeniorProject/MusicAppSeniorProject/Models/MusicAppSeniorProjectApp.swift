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
                                                    modelData.fetchImage{_ in
                                                    }
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
    }
}
