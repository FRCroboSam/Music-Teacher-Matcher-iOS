//
//  ProfilePage.swift
//  MusicAppSeniorProject
//
//  Created by Samuel Wang on 1/27/23.
//

import SwiftUI
import Firebase
import Combine
import FirebaseAuth
enum Instrument: String, CaseIterable, Identifiable {
    case cello, piano, violin
    var id: Self { self }
}


struct CreateStudentProfilePage: View{
    @EnvironmentObject var modelData: ModelData
    @EnvironmentObject var viewModel: ProfileModel
    @State private var name: String = ""
    @State private var loginSuccessful = false
    @State private var noUserFound = true
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var age : Double = 0
    @State private var yearsPlaying: Double = 0
    @State private var price: Double = 0
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var selectedInstrument: String = "Cello"
    @State private var studentLevel: String = ""
    @State private var description: String = ""
    @State private var image = UIImage(systemName: "heart.fill")
    @State var displayImage: Bool = false
    @State private var useCamera = false
    @State private var toggle: Bool = false
    @State private var changePassword: Bool = false
    @State private var changeEmail: Bool = false


    var editMode = false
    @State var newEmail = ""
    @State var newPassword = ""
    @State var hasPopulated = false
    var student: Student?
    
    @State var invalidEmail = false
    @State var invalidNewPassword = false
    @State var invalidPassword = false
    //    @State var tag:Int? = nil
    
    //    @State private var sldkfj: String = ""
    
    //for checking which fields were updated
    @State private var profileImageCount = 0
    
