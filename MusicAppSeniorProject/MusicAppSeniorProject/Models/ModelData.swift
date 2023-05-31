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
import FirebaseStorage
import FirebaseFirestore
import SwiftUI
final class ModelData: ObservableObject{
    @Published var students =  [Student]()
    @Published var teachers = [Teacher]()
    
    //for student users
    @Published var availableTeachers = [Teacher]()
    @Published var declinedTeachers = [Teacher]()
    @Published var requestedTeachers = [Teacher]()
    @Published var matchedTeachers = [Teacher]()
    
    
    @Published var studentUser = Student(name:"Generic User")
    @Published var teacherUser = Teacher(name: "Generic User")
    
    @Published var userData: [String: Any]?
    @Published var uid: String = ""
    
    @Published var profileImage: ProfileModel?
    @Published var uiImage: UIImage?
    
//    var user: User? {
//        didSet {
//            objectWillChange.send()
//        }
//    }
//    func listenToAuthState() {
//        Auth.auth().addStateDidChangeListener { [weak self] _, user in
//            guard let self = self else {
//                return
//            }
//            self.user = user
//        }
//    }
    public func populateStudentsList(){
        let db = Firestore.firestore()
        db.collection("cities").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                }
            }
        }

    }
    //TODO: ADD COMPLETION to adding the image 
    public func createStudentInFirestore(student: Student, completion: @escaping(Bool) -> Void) {
        let db = Firestore.firestore()
        let docRef = db.collection("StudentUser").document(uid)
        var data = Dictionary<String, Any>()
        for (key, value) in student.loginInfo{
            data[key] = value
        }
        for (key, value) in student.musicalBackground{
            data[key] = value
        }
        for (key, value) in student.personalInfo{
            data[key] = value
        }
        data["uid"] = self.uid
        docRef.setData(data)

//        docRef.setData([
//            "name": student.name,
//            "firstName": student.firstName,
//            "lastName": student.lastName,
//            "age": student.age,
//            "email": student.email,
//            "instrument": student.selectedInstrument,
//            "uid": student.uid
//
//        ]) { error in
//            if let error = error {
//                print("Error writing document: \(error)")
//            } else {
//                print("Document successfully written!")
//            }
//        }
        docRef.collection("Available Teachers").document().setData([  // 👈 Create a document in the subcollection
            "title": "testing"
        ])
        docRef.collection("Matched Teachers").document().setData([  // 👈 Create a document in the subcollection
            "title": "testing"
        ])
        docRef.collection("Declined Teachers").document().setData([  // 👈 Create a document in the subcollection
            "title": "testing"
        ])
        docRef.collection("Requested Teachers").document().setData([  // 👈 Create a document in the subcollection
            "title": "testing"
        ])
        uploadImage(student: student) { Bool in
            
        }
        //set modelData
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                self.userData = document.data()
                completion(true)
            } else {
                print("Document does not exist")
            }
        }

//        let storage = Storage.storage()
//        let storageRef = storage.reference(withPath: uid)
//        let image = student.getUIImage()
//        guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }
//        storageRef.putData(imageData, metadata: nil) { metadata, err in
//            if let err = err {
//                //if image doesn't work, still upload the profile to firestore
//                completion(true)
//                print("Failed to push image to Storage:")
//                return
//            }
//
//            storageRef.downloadURL { url, err in
//                if let err = err {
//                    print("Failed to retrieve downloadURL")
//                    completion(true)
//                    return
//                }
//
//                print("Successfully stored image with url: \(url?.absoluteString ?? "")")
//                print(url?.absoluteString)
//                completion(true)
//            }
//        }
        print("Finished Writing Everything")
    }
    //returns the data for a student or a teacher
    //docRef is the reference to the teacher/student's document(last param should be the uid)
    func getUserData(docRef: DocumentReference, completion:@escaping ([String: Any?]) -> Void){
        var data = [String:Any]()
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                data = document.data() ?? ["":""]
                completion(data)
            }
        }
