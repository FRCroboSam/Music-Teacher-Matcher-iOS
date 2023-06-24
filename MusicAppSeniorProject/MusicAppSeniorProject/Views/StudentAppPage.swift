//
//  ProfilePage.swift
//  MusicAppSeniorProject
//
//  Created by Samuel Wang on 1/27/23.
//

import SwiftUI

struct StudentAppPage: View {
    @EnvironmentObject var modelData: ModelData
    @State private var displayArray: [Teacher] = [Teacher]()
    @State private var displayText: String = ""
    @State private var description: String = ""
    @State private var infoText: String = ""
    @State private var currentPage: Int = 0
    @State private var selection = 0
    @State private var doStuff = 0
    @State private var loggedOut = false
    private let categories = ["Available", "Declined", "Matched", "Requested"]
    @State private var profilePhoto:UIImage?
    private let availableTeacherDesc = "These are teachers in the area that you can request if you think they are a good fit or respectfully decline. Teachers will not see that you have declined them."
    private let requestedTeacherDesc = "These are teachers that you have requested but have not matched yet."
    private let matchedTeacherDesc = "These are teachers that you have requested and have matched your request. Feel Free to reach out to them by their email which you can find by clicking on their profile!"
    private let declinedTeacherDesc = "These are teachers that you have declined since they did not fit your needs."
    var body: some View {
        NavigationStack{
            ZStack{
                TabView{
                    TeacherListView(displayArray: $modelData.availableTeachers, uiImage: $modelData.uiImage, displayText: availableTeacherDesc)
                        .tabItem{
                            Label("Available", systemImage: "person.crop.circle.fill.badge.plus")
                        }
                    TeacherListView(displayArray: $modelData.requestedTeachers, uiImage: $modelData.uiImage, displayText: requestedTeacherDesc)
                        .tabItem{
                            Label("Requested", systemImage: "person.crop.circle.badge.questionmark")
                        }
                    TeacherListView(displayArray: $modelData.matchedTeachers, uiImage: $modelData.uiImage, displayText: matchedTeacherDesc)
                        .tabItem{
                            Label("Matched", systemImage: "person.crop.circle.badge.checkmark")
                        }
                    CreateStudentProfilePage(editMode:true, student: modelData.studentUser)
                        .tabItem{
                            Label("Edit Profile", systemImage: "person.crop.circle.fill")
                        }
                }
                Button("Logout", action: {
                    modelData.logOut();
                    loggedOut = true
                })
                .onAppear() {
                    if(modelData.uiImage == nil && !(modelData.uid == "")){
                        modelData.fetchImage { downloaded in
                            if downloaded{
                                print("DOWNLOADED for: " + modelData.uid)
                                profilePhoto = modelData.uiImage
                            }
                            else{
                                profilePhoto = UIImage(systemName: "heart.fill")
                            }
                        }
                    }
                    
                    
                }
                
                
            }
            //            TabView{
            //
            //                    .tabItem{
            //                        Label("Menu", systemImage: "list.dash")
            //                    }
            //            }
        }.navigationDestination(isPresented: $loggedOut) {
            HomePage()
        }
    }
    
}
struct MainAppPage_Previews: PreviewProvider {
    static var previews: some View {
        StudentAppPage()
            .environmentObject(ModelData())
    }
}



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