    var body: some View {
//        NavigationStack{
            Form{
                Section{
                    if(editMode){
                        Text("Edit Your Profile")
                            .font(.system(size: 35))
                            .fontWeight(.bold)
                            .padding(10)
                    }
                    else{
                        Text("Your Student Profile")
                            .font(.system(size: 40))
                            .fontWeight(.bold)
                            .padding(10)
                    }

                    VStack{
                        EditableCircularProfileImage()
                            .onReceive(viewModel.$imageSelection){ (value) in
                                print("PROFILE IMAGE CHANGING")
                                profileImageCount += 1
                            }
                        Text("Select a Profile Picture")
                            .font(.system(size: 20))
                            .fontWeight(.bold)
                            .padding(10)
//                        NavigationLink(destination:CameraView()){
//                            Text("Use camera to take a photo")
//                        }.buttonStyle(BorderlessButtonStyle())
                        Button("Use Camera to take a photo") {
                            useCamera = true
                        }.listRowSeparator(.hidden)
                        .buttonStyle(.bordered)
                        .padding(10)
                        .navigationDestination(isPresented: $useCamera) {
                            CameraView()
                        }
                    }
                    .onAppear{
                        print("APPEARING")
                        if(editMode && !hasPopulated){
                            if(student != nil){
                                populateProfileEditor(student: student ?? Student(name: "DKFJDJ"))
                                hasPopulated = true
                            }
                            if(modelData.uiImage == nil){
                                Task {
                                    await populateImage()
                                }
                            }

                        }
                    }

                    //                    if(displayImage){
                    //                        Image(uiImage:viewModel.getImage())
                    //                    }
                    //                    Spacer()
                    //                        .frame(height: 0)
                    
                    Text("Answer these questions to help us find your next teacher!")
                        .font(.system(size: 30))
                        .padding(10)
                    HStack(spacing: 10){
                        Text("Name: ")
                            .font(.system(size: 20))
                        TextField("First Name ", text: $firstName)
                            .textFieldStyle(.roundedBorder)
                        TextField("Last Name ", text: $lastName)
                            .textFieldStyle(.roundedBorder)
                        
                    }
                    .padding(10)
                    
                    HStack(spacing: 10){
                        Text("Age")
                            .font(.system(size: 20))
                        Text("\(Int(age))")
                        Slider(
                            value: $age,
                            in: 6...25,
                            step: 1
                        )
                    }
                    .padding(10)
                    HStack(spacing: 10){
                        Picker("Pick an instrument", selection: $selectedInstrument, content:{
                            Text("Cello").tag("Cello")
                            Text("Piano").tag("Piano")
                            Text("Violin").tag("Violin")
                        })
                        
                    }
                }
                    .padding(10)
                    VStack(alignment: .leading, spacing: 5){
                        Text("Musical background (Optional)")
                            .font(.system(size: 25))
                        HStack(spacing: 10){
                            Text("Years Playing:  ")
                                .font(.system(size: 20))
                            Text("\(Int(yearsPlaying))")
                            Slider(
                                value: $yearsPlaying,
                                in: 6...25,
                                step: 1
                            )
                        }
                        Text("Skill Level")
                        Picker("Level", selection: $studentLevel, content:{
                            Text("Beginner").tag("Beginner")
                            Text("Intermediate").tag("Intermediate")
                            Text("Advanced").tag("Advanced")

                        }).pickerStyle(.segmented)
                        Text("Prior Pieces played")
                        TextField("Names of pieces if applicable", text: $description, axis:.vertical)
                            .textFieldStyle(.roundedBorder)
                    }
                    .padding(10)
                    Group{
                        VStack(alignment: .leading, spacing: 10){
                            Text("Preferred Cost (Max) of teacher")
                                .font(.system(size: 20))
                            Text("($0 for free teacher)")
                                .font(.system(size: 20))
                            Text("$\(Int(price))")
                            Slider(
                                value: $price,
                                in: 0...200,
                                step: 1
                            )
                            if(editMode){

                            }

                        }
                        .padding(10)
                        VStack(alignment: .leading, spacing: 5){
                            Text("Login Info")
                                .font(.system(size: 20))
                            Text("Email: " + email)
                                .font(.system(size: 20))
                            if(editMode){
                                //https://www.hackingwithswift.com/quick-start/swiftui/how-to-add-a-textfield-to-an-alert
                            }
                            else{
                                TextField("Enter email (your's or parent's)", text: $email)
                                    .textFieldStyle(.roundedBorder)
                                TextField("Enter a password", text: $password)
                                    .textFieldStyle(.roundedBorder)
                                    .listRowSeparator(.hidden)
                            }

                        }
                        .padding(10)

                    }
                    if(editMode){


                        Toggle(isOn: $changeEmail) {
                            Text("Update Email?")
                                .foregroundColor(.black)
                        }
                        .toggleStyle(iOSCheckboxToggleStyle())
                        if(changeEmail){
                            TextField("Enter new email", text: $newEmail)
                                .textFieldStyle(.roundedBorder)
                        }
                        Toggle(isOn: $changePassword) {
                            Text("Change Password?")
                                .foregroundColor(.black)
    //                            .listRowSeparator(.hidden)
                        }.toggleStyle(iOSCheckboxToggleStyle())
                    }


                    if(changePassword){
                        TextField("Enter new password", text: $newPassword)
                            .textFieldStyle(.roundedBorder)
                            .listRowSeparator(.hidden)
                    }
                if(editMode && (changePassword || changeEmail)){
                        Text("Enter current password to save changes to profile")
                            .listRowSeparator(.hidden)

                        TextField("Enter current password", text: $password)
                            .textFieldStyle(.roundedBorder)
                        Button("Update Profile") {
                            updateProfile(){ canUpdate in
                                if canUpdate{
                                    print("UPDATED SUCCESSFULLy")
                                    createStudentObject()
                                    if(profileImageCount > 1){
                                        modelData.uploadImage(student: modelData.studentUser) { _  in
                                        }
                                    }
                                }
                                else{
                                    print("FAILED TO UPDATE")
                                    
                                }
                            }
//                            createStudentObject()
//                            modelData.registerStudentUser(){ isFound in
//                                if isFound {
//                                    noUserFound = false
//                                    loginSuccessful = true
//                                } else {
//                                    noUserFound = true
//                                    loginSuccessful = false
//                                }
//                            }
                        }
                        .buttonStyle(.bordered)
                        .padding(10)
                        .listRowSeparator(.hidden)
                    }
                    else{
                        Button("Submit Profile") {
                            createStudentObject()
                            modelData.registerStudentUser(){ isFound in
                                if isFound {
                                    noUserFound = false
                                    loginSuccessful = true
                                    modelData.uploadImage(student: modelData.studentUser) { _ in
                                    }
                                } else {
                                    noUserFound = true
                                    loginSuccessful = false
                                }
                            }
                        }.listRowSeparator(.hidden)
                        .buttonStyle(.bordered)
                        .padding(10)
                    }


                        Spacer()
//                    }

            .navigationDestination(isPresented: $loginSuccessful) {
                StudentAppPage()
            }
            .navigationTitle("Edit Profile")
//            .toolbar(.hidden, for: .navigationBar)
                
            }.listRowSeparator(.hidden)
            .alert("No User Found", isPresented: $noUserFound) {
                Button("Try Again", role: .destructive) { }
            }
            
        }
        
        //creates Student and sets it to modelData.studentUser
        func createStudentObject(){
            let loginInfo:KeyValuePairs = [
                "email": email,
                "password": password
            ]
            let musicalBackground:KeyValuePairs = [
                "Instrument": selectedInstrument,
                "Years Playing": String(yearsPlaying),
                "Skill Level": studentLevel,
                "Prior Pieces Played": description,
                "Budget": String(price)
            ]
            let name = firstName + " " +  lastName
            let studentInfo:KeyValuePairs = [
                "name": name,
                "firstName": firstName,
                "lastName": lastName,
                "age": String(age)
            ]
            


            modelData.studentUser = Student(name: firstName + " " + lastName)
            modelData.studentUser.email = email
            modelData.studentUser.password = password
            let uiImage = viewModel.profileImage?.uiImage ?? viewModel.uiImage2 ?? UIImage(systemName: "person.badge.shield.checkmark.fill")
//            modelData.studentUser.setUIImage(uiImage: uiImage!)
            modelData.uiImage = uiImage
            modelData.studentUser.populateInfo(personalInfo: studentInfo, loginInfo: loginInfo, musicalBackground: musicalBackground)
            
        }
    
