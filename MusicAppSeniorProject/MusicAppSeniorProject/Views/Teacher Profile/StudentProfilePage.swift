////
////  LandmarkDetail.swift
////  TutorialProject
////
////  Created by Samuel Wang on 1/10/23.
////
//
import SwiftUI

struct StudentProfilePage: View {
    @State var student: Student
    public var displayText: String
    public var status: String
    let studentImage: UIImage?
    @EnvironmentObject var modelData: TeacherModelData
    @StateObject var viewModel = ProfileModel()
    @Environment(\.dismiss) var dismiss


    var body: some View {
        let keys = student.personalInfo.map{$0.key}
        let values = student.personalInfo.map {$0.value}
        
        let keysMusic = student.musicalBackground.map{$0.key}
        let valuesMusic = student.musicalBackground.map{$0.value}
        
        let name: String? = student.name

        Form{
            ProfileImage(image: Image(uiImage:(studentImage ?? UIImage(systemName: "person.fill"))!), size:100)
            HStack{
                Text((name ?? "No Name"))
                    .font(.title)
                
            }
            if(status == "Matched Students"){
                Text("Expect an email from this student to schedule a lesson!")
            }
            
            Section {
                ForEach(keys.indices) {index in
                    HStack {
                        Text(keys[index] + ": ")
                        Text("\(values[index])")
                    }
                }
            }
            Section {
                ForEach(keysMusic.indices) {index in
                    HStack {
                        Text(keysMusic[index] + ": ")
                        Text("\(valuesMusic[index])")
                    }
                }
            }
        

                
            if(status != "Declined Students" && status != "Matched Students"){
                Button("Decline Student"){
                    Text("If you think this student is not a good fit, you can decline them. ")
                    modelData.declineStudent(studentUID: student.uid)
                    dismiss()
                }
                Button("Match Student"){
                    Text("If you think this student is a good fit, you can match with them, allowing them to see your contact info. ")
                    modelData.matchStudent(studentUID: student.uid)
                    dismiss()
                }
            }

                
                
        }.onAppear{
            print("SHOWING THE VIEW")
        }
            .navigationTitle(student.firstName + ", " + student.lastName)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
//    struct StudentProfilePage_Previews: PreviewProvider {
//        static var previews: some View {
//            
//            StudentProfilePage(student: Student.createGenericStudent(), displayText: "generic")
//                .environmentObject(ModelData())
//        }
//    }

