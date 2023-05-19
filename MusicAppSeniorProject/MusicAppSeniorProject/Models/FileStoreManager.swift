//
//  FileStoreManager.swift
//  MusicAppSeniorProject
//
//  Created by Samuel Wang on 2/16/23.
//
import Firebase
import Foundation
class FileStoreManager{

    public static func createStudent(student: Student) {
        let db = Firestore.firestore()

        let docRef = db.collection("StudentData").document(student.name)
        
        docRef.setData([
            "name": student.name,
            "firstName": student.firstName,
            "lastName": student.lastName,
            "age": student.age,
            "email": student.email,
            "instrument": student.selectedInstrument
            
        ]) { error in
            if let error = error {
                print("Error writing document: \(error)")
            } else {
                print("Document successfully written!")
            }
        }
        docRef.collection("comments").document().setData([  // 👈 Create a document in the subcollection
            "title": "testing"
        ])
    }
    public static func matchTeacherToThisStudent(student: Student){
        
    }
//    public static func createTeacher(teacher: Teacher) {
//        let db = Firestore.firestore()
//
//        let docRef = db.collection("TeacherData").document(student.name)
//        
//        docRef.setData([
//            "name": student.name,
//            "age": student.age,
//            "email": student.email,
//            "instrument": student.selectedInstrument
//
//        ]) { error in
//            if let error = error {
//                print("Error writing document: \(error)")
//            } else {
//                print("Document successfully written!")
//            }
//        }
//    }
}