    func updateProfile(completion: @escaping (Bool) -> Void){
        invalidPassword = false
        invalidNewPassword = false
        invalidEmail = false
        print("Updating Profile")
        let user = Auth.auth().currentUser
        var credential: AuthCredential
        credential = EmailAuthProvider.credential(withEmail: email, password: password)
        var success = true
        if(changeEmail || changePassword){
            user?.reauthenticate(with: credential){ result, error in
                if let error = error{
                    print("INCORRECT PASSWORD")
                    invalidPassword = true
                    completion(false)
                }
                else{
                    print("CORRECT PASSWORD")
                    if(changeEmail){
                        //check if email is valid before changing password if changePassword is a thing
                        modelData.checkEmailValidity(email: newEmail) { canChangeEmail in
                            if canChangeEmail{
                                print("CAN CHANGE EMAIL")
                                //attempt to change the password
                                if(changePassword){
                                    Auth.auth().currentUser?.updatePassword(to: newPassword){ (error) in
                                        if let error = error{
                                            print("INVALID NEW PASSSWORD")
                                            invalidNewPassword = true
                                            completion(false)
                                        }
                                        else{
                                            print("CHANGING EMAIL AND PASSWORD")
                                            completion(true)
                                            Auth.auth().currentUser?.updateEmail(to: newEmail){ (error) in
                                                if let error = error{
                                                    print("DIDNT UPDATE EMIAL")
                                                }
                                                else{
                                                    email = newEmail
                                                    print("UPDATED EMAIL")
                                                }
                                            }
                                        }
                                    }
                                }
                                else{
                                    print("ATTEMPTING TO UPDATE EMIAL")
                                    Auth.auth().currentUser?.updateEmail(to: newEmail){ (error) in
                                        if let error = error{
                                            print("DIDNT UPDATE EMIAL")
                                        }
                                        else{
                                            email = newEmail
                                            print("UPDATED EMAIL")
                                        }
                                    }
                                }
                            }
                            else{
                                print("CNAT USSE EMIAL")
                                completion(false)
                            }
                            print("HELLO")
                        }
                        print("DIFJDIFJIJ")
                    }
                    else{
                        Auth.auth().currentUser?.updatePassword(to: newPassword){ (error) in
                            if let error = error{
                                print("OTHER")
                                completion(false)
                            }
                            else{
                                print("OTHER")
                                completion(true)
                            }
                        }
                    }
                }
            }
        }
        else{
           completion(true)
        }
    }
    func populateProfileEditor(student:Student){
        //personal info
        name = student.name
        firstName = value(key: "firstName", pairs: student.personalInfo)
        lastName = value(key: "lastName", pairs: student.personalInfo)
        age = convertToDouble(s:value(key: "age", pairs: student.personalInfo))
        //loginInfo 
        email = modelData.email ?? "template@gmail.com"
        //musical background
        selectedInstrument = value(key: "Instrument", pairs: student.musicalBackground)
        yearsPlaying = convertToDouble(s:value(key: "Years Playing", pairs: student.musicalBackground))
        studentLevel = value(key: "Skill Level", pairs: student.musicalBackground)
        description = value(key: "Prior Pieces Played", pairs: student.musicalBackground)
        price = convertToDouble(s:value(key: "Budget", pairs: student.musicalBackground))

        let image2 = Image(uiImage: modelData.uiImage ?? UIImage(systemName: "person.fill")!)
        viewModel.setImageState(imageState: .success(image2))//                            let image =

    }
    func populateImage() async {
        if modelData.uiImage == nil {
            var subscription: AnyCancellable?
            var isCancelled = false

            subscription = modelData.$uiImage
                .sink { image in
                    if let image = image {
                        // uiImage is not nil, execute the desired method
                        if !isCancelled {
                            DispatchQueue.main.async {
                                let image2 = Image(uiImage: modelData.uiImage ?? UIImage(systemName: "camera.macro")!)
                                viewModel.setImageState(imageState: .success(image2))
                                toggle.toggle()

                            }
                            subscription?.cancel()
                        }
                    }
                }

            // Wait for the task to be cancelled or completed
            await Task.yield()

            // Check if the task was cancelled
            if Task.isCancelled {
                isCancelled = true
            }
        }
    }

    func value(key: String, pairs: KeyValuePairs<String, String>) -> String {
        if let index = pairs.firstIndex(where: { $0.0 == key }) {
            print("KEY: " + key + " VALUE: " + pairs[index].value)
            return pairs[index].value
        } else {
            return ""
        }
    }
    func convertToDouble(s:String) -> Double{
        if let doubleValue = Double(s) {
            return doubleValue
        } else {
            return 0
        }
    }
//        struct CreateStudentProfilePage_Previews: PreviewProvider {
//            static var previews: some View {
//                CreateStudentProfilePage()
//                    .environmentObject(ModelData())
//            }
//        }
    }
    //command 0 for show navigate pane
    

