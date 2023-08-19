//
//  ModelData.swift
//  MusicAppSeniorProject
//
//  Created by Samuel Wang on 2/23/23.
//TODO: Available Teacher algorithm -> populates all of the teachers that could be compatible with the student, irrespective of distance and level, only considering the instrument
//TODO: method to determine compatibility of teacher - > level, years of experience, location
//TODO: method to determine proximity between teacher and student
//TODO: method to take top 5 best teachers for the student
//TODO: button at bottom of screen for adding 5 more teachers
//TODO: Save teachers into "available teachers
//todo: dfdf
//TODO: 8/6 work out available teachers logic
import Foundation
import Firebase
import FirebaseAppCheck
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore
import SwiftUI
import CoreLocation
final class ModelData: ObservableObject{
    @Published var students =  [Student]()
    @Published var teachers = [Teacher]()
    
    //for student users
    private var allAvailableTeachers = [Teacher]() //dont use for now
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


    @Published var email: String?
    @Published var password: String? 
    
    @Published var loggedIn: Bool?
    @Published var isStudent: Bool?
    @Published var hasFetchedData: Bool?
    @Published var hasPopulated: Bool = false
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
    //returns a score which measures how compatible a teacher is
    //does not consider distance range the student sets in StudentAppPage -> that filters out the available teachers shown
    //negative score means completely incompatible
    //
    func determineCompatibility(teacher: Teacher, student: Student, completion:@escaping (Double?) -> Void){
        var score = 100.0
        let teacherPreferredLevel = teacher.getDoubleProperty(key: "Minimum Student Level", pairs: teacher.musicalBackground)
        let studentLevel = student.getDoubleProperty(key: "Student Level", pairs: student.musicalBackground)
        //add more to score if student and teacher Level are the same with studentLevel >= teacherLevel
        //TODO: Come up with a better one in the future
        score += 50 + (-0.5 * (teacherPreferredLevel - studentLevel))
        
        if(teacher.instrument != student.selectedInstrument){
            completion(-1000)
        }
        teacherDistance(teacher:teacher, student: student){dist  in
            if(dist != nil){
                score -= dist ?? 0
                completion(score)
            }
            else{
                completion(score)
            }
        }
    }

