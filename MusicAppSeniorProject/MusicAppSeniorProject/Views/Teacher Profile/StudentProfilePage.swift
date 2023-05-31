////
////  LandmarkDetail.swift
////  TutorialProject
////
////  Created by Samuel Wang on 1/10/23.
////
//
import SwiftUI

struct StudentProfilePage: View {
    public var student: Student
    @EnvironmentObject var modelData: TeacherModelData
    var mirrored_object = Mirror(reflecting: "")
    @StateObject var viewModel = ProfileModel()
    @Environment(\.dismiss) var dismiss


    public var displayText: String
    var body: some View {
        let keys = student.personalInfo.map{$0.key}
        let values = student.personalInfo.map {$0.value}
        
        let keysMusic = student.musicalBackground.map{$0.key}
        let valuesMusic = student.musicalBackground.map{$0.value}
        
        let name: String? = student.name
        let instrument: String? = student.selectedInstrument

        Form{
            HStack{
//                EditableCircularProfileImage(viewModel: viewModel)
                Text((name ?? "No Name"))
                    .font(.title)
                
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
        

                
            if(displayText != "Declined Students" && displayText != "Matched Students"){
                Button("Decline Student"){
                    Text("If you think this student is not a good fit, you can decline them. ")
                    modelData.declineStudent(studentUID: student.uid)
                }
                Button("Match Student"){
                    Text("If you think this student is a good fit, you can match with them, allowing them to see your contact info. ")
                    modelData.matchStudent(studentUID: student.uid)
                }
            }

                
                
            }
            .navigationTitle(student.firstName + ", " + student.lastName)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    struct StudentProfilePage_Previews: PreviewProvider {
        static var previews: some View {
            
            StudentProfilePage(student: Student.createGenericStudent(), displayText: "generic")
                .environmentObject(ModelData())
        }
    }

