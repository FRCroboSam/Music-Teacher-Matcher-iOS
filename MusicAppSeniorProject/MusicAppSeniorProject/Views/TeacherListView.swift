//
//  TeacherListView.swift
//  MusicAppSeniorProject
//
//  Created by Samuel Wang on 6/19/23.
//

import SwiftUI
enum teacherType{
    case AVAILABLE, REQUESTED, DECLINED, MATCHED
}
struct TeacherListView: View {
    @EnvironmentObject var modelData: ModelData
    @Binding var displayArray: [Teacher]
    @Binding var uiImage: UIImage?
    let displayText: String
    @State private var loggedOut = false
    var body: some View {
        VStack{
            Spacer(minLength:20)
            ProfileImage(image: Image(uiImage:(uiImage ?? UIImage(systemName: "person.fill"))!), size: 100)

            Text("Welcome, " + modelData.studentUser.name + "!")
                .font(.system(size: 40))
                .fontWeight(.bold)
                .padding(10)
            Text(displayText)
                .padding(10)
            List(displayArray) { teacher in
                NavigationLink{
                    TeacherProfilePage(teacher: teacher, displayText: displayText, teacherImage: (teacher.uiImage ?? UIImage(systemName: "heart.fill"))!)
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
            }

        }
        
}

//struct TeacherListView_Previews: PreviewProvider {
//    static var previews: some View {
////        TeacherListView()
//    }
}
