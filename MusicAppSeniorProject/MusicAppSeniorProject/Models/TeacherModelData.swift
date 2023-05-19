//
//  ModelData.swift
//  MusicAppSeniorProject
//
//  Created by Samuel Wang on 2/23/23.
//

import Foundation
import Firebase
import FirebaseAppCheck
import FirebaseAuth
final class TeacherModelData: ObservableObject{
    @Published var teachers = [Teacher]()
    
    @Published var declinedStudents = [Student]()
    @Published var requestedStudents = [Student]()
    @Published var matchedStudents = [Student]()
    
    @Published var teacherUser = Teacher(name: "Generic User")
    
    @Published var userData: [String: Any]?
    @Published var uid: String = ""
    
    public func createTeacherInFireStore(teacher: Teacher) {
        let db = Firestore.firestore()
        //add Teacher to Teachers
        let docRef = db.collection("Teachers").document(self.uid)
        
        var data = Dictionary<String, Any>()
        for (key, value) in teacher.loginInfo{
            data[key] = value
        }
        for (key, value) in teacher.musicalBackground{
            data[key] = value
        }
        for (key, value) in teacher.teacherInfo{
            data[key] = value
        }
        for (key, value) in teacher.lessonInfo{
            data[key] = value
        }
        data["uid"] = self.uid
        docRef.setData(data)
        //sets userData to be the newly created document data
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                self.userData = document.data()
            } else {
                print("Document does not exist")
            }
        }
        //Add a section for the teacher that carries all their students
        docRef.collection("Requested Students").document().setData([  // 👈 Create a document in the subcollection
            "title": "testing"
                                                                   ])
        docRef.collection("Matched Students").document().setData([  // 👈 Create a document in the subcollection
            "title": "testing"
                                                                  ])
        docRef.collection("Declined Students").document().setData([  // 👈 Create a document in the subcollection
            "title": "testing"
                                                                  ])
    }
    
    //use this after logging in (NOT SIGNUP) to create the teacher object
    //basically fetches teacherData from the database
    func createTeacherFromId(uid: String, completion: @escaping (Bool) -> Void ){
        let db = Firestore.firestore()
        let docRef = db.collection("Teachers").document(uid)

        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                let loginInfo:KeyValuePairs = [
                    "email": (data!["email"] ?? "Generic User") as! String,
                    "password": (data!["password"] ?? "Generic User") as! String
                ]
                let musicalBackground:KeyValuePairs = [
                    "Instrument": (data!["Instrument"] ?? "Generic User") as! String,
                    "Years Teaching": (data!["Years Teaching"] ?? "Generic User") as! String,
                    "Musical Degree": (data!["Musical Degree"] ?? "Generic User") as! String,
                    "Teaching Style": (data!["Teaching Style"] ?? "Generic User") as! String,
                ]
                let lessonInfo:KeyValuePairs = [
                    "Lesson Length": (data!["Lesson Length"] ?? "Generic User") as! String,
                    "Pricing": (data!["email"] ?? "Generic User") as! String,
                    "Minimum Student Level": (data!["email"] ?? "Generic User") as! String,
                ]
                let teacherInfo:KeyValuePairs = [
                    "name": (data!["name"] ?? "Generic User") as! String,
                    "firstName": (data!["email"] ?? "Generic User") as! String,
                    "lastName": (data!["email"] ?? "Generic User") as! String
                ]
                var name = (data!["name"] ?? "Generic User") as! String
                self.userData = data
                self.teacherUser = Teacher(name: name)
                self.teacherUser.uid = uid
                self.teacherUser.populateInfo(teacherInfo: teacherInfo, loginInfo: loginInfo, musicalBackground: musicalBackground, lessonInfo: lessonInfo)
                completion(true)
                
            } else {
                print("Document does not exist")
                completion(false)
            }
        }
    }
    func createStudentFromData(documentSnapshot: DocumentSnapshot) -> Student{
        let data = documentSnapshot.data()
        let loginInfo:KeyValuePairs = [
            "email": (data!["email"] ?? "Generic User") as! String,
            "password": (data!["password"] ?? "Generic User") as! String
        ]
        let musicalBackground:KeyValuePairs = [
            "Instrument": (data!["Instrument"] ?? "Generic User") as! String,
            "Years Playing": (data!["Years Playing"] ?? "Generic User") as! String,
            "Skill Level": (data!["Skill Level"] ?? "Generic User") as! String,
            "Prior Pieces Played": (data!["Prior Pieces Played"] ?? "Generic User") as! String,
            "Budget": (data!["Budget"] ?? "Generic User") as! String
        ]
        let studentInfo:KeyValuePairs = [
            "name": (String(describing:data!["name"]) ?? "Generic User") as! String,
            "age": String(format: "%@", (data!["age"] ?? "0") as! CVarArg)

        ]
        var name = (data!["name"] ?? "Generic User") as! String
        var student = Student(name: name)
        student.uid = data!["uid"] as? String ?? ""
        student.populateInfo(personalInfo: studentInfo, loginInfo: loginInfo, musicalBackground: musicalBackground)
        return student 
    }
    
    
    func fetchStudentData(completion: @escaping() -> Void) {
        print("Fetching Student Data ")
        let db = Firestore.firestore()
        let declinedStudentsRef = db.collection("Teachers").document(uid).collection("Declined Students")
        let matchedStudentsRef = db.collection("Teachers").document(uid).collection("Matched Students")
        let requestedStudentsRef = db.collection("Teachers").document(uid).collection("Requested Students")
        //populate declined teachers
        declinedStudentsRef.addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching document: \(error!)")
                return
              }
            self.declinedStudents = documents.compactMap { documentSnapshot in
                let data = documentSnapshot.data()
                let uid = data["uid"] as? String ?? ""
                let canAdd = !(self.requestedStudents + self.matchedStudents).contains { $0.uid == uid }
                if canAdd && !uid.isEmpty{
                    return self.createStudentFromData(documentSnapshot: documentSnapshot)
                } else {
                    return nil // Return nil if the condition is not met
                }
            }
            print("Declined STUDENTS SIZE: " + String(self.declinedStudents.count))

        }
        //populate Matched teachers
        matchedStudentsRef.addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching document: \(error!)")
                return
              }
            self.matchedStudents = documents.compactMap { documentSnapshot in
                let data = documentSnapshot.data()
                let uid = data["uid"] as? String ?? ""
                let canAdd = !(self.declinedStudents + self.requestedStudents).contains { $0.uid == uid }
                if canAdd && !uid.isEmpty{
                    return self.createStudentFromData(documentSnapshot: documentSnapshot)
                } else {
                    return nil // Return nil if the condition is not met
                }
            }
            print("MATCHED STUDENTS SIZE: " + String(self.matchedStudents.count))
        }
        //populate requested students - cannot be declined/matched
        requestedStudentsRef.addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching document: \(error!)")
                return
              }
            self.requestedStudents = documents.compactMap { documentSnapshot in
                let data = documentSnapshot.data()
                let uid = data["uid"] as? String ?? ""
                let canAdd = !(self.declinedStudents + self.matchedStudents).contains { $0.uid == uid }
                if canAdd && !uid.isEmpty{
                    return self.createStudentFromData(documentSnapshot: documentSnapshot)
                } else {
                    return nil // Return nil if the condition is not met
                }
            }
            print("Requested STUDENTS SIZE: " + String(self.requestedStudents.count))

            completion() 
        }
    }
    //add student to 
    func declineStudent(studentUID: String){
        let db = Firestore.firestore()
        let collectionRef = db.collection("Teachers")
        //where the teacher's declined students are stored
        let declinedStudentsRef = db.collection("Teachers").document(uid).collection("Declined Students")
        //where the students declined teacher's are stored
        let declinedTeachersRef = db.collection("StudentUser").document(studentUID).collection("Declined Teachers")
        let studentRef = db.collection("StudentUser").document(studentUID)
        let requestedStudentsRef = db.collection("Teachers").document(uid).collection("Requested Students")
        let requestedTeachersRef = db.collection("StudentUser").document(uid).collection("Requested Teachers")

        studentRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                declinedStudentsRef.document(studentUID).setData(data ?? ["": ""])
                declinedTeachersRef.document(self.uid).setData(self.userData ?? ["":""])
            } else {
                print("Document does not exist")
            }
        }
        requestedStudentsRef.document(studentUID).delete() { err in
             if let err = err {
                 print("Error removing document: \(err)")
             } else {
                 print("Document successfully removed!")
             }
         }
         requestedTeachersRef.document(uid).delete() { err in
              if let err = err {
                  print("Error removing document: \(err)")
              } else {
                  print("Document successfully removed!")
              }
          }
    }
    func matchStudent(studentUID: String){
        let db = Firestore.firestore()
        let collectionRef = db.collection("Teachers")
        //where the teacher's matched students are stored
        let matchedStudentsRef = db.collection("Teachers").document(uid).collection("Matched Students")
        //where the students matched teacher's are stored
        let matchedTeachersRef = db.collection("StudentUser").document(studentUID).collection("Matched Teachers")
        let requestedStudentsRef = db.collection("Teachers").document(uid).collection("Requested Students")
        let requestedTeachersRef = db.collection("StudentUser").document(studentUID).collection("Requested Teachers")

        let studentRef = db.collection("StudentUser").document(studentUID)
        studentRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                matchedStudentsRef.document(studentUID).setData(data ?? ["": ""])
                //BUGGG
                matchedTeachersRef.document(self.uid).setData(self.userData ?? ["":""])
            } else {
                print("Document does not exist")
            }
        }
        //remove student from teacher's requested students
       requestedStudentsRef.document(studentUID).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
        requestedTeachersRef.document(uid).delete() { err in
             if let err = err {
                 print("Error removing document: \(err)")
             } else {
                 print("Document successfully removed!")
             }
         }

    }
    //clear matched students/declined students
    func resetTeacher(){
        let db = Firestore.firestore()
        let matchedTeachersRef = db.collection("Teachers").document(uid).collection("Matched Students")
        matchedTeachersRef.getDocuments { (snapshot, err) in
            if let err = err {
                print("Error getting document: \(err)")
            } else if (snapshot?.isEmpty)! {
            } else {
                for document in (snapshot?.documents)! {
                    document.reference.delete()
                }
            }
        }
        
    }
    func signinWithEmail(email: String, password: String, completion: @escaping (Bool) -> Void){
        Auth.auth().signIn(withEmail: email, password: password) { result, err in
            if let err = err {
                print("Failed due to error:", err)
                completion(false)
                return
            }
            print("SIGNED IN SUCCESSFUlly")
            let user = Auth.auth().currentUser
            self.uid = user?.uid ?? "null"
            self.createTeacherFromId(uid: self.uid){ isCreated in
                if(isCreated){
                    completion(true)
                }
                else{
                    completion(false)
                }
            }
            
            // ...
        }//
        
    }
    
    func submitProfile(teacher: Teacher, completion: @escaping (Bool)->Void){
        print("Emial: " + teacher.email)
        print("Password: " + teacher.password)
        Auth.auth().createUser(withEmail: teacher.email, password: teacher.password){authResult, error in
            if(authResult != nil){
                print("CREATED THE TEACHER")
                self.uid = authResult?.user.uid ?? "null"
                self.createTeacherInFireStore(teacher: teacher)
                completion(true)
            }
            else{
                completion(false)
                print("FAILED TO CREATE Teacher USER")
            }
            
        }
        //        modelData.createStudent(student: student)
        //        modelData.studentUser = Student(name: firstName + " " + lastName)
        //        modelData.studentUser.populateInfo(firstName: firstName, lastName: lastName, age: age, price: price, email: email, selectedInstrument: selectedInstrument)
        
        
        
        
        
    }
}
