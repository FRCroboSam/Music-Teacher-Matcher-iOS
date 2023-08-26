//
//  ProfilePage.swift
//  MusicAppSeniorProject
//
//  Created by Samuel Wang on 1/27/23.
//

import SwiftUI
struct StudentAppPage: View {
    @Environment(\.dismiss) private var dismiss
    @State private var moveOn: Bool = false 
    @EnvironmentObject var modelData: ModelData
    @State private var displayArray: [Teacher] = [Teacher]()
    @State private var displayText: String = ""
    @State private var description: String = ""
    @State private var infoText: String = ""
    @State private var currentPage: Int = 0
    @State private var fetchedTeacherData: Bool = false
    @State private var selection = 0
    @State private var doStuff = 0
    @State private var loggedOut = false
    private let categories = ["Available", "Declined", "Matched", "Requested"]
    @State private var profilePhoto:UIImage?
    private let availableTeacherDesc = "Teachers to request or decline."
    private let requestedTeacherDesc = "Teachers that can match with you."
    private let matchedTeacherDesc = "Send these teachers a message!"
    private let declinedTeacherDesc = "These are teachers that you have declined since they did not fit your needs."
    @State var numNotifications = 4
    @State private var tabSelection: TabBarItem = .requested

    var body: some View {
        NavigationStack{
            ZStack{
                //slider to toggle distance between teacher and student
                CustomTabBarContainerView(selection: $tabSelection) {
                    TeacherListView(displayArray: $modelData.availableTeachers, uiImage: $modelData.uiImage, status: "Available Teachers", displayText: availableTeacherDesc)
                               .tabBarItem(tab: .available, selection: $tabSelection)
                    TeacherListView(displayArray: $modelData.requestedTeachers, uiImage: $modelData.uiImage, status: "Requested Teachers", displayText: requestedTeacherDesc)
                               .tabBarItem(tab: .requested, selection: $tabSelection)
                    TeacherListView(displayArray: $modelData.matchedTeachers, uiImage: $modelData.uiImage, status: "Matched Teachers", displayText: matchedTeacherDesc)

                        .tabBarItem(tab: .matched, selection: $tabSelection)
                    CreateStudentProfilePage(editMode: true, student:modelData.studentUser)
                               .tabBarItem(tab: .editProfile, selection: $tabSelection)
                       }
                .navigationDestination(isPresented: $loggedOut) {
                    HomePage()
                }
                .onAppear() {
                    let teacher = Teacher(name: "DF")
                    modelData.teacherDistance(teacher: teacher, student: modelData.studentUser, completion: { _ in
                        
                    })
                    UITabBarItem.appearance().badgeColor = .systemOrange

                    if(modelData.uiImage == nil && !(modelData.uid == "")){
//                        modelData.fetchImage { downloaded in
//                            if downloaded{
//                                print("DOWNLOADED for: " + modelData.uid)
//                                profilePhoto = modelData.uiImage
//                            }
//                            else{
//                                profilePhoto = UIImage(systemName: "person.fill")
//                            }
//                        }
                    }
                }
            }
        }     .navigationBarBackButtonHidden(true) // Hide default button


    }
    
}
//struct MainAppPage_Previews: PreviewProvider {
//    static var previews: some View {
//        StudentAppPage(dismiss: dismiss)
//            .environmentObject(ModelData())
//    }
//}



//OUttakes

/*
 let tapOption = Binding<Int>(
     get: {
         selection
     },
     set: {
         selection = $0
         if(selection == 0){
             displayText = "Available Teachers"
             displayArray = modelData.availableTeachers
             description = availableTeacherDesc
         }
         else if(selection == 1){
             displayText = "Declined Teachers"
             displayArray = modelData.declinedTeachers
             description = declinedTeacherDesc
         }
         else if(selection == 2){
             displayText = "Matched Teachers"
             displayArray = modelData.matchedTeachers
             description = matchedTeacherDesc
         }
         else{
             displayText = "Requested Teachers"
             displayArray = modelData.requestedTeachers
             description = requestedTeacherDesc
         }
     }
 )
 Picker(selection: tapOption, label: Text("Category")) {
     ForEach(0..<categories.count, id: \.self) {
         Text(categories[$0])
     }
 }.pickerStyle(SegmentedPickerStyle())
 
 
     .padding(10)
 Text(displayText)
 
 
 
 List(displayArray) { teacher in
     NavigationLink{
         TeacherProfilePage(teacher: teacher, displayText: displayText)
     } label:{
         HStack{
             ProfileImage(image: Image(uiImage: (teacher.uiImage ?? UIImage(systemName: "heart.fill"))!), size: 50)
             VStack(alignment: .leading) {
                 Spacer()
                 Text(teacher.name).font(.title)
                 Text(teacher.instrument).font(.subheadline)
             }
         }

     }
 }//.navigationBarTitle("Student User")
 */

