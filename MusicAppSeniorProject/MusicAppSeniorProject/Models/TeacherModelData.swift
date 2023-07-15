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
final class TeacherModelData: ObservableObject{
    @Published var teachers = [Teacher]()
    
    @Published var declinedStudents = [Student]()
    @Published var requestedStudents = [Student]()
    @Published var matchedStudents = [Student]()
    
    @Published var teacherUser = Teacher(name: "Generic User")
    
    @Published var userData: [String: Any]?
    @Published var uid: String = ""
    
    @Published var email: String?

    @Published var profileImage: ProfileModel?
    @Published var uiImage: UIImage?
    
    func logOut(){
        try! Auth.auth().signOut()
    }
    func updateTeacherData(completion: @escaping (Bool)->Void){
        
        self.createTeacherInFireStore(teacher:self.teacherUser){ created in
            if(created){
                completion(true)
            }
            else{
                completion(false)
            }
        }
    }
    func checkEmailValidity(email: String, completion: @escaping (Bool) -> Void) {
        print("CHECKING EMAIL AVAILABILITY")
        Auth.auth().fetchSignInMethods(forEmail: email) { (signInMethods, error) in
            if let error = error {
                print("SOMETHING WRONG WITH EMAIL")
                completion(false)
            }
            else {
                print("OTEHR")
                if let signInMethods = signInMethods {
                    if signInMethods.isEmpty {
                        print("EMAIL WORKS ")
                        completion(true)
                    } else {
                        print("Email is registered.")
                        print("Sign-in methods: \(signInMethods)")
                        completion(false)

                    }
                }
                else{
                    print("SIGNIN METHODS NIL: " + String(signInMethods == nil))
                    completion(true)
                }
            }
        }
    }
    
    public func createTeacherInFireStore(teacher: Teacher, completion: @escaping(Bool) -> Void) {
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
                completion(true)

            } else {
                print("Document does not exist")
            }
        }
        //Add a section for the teacher that carries all their students
