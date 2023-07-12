//
//  TeacherListView.swift
//  MusicAppSeniorProject
//
//  Created by Samuel Wang on 6/19/23.
//

import SwiftUI

struct StudentListView: View {
    @EnvironmentObject var modelData: ModelData
    @Binding var displayArray: [Student]
    @Binding var uiImage: UIImage?
    let status: String
    let displayText: String
    @State private var loggedOut = false
    var body: some View {
        VStack{
            Spacer(minLength:20)
            ProfileImage(image: Image(uiImage:(uiImage ?? UIImage(systemName: "person.fill"))!), size: 100)

            Text(status)
                .font(.system(size: 40))
                .fontWeight(.bold)
                .padding(10)
            Text(displayText)
                .padding(10)
            List(displayArray) { student in
                NavigationLink{
//                    TeacherProfilePage(teacher: modelData.teacherUser, displayText: displayText, status: status, teacherImage: (modelData.teacherUser.uiImage ?? UIImage(systemName: "heart.fill"))!)
                    StudentProfilePage(student: student, displayText: displayText, status: status, studentImage: (student.uiImage ?? UIImage(systemName: "heart.fill"))!)
                } label:{
                    HStack{
                        ProfileImage(image: Image(uiImage: (student.uiImage ?? UIImage(systemName: "heart.fill"))!), size: 50)
                        VStack(alignment: .leading) {
                            Spacer()
                            Text(student.name).font(.title)
                            Text(student.selectedInstrument).font(.subheadline)
                        }
                    }

                }
            }

        }
        
}

//struct TeacherListView_Previews: PreviewProvider {
//    static var previews: some View {
////        TeacherListView()
//    }
}
