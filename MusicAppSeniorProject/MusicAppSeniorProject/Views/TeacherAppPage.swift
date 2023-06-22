//
//  ProfilePage.swift
//  MusicAppSeniorProject
//
//  Created by Samuel Wang on 1/27/23.
//

import SwiftUI

struct TeacherAppPage: View {
    @EnvironmentObject var modelData: TeacherModelData
    @State private var displayArray: [Student] = [Student]()
    @State private var displayText: String = ""
    @State private var currentPage: Int = 0
    @State private var selection = 0
    @State private var doStuff = 0
    private let categories = ["Requested Students", "Matched Students", "Declined Students"]
    private let requestedDesc = "These are students that have requested you - you can match with them to schedule an interview or decline them if they are not a good fit"
    private let matchedDesc = "These are students you have matched - expect an email from them to schedule an interview!"
    private let declinedDesc = "These are students that you have decided not to match. "
    private var desc = ""
    var body: some View {
            VStack{
                Text(modelData.teacherUser.name)
                
                let tapOption = Binding<Int>(
                       get: {
                          selection
                       },
                       set: {
                          selection = $0
                           if(selection == 0){
                               displayText = "Requested Students"
                               displayArray = modelData.requestedStudents
                           }
                           else if(selection == 1){
                               displayText = "Matched Students"
                               displayArray = modelData.matchedStudents
                           }
                           else if(selection == 2){
                               displayText = "Declined Students"
                               displayArray = modelData.declinedStudents
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
                List(displayArray) { student in
                    NavigationLink{
                        StudentProfilePage(student: student, displayText: displayText)
                    } label:{
                        VStack(alignment: .leading) {
                            Spacer()
                            Text(student.name).font(.title)
                            Text(student.selectedInstrument).font(.subheadline)
                        }
                    }
                }.navigationBarTitle("Students")
                    .onAppear() {
                        selection = 0
                        displayText = "Requested Students"
                        modelData.fetchStudentData(){
                            displayArray = modelData.requestedStudents
                        }
                    }
 
            }
            Spacer()
            .onAppear{
            }
        }
}

struct TeacherAppPage_Previews: PreviewProvider {
    static var previews: some View {
        TeacherAppPage()
            .environmentObject(TeacherModelData())
    }
}