//        return data
    }
    //TODO tesT THIS
    func fetchImage(completion:@escaping(Bool) -> Void ){
        print("FETCHING THE IMAGE from USer: " + uid)
        let storage = Storage.storage()
        let storageRef = storage.reference(withPath: uid)
        storageRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
          if let error = error {
            // Uh-oh, an error occurred!
            completion(false)
          } else {
              print("Successfully fetched image")
            // Data for "images/island.jpg" is returned
              self.uiImage = UIImage(data: data!) ?? UIImage(systemName: "heart.fill")
            completion(true)
          }
        }
    }
    func fetchTeacherImage(teacher: Teacher, completion:@escaping(UIImage?) -> Void){
        print("Fetching Teacher Image" + uid)
        let storage = Storage.storage()
        let storageRef = storage.reference(withPath: teacher.uid)
        storageRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
          if let error = error {
            // Uh-oh, an error occurred!
            completion(nil)
          } else {
              print("Successfully fetched teacher image from " + teacher.uid)
            // Data for "images/island.jpg" is returned
            let uiImage = UIImage(data: data!) ?? UIImage(systemName: "heart.fill")
            completion(uiImage)
          }
        }
    }

    //TODO: Test this
    func fetchImageAfterUploaded(completion:@escaping(Bool) -> Void ){
        print("FETCHING THE IMAGE from USer: " + uid)
        let storage = Storage.storage()
        let storageRef = storage.reference(withPath: uid)

        storageRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
            if let error = error {
                // Uh-oh, an error occurred while fetching the image!
                print("Error fetching image: \(error)")
                DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
                    self.fetchImageAfterUploaded(completion:completion)
                }
            } else {
                
                print("Successfully fetched image")
                self.uiImage = UIImage(data: data!) ?? UIImage(systemName: "heart.fill")
                completion(true)
            }
        }
        
        
        
    }
    func uploadImage(student: Student, completion:@escaping(Bool) -> Void){
        let storage = Storage.storage()
        let storageRef = storage.reference(withPath: uid)
        let image = self.studentUser.getUIImage()
        guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }
        storageRef.putData(imageData, metadata: nil) { metadata, err in
            if let err = err {
                //if image doesn't work, still upload the profile to firestore
                completion(true)
                print("Failed to push image to Storage:")
                return
            }

            storageRef.downloadURL { url, err in
                if let err = err {
                    print("Failed to retrieve downloadURL")
                    completion(true)
                    return
                }

                print("Successfully stored image with url: \(url?.absoluteString ?? "")")
                print(url?.absoluteString)
                completion(true)
            }
        }
    }
    
    //sign in student with email
    func signinWithEmail(email: String, password: String, completion: @escaping (Bool) -> Void){
        Auth.auth().signIn(withEmail: email, password: password) { result, err in
            if let err = err {
                print("Failed due to error:", err)
                completion(false)
                return
            }

            let user = Auth.auth().currentUser
            self.uid = user?.uid ?? "null"
            self.createStudentFromId(uid: self.uid){ isCreated in
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
    func createStudentFromId(uid: String, completion: @escaping (Bool) -> Void ){
        let db = Firestore.firestore()
        let docRef = db.collection("StudentUser").document(uid)

        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                let loginInfo:KeyValuePairs = [
                    "email": (data!["email"] ?? "Generic User") as! String,
                    "password": (data!["password"] ?? "Generic User") as! String
                ]
                let musicalBackground:KeyValuePairs = [
                    "Instrument": (data!["instrument"] ?? data!["Instrument"] ?? "Generic User") as! String,
                    "Years Playing": (data!["Years Playing"] ?? "Generic User") as! String,
                    "Skill Level": (data!["Skill Level"] ?? "Generic User") as! String,
                    "Prior Pieces Played": (data!["Prior Pieces Played"] ?? "Generic User") as! String,
                    "Budget": (data!["Budget"] ?? "Generic User") as! String
                ]
                let studentInfo:KeyValuePairs = [
                    "name": (data!["name"] ?? "Generic User") as! String,
                    "age": (data!["age"] ?? "Generic User") as! String

                ]
                var name = (data!["name"] ?? "Generic User") as! String
                self.studentUser = Student(name: name)
                self.studentUser.uid = uid
                self.studentUser.populateInfo(personalInfo: studentInfo, loginInfo: loginInfo, musicalBackground: musicalBackground)
                completion(true)
                
            } else {
                print("Document does not exist")
                completion(false)
            }
        }
    }
    //assumes modelData.studentUSer was already created and populated in CreateStudentProfilePage
    func registerStudentUser(completion: @escaping (Bool)->Void){
        print("EMAIL: " + studentUser.email)
        print("Password: " + studentUser.password)

        Auth.auth().createUser(withEmail: studentUser.email, password: studentUser.password){authResult, error in
        if(authResult != nil){
            print("CREATED THE STUDENT")
            self.uid = authResult?.user.uid ?? "null"
            print(self.uid)
            //set uid
            self.studentUser.setUID(uid: self.uid)
            //create the student
            self.createStudentInFirestore(student: self.studentUser){ created in
                if(created){
                    completion(true)
                }
                else{
                    completion(false)
                }
            }
            

        }
        else{
            completion(false)
            print("FAILED TO CREATE USER")
        }

    }
//        modelData.createStudent(student: student)
//        modelData.studentUser = Student(name: firstName + " " + lastName)
//        modelData.studentUser.populateInfo(firstName: firstName, lastName: lastName, age: age, price: price, email: email, selectedInstrument: selectedInstrument)

    
}
    //fetchTeacherData
    //called by StudentAppPage View onAppear
    func fetchTeacherData(completion: @escaping () -> Void){
        print("Fetching Teacher Data ")
        let db = Firestore.firestore()
        let declinedTeachersRef = db.collection("StudentUser").document(uid).collection("Declined Teachers")
        let matchedTeachersRef = db.collection("StudentUser").document(uid).collection("Matched Teachers")
        let requestedTeachersRef = db.collection("StudentUser").document(uid).collection("Requested Teachers")
        
        //populate declined teachers
        declinedTeachersRef.addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching document: \(error!)")
                return
              }
            self.declinedTeachers = documents.compactMap { documentSnapshot in
                let data = documentSnapshot.data()
                let uid = data["uid"] as? String ?? ""
                if !uid.isEmpty{
                    return self.createTeacherFromData(documentSnapshot: documentSnapshot)
                } else {
                    return nil // Return nil if the condition is not met
                }
            }
        }
        //populate Matched teachers
        matchedTeachersRef.addSnapshotListener { querySnapshot, error in
            print("ADDING MATCHED TEACHER")
            guard let documents = querySnapshot?.documents else {
                print("Error fetching document: \(error!)")
                return
              }
            self.matchedTeachers = documents.compactMap { documentSnapshot in
                let data = documentSnapshot.data()
                let uid = data["uid"] as? String ?? ""
                let canAdd = !(self.declinedTeachers).contains { $0.uid == uid }
                if canAdd && !uid.isEmpty{
                    return self.createTeacherFromData(documentSnapshot: documentSnapshot)
                } else {
                    return nil // Return nil if the condition is not met
                }
            }
        }
        
        //populate requested teachers
        requestedTeachersRef.addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching document: \(error!)")
                return
              }
            self.requestedTeachers = documents.compactMap { documentSnapshot in
                let data = documentSnapshot.data()
                let uid = data["uid"] as? String ?? ""
                let canAdd = !(self.declinedTeachers + self.matchedTeachers).contains { $0.uid == uid }
                if canAdd && !uid.isEmpty{
                    return self.createTeacherFromData(documentSnapshot: documentSnapshot)
                } else {
                    return nil // Return nil if the condition is not met
                }
            }
        }
        //populate available teachers with all teachers in "Teachers" that are not in the other arrays
        
        db.collection("Teachers").addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching document: \(error!)")
                return
              }
            
            self.availableTeachers = documents.compactMap { (documentSnapshot) -> Teacher? in
                let data = documentSnapshot.data()
                let uid = data["uid"] as? String ?? ""
                let name = data["name"] as? String ?? ""
                let instrument = data["Instrument"] as? String ?? data["instrument"] as? String ?? ""
                let studentInstrument = self.studentUser.musicalBackground[0].value
                print(studentInstrument)
                print("POPULATING AVAILABLE TEACHERS")
                print("NAME IS: " + name + "EndString")
                let canAdd = !(self.declinedTeachers + self.matchedTeachers + self.requestedTeachers).contains { $0.uid == uid }
                let canMatch = instrument.compare(studentInstrument, options: .caseInsensitive) == .orderedSame
                if canMatch && canAdd && !uid.isEmpty && !name.isEmpty && !(name.trimmingCharacters(in: .whitespaces) == ""){
                    return self.createTeacherFromData(documentSnapshot: documentSnapshot)
                } else {
                    return nil // Return nil if the condition is not met
                }
            }

            completion()
        }
        
    }

    func createTeacherFromData(documentSnapshot: DocumentSnapshot) -> Teacher{
        print("CREATING TEACHER FROM DATA")
        let data = documentSnapshot.data()
        let uid = data!["uid"] as? String ?? ""
        let loginInfo:KeyValuePairs = [
            "email": (data!["email"] ?? "Generic User") as! String,
            "password": (data!["password"] ?? "Generic User") as! String
        ]
        let musicalBackground:KeyValuePairs = [
            "Instrument": (data!["Instrument"] ?? data!["instrument"] ?? "Generic User") as! String,
            "Years Teaching": (data!["Years Teaching"] ?? "Generic User") as! String,
            "Musical Degree": (data!["Musical Degree"] ?? "Generic User") as! String,
            "Teaching Style": (data!["Teaching Style"] ?? "Generic User") as! String,
        ]
        let lessonInfo:KeyValuePairs = [
            "Lesson Length": (data!["Lesson Length"] ?? "Generic User") as! String,
            "Pricing": (data!["Pricing"] ?? "Generic User") as! String,
            "Minimum Student Level": (data!["Minimum Student Level"] ?? "Generic User") as! String,
        ]
        let teacherInfo:KeyValuePairs = [
            "name": (data!["name"] ?? "Generic User") as! String,
            "firstName": (data!["firstName"] ?? "Generic User") as! String,
            "lastName": (data!["lastName"] ?? "Generic User") as! String
        ]
        let name = (data!["name"] ?? "Generic User") as! String
        var teacher = Teacher(name: name)
        teacher.email = (data!["email"] ?? "Generic User") as! String
        teacher.uid = uid
        teacher.populateInfo(teacherInfo: teacherInfo, loginInfo: loginInfo, musicalBackground: musicalBackground, lessonInfo: lessonInfo)
//        fetchTeacherImage(teacher: teacher) { fetchedImage in
//            print(fetchedImage == nil)
//            if let index = self.availableTeachers.firstIndex(where: { $0.id == teacher.id }) {
//                print("FOUND THE IMAGE ")
//                self.availableTeachers[index].name = "FOUND THE FKSJD"
//                self.availableTeachers[index].uiImage = fetchedImage
//            }
//            
//            print("Success for " + teacher.uid)
//        }
        return teacher
    }
    

    //meant to be called when student presses "decline teacher button"
    //TESTED - WORKS
    func declineTeacher(teacherId: String){
        var teacherData: [String: Any]?
        let db = Firestore.firestore()
        let collectionRef = db.collection("Teachers")
        let studentRef = db.collection("StudentUser").document(uid)
        let teacherRef = db.collection("Teachers").document(teacherId)
        //add the student to the teacher's Requested Students collection
        
        //add studentUser data to a new document in teacher's requested students
//        getUserData(docRef: studentRef) { data in
//            teacherRef.collection("Declined Students").document(self.uid).setData(data as [String : Any])
//        }

        //add the teachers data to a new document in the student's list of requested teachers
        print("Teacher ID: " + teacherId)
        getUserData(docRef: teacherRef){ data in
            studentRef.collection("Declined Teachers").document(teacherId).setData(data as [String : Any])
            print("DECLINED TEACHER")
            self.fetchTeacherData{
                
            }
        }


    }
    func requestTeacher(teacherId: String){
        let db = Firestore.firestore()
        let collectionRef = db.collection("Teachers")
        let studentRef = db.collection("StudentUser").document(uid)
        let teacherRef = db.collection("Teachers").document(teacherId)
        //add the student to the teacher's Requested Students collection
        
        //add studentUser data to a new document in teacher's requested students
        getUserData(docRef: studentRef) { data in
            teacherRef.collection("Requested Students").document(self.uid).setData(data as [String : Any])
        }

        //add the teachers data to a new document in the student's list of requested teachers
        print("Teacher ID: " + teacherId)
        getUserData(docRef: teacherRef){ data in
            studentRef.collection("Requested Teachers").document(teacherId).setData(data as [String : Any])
            self.fetchTeacherData{
            }
        }
    }
    func searchForUserInCollection(userName: String, collectionRef: CollectionReference, completion: @escaping (Bool) -> Void){
        collectionRef.whereField("name", isEqualTo: userName).getDocuments { (snapshot, err) in
            if let err = err {
                print("Error getting document: \(err)")
            } else if (snapshot?.isEmpty)! {
                completion(false)
            } else {
                for document in (snapshot?.documents)! {
                    if document.data()["name"] != nil {
                        self.userData = document.data()
                        print("Found teacher, completion is true")
                        completion(true)
                    }
                }
            }
        }
    }
    func searchForTeacher(teacherName: String, completion: @escaping (Bool) -> Void) {
        // Get your Firebase collection
        let db = Firestore.firestore()
        let collectionRef = db.collection("Teachers")

        // Get all the documents where the field username is equal to the String you pass, loop over all the documents.

        collectionRef.whereField("name", isEqualTo: teacherName).getDocuments { (snapshot, err) in
            if let err = err {
                print("Error getting document: \(err)")
            } else if (snapshot?.isEmpty)! {
                completion(false)
            } else {
                for document in (snapshot?.documents)! {
                    if document.data()["name"] != nil {
                        self.userData = document.data()
                        print("Found teacher, completion is true")
                        completion(true)
                    }
                }
            }
        }
    }
    //should be unused, searches for student with the matching name 
