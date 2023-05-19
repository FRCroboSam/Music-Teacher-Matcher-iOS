////
////  MatchMakingPage.swift
////  MusicAppSeniorProject
////
////  Created by Samuel Wang on 2/13/23.
////
//
//import SwiftUI
//
//struct MatchMakingPage: View{
//    @State private var readyToNavigate : Bool = false
//    var body: some View {
//        NavigationStack {
//           VStack {
//              Button {
//                  //Code here before changing the bool value
//                  readyToNavigate = true
//              } label: {
//                  Text("Navigate Button")
//              }
//          }
//           .navigationTitle("Navigation")
//           .navigationDestination(isPresented: $readyToNavigate) {
//              StudentProfile()
//          }
//       }
//
//}
//    struct MatchMakingPage: PreviewProvider {
//        static var previews: some View {
//            MatchMakingPage()
//        }
//    }
