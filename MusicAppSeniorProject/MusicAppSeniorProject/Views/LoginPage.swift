//
//  CreateTeacherProfilePage.swift
//  MusicAppSeniorProject
//
//  Created by Samuel Wang on 2/20/23.
//

import SwiftUI
import FirebaseAuth
struct LoginPage: View {
    @EnvironmentObject var modelData : ModelData
    @EnvironmentObject var teacherModelData: TeacherModelData
    @State private var noUserFound = false
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var studentLoginSuccessful = false
    @State private var teacherLoginSuccessful = false
    @State private var userType: String = "Student"
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var age: Double = 12
    @State private var selectedInstrument: String = "Cello"
    @State private var moveOn = false;
    //new navigation stack stuff
    var body: some View {
//        NavigationStack{
            VStack(alignment: .leading, spacing: 0) {
                Text("Login")
                    .font(.system(size: 40))
                    .fontWeight(.bold)
                    .padding(10)
//                Spacer()
//                    .frame(height: 0)
//                    .font(.system(size: 30))
//                    .padding(10)
//                HStack(spacing: 10){
//                    Text("Name: ")
//                        .font(.system(size: 20))
//                    TextField("First Name ", text: $firstName)
//                        .textFieldStyle(.roundedBorder)
//                        .font(.system(size: 20))
//                        .keyboardType(.asciiCapable)
//                        .autocorrectionDisabled()
//                    TextField("Last Name ", text: $lastName)
//                        .textFieldStyle(.roundedBorder)
//                        .font(.system(size: 20))
//                        .keyboardType(.asciiCapable)
//                        .autocorrectionDisabled()
//
//
//                }
                TextField("Email ", text: $email)
                    .textFieldStyle(.roundedBorder)
                    .font(.system(size: 20))
                    .keyboardType(.asciiCapable)
                    .autocorrectionDisabled()
                    .padding(10)
                SecureField("Password ", text: $password)
                    .textFieldStyle(.roundedBorder)
                    .font(.system(size: 20))
                    .keyboardType(.asciiCapable)
                    .autocorrectionDisabled()
                    
                .padding(10)
                HStack(spacing: 10){
                    Text("Are you a: ")
                        .font(.system(size: 20))
                    Picker("UserType", selection: $userType, content:{
                        Text("Student").tag("Student")
                        Text("Teacher").tag("Teacher")
                    })
                }
                .padding(10)
                
                
                Button("Login") {
                    if(userType == "Student"){
                        modelData.signinWithEmail(email: email, password: password){ isFound in
                            if isFound {
                                print("LoginSuccessful")
                                noUserFound = false
                                studentLoginSuccessful = true
                            } else {
                                print("LoginFailed")
                                noUserFound = true
                                studentLoginSuccessful = false
                            }
                        }
                    }
                    else if(userType == "Teacher"){
                        teacherModelData.signinWithEmail(email: email, password: password){ isFound in
                            if isFound {
                                print("LoginSuccessful")
                                noUserFound = false
                                teacherLoginSuccessful = true
                            } else {
                                print("LoginFailed")
                                noUserFound = true
                                teacherLoginSuccessful = false
                            }
                        }
                    }

//                    let name = firstName + " " + lastName
//                    if(userType == "Student"){
//                        print("Searching for a student ")
//                        modelData.searchForStudent(studentName: name) { isFound in
//                            if isFound {
//                                print("NO user found")
//                                noUserFound = false
//                                loginSuccessful = true
//                            } else {
//                                noUserFound = true
//                                loginSuccessful = false
//                            }
//                        }
//                    }
//                    else{
//                        print("Searching for a teacher")
//                        modelData.searchForTeacher(teacherName: name) { isFound in
//                            if isFound {
//                                noUserFound = false
//                                loginSuccessful = true
//                            } else {
//                                print("failed to find a teacher")
//                                noUserFound = true
//                                loginSuccessful = false
//                            }
//                        }
//                    }
                    
                }
                .buttonStyle(.bordered)
                .padding(10)
                .alert("No User Found", isPresented: $noUserFound) {
                    Button("Try Again", role: .destructive) { }
                }

                Spacer()
            }
            .navigationDestination(isPresented: $studentLoginSuccessful) {
                StudentAppPage()
            }
            .navigationDestination(isPresented: $teacherLoginSuccessful) {
                TeacherAppPage()
            }
            .navigationTitle("Logout")
            .toolbar(.hidden, for:.navigationBar)
            .navigationBarTitleDisplayMode(.inline)

       }
//    }
    

}

struct LoginPagePreview: PreviewProvider {
    static var previews: some View {
        LoginPage()
            .environmentObject(ModelData())
    }
}
