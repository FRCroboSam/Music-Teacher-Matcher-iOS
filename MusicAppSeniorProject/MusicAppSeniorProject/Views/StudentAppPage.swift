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
    private let categories = ["Available", "Declined", "Matched", "Requested"]
    @State private var profilePhoto:UIImage?
    var body: some View {
        
//        modelData.fetchImage { image in
//            if let image = image{
//                profilePhoto = modelData.uiImage
//            }
//            else{
//               profilePhoto = UIImage(systemName: "heart.fill")
//            }
//        }
        NavigationStack{
            VStack{
                ProfileImage(image: Image(uiImage:(profilePhoto ?? UIImage(systemName: "heart.fill"))!))
                Text("Welcome, " + modelData.studentUser.name + "!")
                    .font(.system(size: 40))
                    .fontWeight(.bold)
                    .padding(10)
                let tapOption = Binding<Int>(
                       get: {
                          selection
                       },
                       set: {
                          selection = $0
                           if(selection == 0){
                               print("Setting the Teacher")
                               displayText = "Available Teachers"
                               displayArray = modelData.availableTeachers
                               description = "These are teachers in the area that you can request if you think they are a good fit or respectfully decline. Teachers will not see that you have declined them."
                           }
                           else if(selection == 1){
                               displayText = "Declined Teachers"
                               displayArray = modelData.declinedTeachers
                               description = "These are teachers that you have declined since they did not fit your needs."
                           }
                           else if(selection == 2){
                               displayText = "Matched Teachers"
                               displayArray = modelData.matchedTeachers
                               description = "These are teachers that you have requested and have matched your request. Feel Free to reach out to them by their email which you can find by clicking on their profile!"
                           }
                           else{
                               displayText = "Requested Teachers"
                               displayArray = modelData.requestedTeachers
                               description = "These are teachers that you have requested but have not matched yet."
                           }
                       }
                   )
                       //...
                       Picker(selection: tapOption, label: Text("Category")) {
                          ForEach(0..<categories.count, id: \.self) {
                             Text(categories[$0])
                          }
                       }.pickerStyle(SegmentedPickerStyle())
//                Picker("Teacher", selection: $currentPage) {
//                    Text("Available").tag(0)
//                    Text("Declined").tag(1)
//                    Text("Matches").tag(2)
//                }.pickerStyle(.segmented)

                .padding(10)
                Text(displayText)
                Text(description)
                    .padding(10)
                List(displayArray) { teacher in
                    NavigationLink{
                        TeacherProfilePage(teacher: teacher, displayText: displayText)
                    } label:{
                        VStack(alignment: .leading) {
                            Spacer()
                            Text(teacher.name).font(.title)
                            Text(teacher.instrument).font(.subheadline)
                        }
                    }
                }.navigationBarTitle("Student User")
                    .onAppear() {
                        print("FETCHING THE DATA")
                        displayText = "Available Teachers"
                        selection = 0
                        description = "These are teachers in the area that you can request if you think they are a good fit or respectfully decline. Teachers will not see that you have declined them."

                        modelData.fetchTeacherData(){
                            displayArray = modelData.availableTeachers
                            print("FETCHING DATA DISPLAY COUNT: " + String(displayArray.count))
                            for teacher in displayArray{
                                print("TEACHER UID: " + teacher.uid)
                            }
                        }
//                        modelData.fetchImage { downloaded in
//                            if downloaded{
//                                profilePhoto = modelData.uiImage
//                            }
//                            else{
//                               profilePhoto = UIImage(systemName: "heart.fill")
//                            }
//                        }
                        modelData.fetchImageAfterUploaded { downloaded in
                            if downloaded{
                                profilePhoto = modelData.uiImage
                            }
                            else{
                               profilePhoto = UIImage(systemName: "heart.fill")
                            }
                        }

                    }
            }
            Spacer()
            .onAppear{
            }
        }
    }
}
struct MainAppPage_Previews: PreviewProvider {
    static var previews: some View {
        StudentAppPage()
            .environmentObject(ModelData())
    }
}
