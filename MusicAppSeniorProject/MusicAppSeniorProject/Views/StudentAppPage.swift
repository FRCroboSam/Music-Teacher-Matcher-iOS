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
    private let availableTeacherDesc = "These are teachers in the area that you can request if you think they are a good fit or respectfully decline. Teachers will not see that you have declined them."
    private let requestedTeacherDesc = "These are teachers that you have requested but have not matched yet."
    private let matchedTeacherDesc = "These are teachers that you have requested and have matched your request. Feel Free to reach out to them by their email which you can find by clicking on their profile!"
    private let declinedTeacherDesc = "These are teachers that you have declined since they did not fit your needs."
    var body: some View {
        NavigationStack{
                    ProfileImage(image: Image(uiImage:(modelData.uiImage ?? UIImage(systemName: "heart.fill"))!))
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
//                    Text(description)
//                        .padding(10)
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
                    }//.navigationBarTitle("Student User")
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
                            modelData.fetchImageAfterUploaded { downloaded in
                                if downloaded{
                                    print("DOWNLOADED")
                                    profilePhoto = modelData.uiImage
                                }
                                else{
                                    profilePhoto = UIImage(systemName: "heart.fill")
                                }
                            }
                        }
                        //logic may be jank
                        .onReceive(modelData.$availableTeachers) { newTeachers in
                            print("HELLO")
                            displayArray = newTeachers
                        }


                }
                Spacer()
        }
    
}
struct MainAppPage_Previews: PreviewProvider {
    static var previews: some View {
        StudentAppPage()
            .environmentObject(ModelData())
    }
}
