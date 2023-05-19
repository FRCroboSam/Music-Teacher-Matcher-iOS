//
//  TestView.swift
//  MusicAppSeniorProject
//
//  Created by Samuel Wang on 4/12/23.
//

import SwiftUI
import UIKit
struct TestView: View {
    @State private var password: String = ""
    @State private var showAlert: Bool = false
    @State private var selectedInstrument: String = "Cello"

      var body: some View {
          Form {
//              VStack{
                  Picker("Pick an instrument", selection: $selectedInstrument, content:{
                      Text("Cello").tag("Cello")
                      Text("Piano").tag("Piano")
                      Text("Violin").tag("Violin")
                  })
                  TextField("Enter password", text: $password)
    //                  .padding()
                      .textFieldStyle(RoundedBorderTextFieldStyle())
    //                  .padding(.horizontal, 50)
    //                  .padding(.top, 100)
                      .keyboardType(.asciiCapable)
                      .autocorrectionDisabled()
                  Spacer()
//              }

              
//              Button(action: {
//                  if password == "password" {
//                      // Correct password, perform login logic here
//                      print("Logged in successfully")
//                  } else {
//                      // Incorrect password, show alert
//                      showAlert = true
//                  }
//              }) {
//                  Text("Login")
//                      .font(.title)
//                      .foregroundColor(.white)
//                      .padding()
//                      .background(Color.blue)
//                      .cornerRadius(10)
//              }
//              .padding(.top, 20)
          }
//          .ignoresSafeArea(.keyboard)
          
          .alert(isPresented: $showAlert) {
              Alert(title: Text("Incorrect Password"), message: Text("Please enter the correct password."), dismissButton: .default(Text("OK")))
          }
      }
    //    @State private var readyToNavigate : Bool = false
    //    @State private var firstName: String = ""
    //    @State private var lastName: String = ""
    //    var body: some View {
    //        Spacer()
    //        VStack {
    //            TextField("Enter text", text: $firstName)
    //                .padding()
    //                .textFieldStyle(RoundedBorderTextFieldStyle())
    //                .layoutPriority(0)
    //
    //
    //            Button("Show Alert") {
    //                readyToNavigate = true
    //            }
    //        }
    //        .ignoresSafeArea()
    //        .adaptsToKeyboard()
    //
    //        .alert(isPresented: $readyToNavigate) {
    //            Alert(title: Text("Alert"), message: Text("You entered: \(firstName)"), dismissButton: .default(Text("OK")))
    //        }
    //
    //    }
}
    struct TestView_Previews: PreviewProvider {
        static var previews: some View {
            TestView()
        }
    }
    