//        docRef.collection("Requested Students").document().setData([  // 👈 Create a document in the subcollection
//            "title": "testing"
//                                                                   ])
//        docRef.collection("Matched Students").document().setData([  // 👈 Create a document in the subcollection
//            "title": "testing"
//                                                                  ])
//        docRef.collection("Declined Students").document().setData([  // 👈 Create a document in the subcollection
//            "title": "testing"
//                                                                  ])

    }
    
    //use this after logging in (NOT SIGNUP) to create the teacher object
    //basically fetches teacherData from the database
    func createTeacherFromId(uid: String, completion: @escaping (Bool) -> Void ){
        print("CREATING TEACHER FROM ID")
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
                    "Pricing": (data!["Pricing"] ?? "Generic User") as! String,
                    "Minimum Student Level": (data!["Minimum Student Level"] ?? "Generic User") as! String,
                ]
                let teacherInfo:KeyValuePairs = [
                    "name": (data!["name"] ?? "Generic User") as! String,
                    "firstName": (data!["firstName"] ?? "Generic User") as! String,
                    "lastName": (data!["lastName"] ?? "Generic User") as! String
                ]
                var name = (data!["name"] ?? "Generic User") as! String
                self.userData = data
                self.teacherUser = Teacher(name: name)
                self.teacherUser.uid = uid
                self.teacherUser.email = self.email ?? "No email found"
                self.teacherUser.populateInfo(teacherInfo: teacherInfo, loginInfo: loginInfo, musicalBackground: musicalBackground, lessonInfo: lessonInfo)
                completion(true)
                
            } else {
                print("Document does not exist")
                completion(false)
            }
        }
    }
    func fetchStudentImage(student: Student, completion:@escaping(UIImage?) -> Void){
        print("Fetching Student Image" + uid)
        let storage = Storage.storage()
        let storageRef = storage.reference(withPath: student.uid)
        storageRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
          if let error = error {
            // Uh-oh, an error occurred!
            completion(nil)
          } else {
              print("Successfully fetched teacher image from " + student.uid)
            // Data for "images/island.jpg" is returned
            let uiImage = UIImage(data: data!) ?? UIImage(systemName: "person.fill")
            completion(uiImage)
          }
        }
    }
    func createStudentFromData(documentSnapshot: DocumentSnapshot) -> Student{
        print("CREATING THE STUDENT")
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
            "name": (data!["name"] ?? "Generic User") as! String,
            "age": String(format: "%@", (data!["age"] ?? "0") as! CVarArg)

        ]
        var name = (data!["name"] ?? "Generic User") as! String
        var student = Student(name: name)
        student.uid = data!["uid"] as? String ?? ""
        student.populateInfo(personalInfo: studentInfo, loginInfo: loginInfo, musicalBackground: musicalBackground)
        fetchStudentImage(student: student) { fetchedImage in
            print("FETCHING TEACHER IMAGE")
            print(fetchedImage == nil)
            if let index = self.requestedStudents.firstIndex(where: { $0.id == student.id }) {
                print("FOUND THE IMAGE with id: ")
                print(student.id)
                self.requestedStudents[index].uiImage = fetchedImage
            }
            else if let index = self.matchedStudents.firstIndex(where: { $0.id == student.id }) {
                if index < self.matchedStudents.count {
                    self.matchedStudents[index].uiImage = fetchedImage
                } else {
                    print("Index out of range")
                }
            }
//            else if let index = self.declinedTeachers.firstIndex(where: { $0.id == teacher.id }) {
//                if index < self.declinedTeachers.count {
//                    self.requestedTeachers[index].uiImage = fetchedImage
//                } else {
//                    print("Index out of range")
//                }
//            }
            
        }
        return student 
    }
    //TODO: FIX THIS TO USE ID FETCHING SYSTEM FROM STUDENT USERS
    func fetchImage(completion:@escaping(Bool) -> Void ){
        let storage = Storage.storage()
        let storageRef = storage.reference(withPath: uid)
        storageRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
          if let error = error {
            // Uh-oh, an error occurred!
            completion(false)
          } else {
            // Data for "images/island.jpg" is returned
              self.uiImage = UIImage(data: data!) ?? UIImage(systemName: "heart.fill")
            completion(true)
          }
        }
    }
    //TODO: Test this
    func fetchImageAfterUploaded(completion:@escaping(Bool) -> Void ){
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
                self.uiImage = UIImage(data: data!) ?? UIImage(systemName: "heart.fill")
                completion(true)
            }
        }
        
        
        
    }
    func uploadImage(teacher: Teacher, completion:@escaping(Bool) -> Void){
        let storage = Storage.storage()
        let storageRef = storage.reference(withPath: uid)
        let image = self.teacherUser.getUIImage()
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
                print(url?.absoluteString)
                completion(true)
            }
        }
    }
    
    func fetchStudentData(completion: @escaping() -> Void) {
        print("Fetching Student Data For: " + uid)
        let db = Firestore.firestore()
        let declinedStudentsRef = db.collection("Teachers").document(uid).collection("Declined Students")
        let matchedStudentsRef = db.collection("Teachers").document(uid).collection("Matched Students")
        let requestedStudentsRef = db.collection("Teachers").document(uid).collection("Requested Students")
        //populate declined students
        let studentRef = db.collection("Teachers")
        var unavailableStudentIds = [""]
        //populate declined teachers
        declinedStudentsRef.addSnapshotListener { querySnapshot, error in
            self.declinedStudents = []

            guard let documents = querySnapshot?.documents else {
                print("Error fetching document: \(error!)")
                return
              }
            documents.forEach { documentSnapshot in
                let studentId = documentSnapshot.documentID
                var declinedStudent = Student(name:"DECLINED STUDENT")
                declinedStudent.setUID(uid: studentId)
                self.declinedStudents.append(declinedStudent)
                unavailableStudentIds.append(studentId)
            }
        }
        //populate Matched teachers
        matchedStudentsRef.addSnapshotListener { querySnapshot, error in
            print("Matched Students Changing")
            self.matchedStudents = []
            guard let documents = querySnapshot?.documents else {
                print("Error fetching document: \(error!)")
                return
              }
            documents.forEach { documentSnapshot in
                let studentId = documentSnapshot.documentID
                unavailableStudentIds.append(studentId)
                let studentRef = db.collection("StudentUser").document(studentId)
                    studentRef.getDocument { (snapshot, err) in
                        let canAdd = !self.matchedStudents.contains { $0.uid == studentId }
                        if let err = err {
                            print("Error getting document: \(err)")
                        }
                        else if let snapshot = snapshot, canAdd, snapshot.exists {
                            let data = snapshot.data()
                            if let data = data{
                                let matchedStudent = self.createStudentFromData(documentSnapshot: snapshot)
                                self.matchedStudents.append(matchedStudent)
                            }
                        }
                    }
            }
        }
        
        requestedStudentsRef.addSnapshotListener { querySnapshot, error in
            print("Requested Students Changing")
            self.requestedStudents = []
            guard let documents = querySnapshot?.documents else {
                print("Error fetching document: \(error!)")
                return
              }
            documents.forEach { documentSnapshot in
                let studentId = documentSnapshot.documentID
                unavailableStudentIds.append(studentId)
                let studentRef = db.collection("StudentUser").document(studentId)
                    studentRef.getDocument { (snapshot, err) in
                        let canAdd = !self.requestedStudents.contains { $0.uid == studentId }
                        if let err = err {
                            print("Error getting document: \(err)")
                        }
                        else if let snapshot = snapshot, canAdd, snapshot.exists {
                            let data = snapshot.data()
                            if let data = data{
                                let requestedStudent = self.createStudentFromData(documentSnapshot: snapshot)
                                self.requestedStudents.append(requestedStudent)
                            }
                        }
                    }
            }
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

        declinedStudentsRef.document(studentUID).setData([
            "title": "Declined Student"
        ])
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
        matchedTeachersRef.document(uid).setData([
            "title": "Matched Teacher"
        ])
        matchedStudentsRef.document(studentUID).setData([
            "title": "Matched Student"
        ])
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
                self.createTeacherInFireStore(teacher: teacher){ _ in
                    
                }
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