    func teacherDistance (teacher: Teacher, student: Student, completion: @escaping (Double?) -> Void) {
        let geocoder = CLGeocoder()
        let city1  = "Lynnwood, WA"
        let city2 = "Bellevue, Delaware"
        geocoder.geocodeAddressString(city1) { (placemarks1, error) in
            if(error != nil){
                print("CITY DOES NOT EXIST")
            }
            guard let location1 = placemarks1?.first?.location else {
                completion(nil)
                return
            }
            
            geocoder.geocodeAddressString(city2) { (placemarks2, error) in
                guard let location2 = placemarks2?.first?.location else {
                    completion(nil)
                    return
                }
                
                let distance = location1.distance(from: location2) / 1000.0 // Convert meters to kilometers
                print("DISTANCE " + String(distance))
                completion(distance)
            }
        }
    }
    func checkIfCollectionExists(collectionName: String, completion: @escaping (Bool) -> Void) {
        let db = Firestore.firestore()
        let collectionRef = db.collection("StudentUser").document(uid).collection(collectionName)
        print(collectionRef.path)
        collectionRef.getDocuments { (snapshot, error) in
            guard let snapshot = snapshot else {
                print("Error fetching collection: \(error?.localizedDescription ?? "Unknown error")")
                completion(false)
                return
            }
            
            completion(!snapshot.isEmpty)
        }
    }
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
        checkIfCollectionExists(collectionName: "All Available Teachers") { works in
            if(!works){
                docRef.collection("Matched Teachers").document().setData([  // 👈 Create a document in the subcollection
                    "title": "testing"
                ])
            }
            else{
                print("FOUND MATCHED, not ADDING")
            }
        }
        checkIfCollectionExists(collectionName: "Available Teachers") { works in
            if(!works){
                docRef.collection("Matched Teachers").document().setData([  // 👈 Create a document in the subcollection
                    "title": "testing"
                ])
            }
            else{
                print("FOUND MATCHED, not ADDING")
            }
        }
        checkIfCollectionExists(collectionName: "Matched Teachers") { works in
            if(!works){
                docRef.collection("Matched Teachers").document().setData([  // 👈 Create a document in the subcollection
                    "title": "testing"
                ])
            }
            else{
                print("FOUND MATCHED, not ADDING")
            }
        }
        checkIfCollectionExists(collectionName: "Declined Teachers") { exists in
            if(!exists){
                docRef.collection("Declined Teachers").document().setData([  // 👈 Create a document in the subcollection
                    "title": "testing"
                ])
            }
            else{
                print("DID NOT FIND COLLECTIOn")
            }
        }
        checkIfCollectionExists(collectionName: "Requested Teachers") { works in
            if(!works){
                docRef.collection("Requested Teachers").document().setData([  // 👈 Create a document in the subcollection
                    "title": "testing"
                ])
            }
            else{
                print("DID NOT FIND COLLECTIOn")
            }
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
        var credential: AuthCredential

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
              print("ERROR FETCHING IMAGE")
            completion(false)
          } else {
              print("Successfully fetched image")
            // Data for "images/island.jpg" is returned
              self.uiImage = UIImage(data: data!)
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
            let uiImage = UIImage(data: data!) ?? UIImage(systemName: "person.fill")
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
                self.uiImage = UIImage(data: data!)
                completion(true)
            }
        }
        
        
        
    }
    func uploadImage(student: Student, completion:@escaping(Bool) -> Void){
        print("UPLOADING THE IMAGE")
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
                    print("IS CREATED")
                    completion(true)
                    self.fetchTeacherData(){
                        print("DONE FETCHING")
                    }

                }
                else{
                    completion(false)
                }
            }
            
          // ...
        }

    }
    func logOut(){
        try! Auth.auth().signOut()
    }
    
    func userIsStudent(completion:@escaping (Bool) -> Void){
        let db = Firestore.firestore()
        let docRef = db.collection("StudentUser").document(uid)
        docRef.getDocument { (document, error) in
            if let document = document {
                if document.exists{
                    completion(true)
                } else {
                    completion(false)
                }
            }
            else{
                completion(false)
            }
        }
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
                    "lastName": (data!["lastName"] ?? "Generic User") as! String,
                    "firstName": (data!["firstName"] ?? "Generic User") as! String,
                    "age": (data!["age"] ?? "Generic User") as! String,
                    "Location": (data!["Location"] ?? "Generic User") as! String

                ]
                
                var name = (data!["name"] ?? "Generic User") as! String
                self.studentUser = Student(name: name)
                self.studentUser.uid = uid
                self.uid = uid
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
        Auth.auth().createUser(withEmail: studentUser.email, password: studentUser.password){authResult, error in
            if(authResult != nil){
                self.uid = authResult?.user.uid ?? "null"
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
            }
            
        }
    }
    //assumes user is logged in already
        func updateStudentData(completion: @escaping (Bool)->Void){
            
            self.createStudentInFirestore(student: self.studentUser){ created in
                if(created){
                    completion(true)
                }
                else{
                    completion(false)
                }
            }
        }