//    func searchForStudent(studentName: String, completion: @escaping (Bool) -> Void) {
//        // Get your Firebase collection
//        let db = Firestore.firestore()
//        let collectionRef = db.collection("StudentUser")
//
//        // Get all the documents where the field username is equal to the String you pass, loop over all the documents.
//
//        collectionRef.whereField("name", isEqualTo: studentName).getDocuments { (snapshot, err) in
//            if let err = err {
//                print("Error getting document: \(err)")
//            } else if (snapshot?.isEmpty)! {
//                completion(false)
//            } else {
//                for document in (snapshot?.documents)! {
//                    if document.data()["name"] != nil {
//                        self.userData = document.data()
//                        self.createStudentFromData()
//                        print(self.userData!["name"] ?? "Generic User")
//                        completion(true)
//                    }
//                }
//            }
//        }
//    }
    //unused, searches for student that has the matching email
//    func searchForStudentWithEmail(email: String, completion: @escaping (Bool) -> Void) {
//        // Get your Firebase collection
//        let db = Firestore.firestore()
//        let collectionRef = db.collection("StudentUser")
//
//        // Get all the documents where the field username is equal to the String you pass, loop over all the documents.
//
//        collectionRef.whereField("email", isEqualTo: email).getDocuments { (snapshot, err) in
//            if let err = err {
//                print("Error getting document: \(err)")
//            } else if (snapshot?.isEmpty)! {
//                completion(false)
//            } else {
//                for document in (snapshot?.documents)! {
//                    if document.data()["email"] != nil {
//                        self.userData = document.data()
//                        self.createStudentFromData()
//                        print(self.userData!["name"] ?? "Generic User")
//                        completion(true)
//                    }
//                }
//            }
//        }
//    }

    //creates the Student object for the current Student user after the user logs in
//    func createStudentFromData(){
//        let data = userData
//        let name = data!["name"] ?? "Generic User"
//        let firstName = data!["firstName"] ?? "Generic User"
//        let lastName = data!["lastName"] ?? "Generic User"
//        let instrument = data!["instrument"] ?? "Generic User"
//        let email = data!["email"] ?? "Generic User"
//        let lessonType = data!["lessonType"] ?? "Generic User"
//        let lessonLength = data!["lessonLength"] ?? "Generic User"
//        let priceRange = data!["priceRange"] ?? "Generic User"
//        let aboutDescription = data!["aboutDescription"] ?? "Generic User"
//        let imageName = "blankPerson"
//        studentUser = Student(name: name as! String , firstName: firstName as! String, lastName: lastName as! String, age: 12, price: 23 , email: email as! String, selectedInstrument: instrument as! String)
//    }
}