//        modelData.createStudent(student: student)
//        modelData.studentUser = Student(name: firstName + " " + lastName)
//        modelData.studentUser.populateInfo(firstName: firstName, lastName: lastName, age: age, price: price, email: email, selectedInstrument: selectedInstrument)

    //populates all the teachers with the same instrument as the user
    //unavailableTeacherIDs - requested, declined, matched teachers
    func addTeacherToAllAvailableTeachers(teacher: Teacher, teacherUID: String, unavailableTeachers: [Teacher]){
        let db = Firestore.firestore()
        let allAvailableTeachersRef = db.collection("StudentUser").document(uid).collection("All Available Teachers")
        allAvailableTeachersRef.document(teacherUID).setData([
            "name": teacher.name,
            "Score": teacher.score,
            "height": 300

        ]) { err in
            if let err = err {
                print("@@@Error writing document: \(err)")
            } else {
                print("@@@Document successfully written to AllAvailableTeachers at "  + allAvailableTeachersRef.document(teacherUID).path)
            }
        }
        allAvailableTeachers.append(teacher)
        
        
    }
    func populateAllAvailableTeachers(student: Student){
        //
        let db = Firestore.firestore()
        let allAvailableTeachersRef = db.collection("StudentUser").document(uid).collection("All Available Teachers")
        //populate all available teachers with teachers with the same instrument
        let teacherRef = db.collection("Teachers")//.document("Teacher Instruments").collection("Cello") //TODO: FIX LOGIC
        let query = teacherRef
            .whereField("Instrument", isEqualTo: "Cello")
            .whereField("name", isGreaterThan: "A")
        query.addSnapshotListener { querySnapshot, error in
            var unavailableTeachers = [Teacher]()
            unavailableTeachers.append(contentsOf: (self.availableTeachers + self.declinedTeachers + self.matchedTeachers + self.requestedTeachers))
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching document: \(error!)")
                    return
                  }
            
            documents.forEach { documentSnapshot in
                let teacherId = documentSnapshot.documentID
                let teacherRef = db.collection("Teachers").document(teacherId)
                    teacherRef.getDocument { (snapshot, err) in
                        print("UNAVAILALBE TEACHERS COUNT:" + String(unavailableTeachers.count))
                        let canAdd = !(unavailableTeachers).contains { $0.uid == teacherId }
                        if let err = err {
                            print("Error getting document: \(err)")
                        }
                        else if let snapshot = snapshot, canAdd, snapshot.exists {
                            let data = snapshot.data()
                            if let data = data{
                                //create the teacher object
                                var teacher = self.createTeacherFromData(documentSnapshot: snapshot)
                                self.determineCompatibility(teacher: teacher, student: self.studentUser){ score in
                                    teacher.score = score ?? 0
                                    self.addTeacherToAllAvailableTeachers(teacher: teacher, teacherUID: teacherId, unavailableTeachers: unavailableTeachers)
                                    //put the score in student's all available teachers
                                    
                                }
                            }
                        }
                    }
            }

        }
    }
    //fetchTeacherData
    //called by StudentAppPage View onAppear
    func createTeacherFromUID(uid: String){
        
    }
    func fetchTeacherData(completion: @escaping () -> Void){
        print("*FETCHING TEACHER DATA")
        let dispatchGroup = DispatchGroup()

        let db = Firestore.firestore()
        let declinedTeachersRef = db.collection("StudentUser").document(uid).collection("Declined Teachers")
        let matchedTeachersRef = db.collection("StudentUser").document(uid).collection("Matched Teachers")
        let requestedTeachersRef = db.collection("StudentUser").document(uid).collection("Requested Teachers")
        let allAvailableTeachersRef = db.collection("StudentUser").document(uid).collection("All Available Teachers")

        let teacherRef = db.collection("Teachers")
        
        var unavailableTeacherIDs = [""]

        //populate declined teachers from firestore
        var declinedListener = declinedTeachersRef.addSnapshotListener { querySnapshot, error in
            self.declinedTeachers = []

            guard let documents = querySnapshot?.documents else {
                print("Error fetching document: \(error!)")
                return
            }
            

            documents.forEach { documentSnapshot in
                print("ADDING DECLINED TEACHER")
                let teacherId = documentSnapshot.documentID
                var declinedTeacher = Teacher(name: "GENERIC")
                declinedTeacher.setUID(uid: teacherId)
                self.declinedTeachers.append(declinedTeacher)
                unavailableTeacherIDs.append(teacherId)
                //if somehow availableTeachers contains this teacher already decline it
                if(self.availableTeachers.contains { $0.uid == teacherId }){
                    self.declineTeacher(teacherId: teacherId)
                }

            }
        }
        //populate matched teachers from firestore
        var matchedListener = matchedTeachersRef.addSnapshotListener { querySnapshot, error in
            print("Matched Teachers Changing")
            self.matchedTeachers = []
            guard let documents = querySnapshot?.documents else {
                print("Error fetching document: \(error!)")
                return
            }

            documents.forEach { documentSnapshot in
                let teacherId = documentSnapshot.documentID
                unavailableTeacherIDs.append(teacherId)
                let teacherRef = db.collection("Teachers").document(teacherId)
                teacherRef.getDocument { (snapshot, err) in
                    let canAdd = !(self.matchedTeachers).contains { $0.uid == teacherId }
                    if let err = err {
                        print("Error getting document: \(err)")
                    } else if let snapshot = snapshot, canAdd, snapshot.exists {
                        let data = snapshot.data()
                        if let data = data {
                            print("ADDING MATCHED TEACHER")

                            let matchedTeacher = self.createTeacherFromData(documentSnapshot: snapshot)
                            self.matchedTeachers.append(matchedTeacher)
                        }
                    }
                }
            }
        }
        //REDO THIS ORDERING LOGIC
        //THIS BREAKS IT the order and the limit 
        let query = allAvailableTeachersRef
            .order(by: "Score", descending: true)
            .limit(to: 20)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
            var allAvailableTeachersListener = query.addSnapshotListener { snapshot, error in
                print("ALL AVAILABLE TEACHERS LISTENER IS CHANGING")
            }
        }


        var requestedListener = requestedTeachersRef.addSnapshotListener { querySnapshot, error in
            self.requestedTeachers = []
            print("Requested Teachers Changing")
            guard let documents = querySnapshot?.documents else {
                print("Error fetching document: \(error!)")
//                group.leave()
                return
            }
            documents.forEach { documentSnapshot in
//                defer { dispatchGroup.leave() }
                let teacherId = documentSnapshot.documentID
                unavailableTeacherIDs.append(teacherId)
                let teacherRef = teacherRef.document(teacherId)
                teacherRef.getDocument { (document, err) in
                    if let err = err {
                        print("Error getting document: \(err)")
                    } else if let document = document, document.exists {
                        let canAdd = !(self.requestedTeachers + self.declinedTeachers + self.matchedTeachers).contains { $0.uid == teacherId }
                        if canAdd {
                            let data = document.data()
                            if let data = data {
                                print("ADDING REQUESTED TEACHER: " + teacherId)

                                let requestedTeacher = self.createTeacherFromData(documentSnapshot: document)
                                self.requestedTeachers.append(requestedTeacher)
                            }
                        }
                    }

                }
            }
        }
        //CODE IS USELESS JUST A PLACEHOLDER
        let unavailableTeachers = self.requestedTeachers + self.declinedTeachers + self.matchedTeachers
        print("dECLINED TEACHERS SIZE: " + String(declinedTeachers.count))
            // Perform the population process here
            // This can involve fetching data, processing, and writing to Firestore
            print("@@@POPULATING ALL AVAILABLE TEACHERS@@@")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
            self.populateAllAvailableTeachers(student: self.studentUser)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                // Put your code which should be executed with a delay here
                print("@@@POPULATING AVAILABLE TEACHERS")
                let query = allAvailableTeachersRef
                    .order(by: "Score", descending: true)
                    .limit(to: 20)

                let availableListener = query.addSnapshotListener { querySnapshot, error in
                    print("ALREADY 5 AVAILALBE TEACHERS")
                    if(!(self.availableTeachers.count >= 5)){
                        self.availableTeachers = []
                        print("Available Teachers Changing")
                        guard let documents = querySnapshot?.documents else {
                            print("Error fetching document: \(error!)")
            //                group.leave()
                            return
                        }

                
                    //TODOL: TEST IF THIS STOPS IT OVERFLOWING


                    documents.forEach { documentSnapshot in
        //                defer { dispatchGroup.leave() }
                        let teacherId = documentSnapshot.documentID
                        unavailableTeacherIDs.append(teacherId)
                        let teacherRef = teacherRef.document(teacherId)
                        teacherRef.getDocument { (document, err) in
                            if let err = err {
                                print("Error getting document: \(err)")
                            } else if let document = document, document.exists {
                                let canAdd = !(self.requestedTeachers + self.availableTeachers + self.declinedTeachers + self.matchedTeachers).contains { $0.uid == teacherId }
                                if canAdd {
                                    let data = document.data()
                                    if let data = data {
                                        print("ADDING AVAILABLE TEACHER: " + teacherId)
                                        if(self.availableTeachers.count < 5){
                                            let availableTeacher = self.createTeacherFromData(documentSnapshot: document)
                                            print("ADDING AVAILABLE TEACHER WITH NAME: " + availableTeacher.name)
                                            self.availableTeachers.append(availableTeacher)
                                        }
                                        
                                    }
                                }
                                else{
                                    print("CANT ADD UID IS: " + teacherId)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
//    func populateAllAndAvailableTeachers(){
//        let db = Firestore.firestore()
//        let allAvailableTeachersRef = db.collection("Student User").document(uid).collection("All Available Teachers")
//
//        print("Declined TEACHERS SIZE: " + String(declinedTeachers.count))
//        let unavailableTeachers = [Teacher]()
//        //populate all available teachers
//        populateAllAvailableTeachers(student: self.studentUser, unavailableTeachers: unavailableTeachers)
//        allAvailableTeachersRef.addSnapshotListener { querySnapshot, error in
//            if(self.availableTeachers.isEmpty){
//                print("ADDING AVAILABLE TEACHERS")
////                self.populateAvailableTeachers()
//            }
//        }
//    }
    func teacherIsCompatible(){
        
    }
    func deleteDocument(document: DocumentReference){
        print("DELETING DOCUMENT")
        document.delete() { err in
             if let err = err {
                 print("Error removing document: \(err)")
             } else {
                 print("Document successfully removed!")
             }
         }
    }
    func createTeacherFromData(documentSnapshot: DocumentSnapshot) -> Teacher{
        let data = documentSnapshot.data()
        let uid = documentSnapshot.documentID
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
//        print("Teaching Style for : " + uid)
//        print((data!["Teaching Style"] ?? "Generic User") as! String)
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
        fetchTeacherImage(teacher: teacher) { fetchedImage in
//            print("FETCHING TEACHER IMAGE")
            print(fetchedImage == nil)
            if let index = self.availableTeachers.firstIndex(where: { $0.id == teacher.id }) {
                if index < self.availableTeachers.count {
                    self.availableTeachers[index].uiImage = fetchedImage
                } else {
                    print("Index out of range")
                }
            }
            else if let index = self.requestedTeachers.firstIndex(where: { $0.id == teacher.id }) {
                if index < self.requestedTeachers.count {
                    self.requestedTeachers[index].uiImage = fetchedImage
                } else {
                    print("Index out of range")
                }
            }
            else if let index = self.matchedTeachers.firstIndex(where: { $0.id == teacher.id }) {
                if index < self.matchedTeachers.count {
                    self.matchedTeachers[index].uiImage = fetchedImage
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
        return teacher
    }
    

    //meant to be called when student presses "decline teacher button"
    //TODO: FIX THIS
    func declineTeacher(teacherId: String){
        var teacherData: [String: Any]?
        let db = Firestore.firestore()
        let collectionRef = db.collection("Teachers")
        let studentRef = db.collection("StudentUser").document(uid)
        let teacherRef = db.collection("Teachers").document(teacherId)
        //New method: Add teacher id to declinedTeacherRef
        studentRef.collection("Declined Teachers").document(teacherId).setData([  // 👈 Create a document in the subcollection
            "title": "Declined Teacher"
        ])
        studentRef.collection("All Available Teachers").document(teacherId).delete() { err in
             if let err = err {
                 print("Error removing document: \(err)")
             } else {
                 print("Document successfully removed!")
             }
         }
        //OLD METHOD: adding the students data to declined teacher
//        getUserData(docRef: teacherRef){ data in
//            studentRef.collection("Declined Teachers").document(teacherId).setData(data as [String : Any])
//            print("DECLINED TEACHER")
//            self.fetchTeacherData{
//
//            }
//        }


    }
    //removes the teacher from the list of requested teachers, but teacher is available in available teachers
    func cancelTeacherRequest(teacherId: String){
        let db = Firestore.firestore()
        let collectionRef = db.collection("Teachers")
        let studentRef = db.collection("StudentUser").document(uid)
        let teacherRef = db.collection("Teachers").document(teacherId)
        let requestedStudentsRef = db.collection("Teachers").document(teacherId).collection("Requested Students")
        let requestedTeachersRef = db.collection("StudentUser").document(uid).collection("Requested Teachers")
        //remove student from teachers list of requested teachers
        requestedStudentsRef.document(uid).delete() { err in
             if let err = err {
                 print("Error removing document: \(err)")
             } else {
                 print("Document successfully removed!")
             }
         }
         requestedTeachersRef.document(teacherId).delete() { err in
              if let err = err {
                  print("Error removing document: \(err)")
              } else {
                  print("Document successfully removed!")
              }
          }
        studentRef.collection("All Available Teachers").document(teacherId).setData([
            "title": "Available Teacher"
        ])
        
        
    }
    func requestTeacher(teacherId: String){
        print("REQUESTING TEACHER")
        let db = Firestore.firestore()
        let collectionRef = db.collection("Teachers")
        let studentRef = db.collection("StudentUser").document(uid)
        let teacherRef = db.collection("Teachers").document(teacherId)
        //add the student to the teacher's Requested Students collection
        
        //New Method - add teacher id to requested studentRef, student id to requested Teacher Ref
        teacherRef.collection("Requested Students").document(uid).setData([
            "title": "Requested Student"
        ])
        studentRef.collection("Requested Teachers").document(teacherId).setData([
            "title": "Requested Teacher"
        ])
        studentRef.collection("All Available Teachers").document(teacherId).delete() { err in
             if let err = err {
                 print("Error removing document: \(err)")
             } else {
                 print("Document successfully removed!")
             }
         }
        availableTeachers.removeAll { teacher in
            return teacher.uid == teacherId
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

