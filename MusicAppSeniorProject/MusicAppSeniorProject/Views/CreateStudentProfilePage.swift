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
import SDWebImageSwiftUI

enum Instrument: String, CaseIterable, Identifiable {
    case cello, piano, violin
    var id: Self { self }
}
//TODO: redo the studentLevel logic for population in firebase

struct CreateStudentProfilePage: View{
    @EnvironmentObject var modelData: ModelData
    @EnvironmentObject var viewModel: ProfileModel
    @State private var name: String = ""
    @State private var loginSuccessful = false
    @State private var noUserFound = true
    @State private var firstName: String = ""
    @State private var lessonLength: String = ""
    @State private var teacherDesc: String = ""
    @State private var lastName: String = ""
    @State private var age : CGFloat = 0
    @State private var yearsPlaying: CGFloat = 0
    @State private var price: Double = 0
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var selectedInstrument: String = "Cello"
    @State private var studentLevel: Int = 0
    @State private var description: String = ""
    @State private var image = UIImage(systemName: "person.fill")
    @State var displayImage: Bool = false
    @State private var useCamera = false
    @State private var toggle: Bool = false
    @State private var changePassword: Bool = false
    @State private var changeEmail: Bool = false
    //TODO: Add feature where user can type a city name and locations will begin popping up
    @State private var location: String = ""
    @State private var schedule: String = "Weekly lessons per month."
    @State private var lessonFormat: Int = 0
    var editMode = false
    @State var newEmail = ""
    @State var newPassword = ""
    var student: Student?
    
    @State var invalidEmail = false
    @State var invalidNewPassword = false
    @State var invalidPassword = false
    @State var loggedOut = false
    @State private var value:CGFloat = 0
    @State var offset: CGFloat = 25
    
    @State private var teachInperson: Bool = false
    @State private var teachOnline: Bool = false

    
    //    @State var tag:Int? = nil
    
    //    @State private var sldkfj: String = ""
    
    //for checking which fields were updated
    @State private var profileImageCount = 0
    @State private var failedUpdate = false
    @State private var updatedSuccessfully = false
    var body: some View {
//        NavigationStack{
            Form{
                Section{
                    if(editMode){
                        Text("Edit Your Profile Settings")
                            .font(.system(size: 35))
                            .fontWeight(.bold)
                            .padding(10)
                    }
                    else{
                        VStack{
                            Text("Your Student Profile")
                                .font(.system(size: 40))
                                .fontWeight(.bold)
                                .padding(10)
                                .modifier(CenterModifier())

                            Divider()
                        }.listRowSeparator(.hidden)
                    }
                    Text("Answer these questions to help us find your next teacher!")
                        .font(.system(size: 20))
                        .padding(.top, -10)
                        .padding(.bottom, 10)
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
                        VStack{
                            Button("Use Camera to take a photo") {
                                useCamera = true
                            }
                            .buttonStyle(.bordered)
                            .padding(10)
                            .navigationDestination(isPresented: $useCamera) {
                                CameraView()
                            }
                            Divider()
                        }.listRowSeparator(.hidden)
                    }
                    .onAppear{
                        UITableView.appearance().backgroundView = UIImageView(image: UIImage(named: "music_background"))
                        print("APPEARING")
                        if(editMode){
                            if(student != nil){
                                print("REPOPULATING THE PROFILE EDITOR")
                                populateProfileEditor(student: student ?? Student(name: "DKFJDJ"))
                                modelData.hasPopulated = true
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
                    VStack(alignment: .leading){
                        Text("Enter your name")
                            .font(.system(size: 20))
                        
                    }.listRowSeparator(.hidden)
                        .padding(.top, -10)
                        .padding(.bottom, -10)

                    HStack(spacing: 10){
                        TextField("First Name ", text: $firstName)
                            .textFieldStyle(.roundedBorder)
                        TextField("Last Name ", text: $lastName)
                            .textFieldStyle(.roundedBorder)
                    }
                    VStack(spacing: 5){

//                        Text("\(Int(age))")
//                        Slider(
//                            value: $age,
//                            in: 0...25,
//                            step: 1
//                        )
                        CustomSlider(value: $age , name: "Select Your Age", maxValue: 25, minValue: 4)
//                        ZStack(alignment: Alignment (horizontal: .leading, vertical: .center), content: {
//                            Capsule()
//                                    .fill(Color.black.opacity(0.25))
//                                    .frame(height: 30)
//                            Capsule()
//                                    .fill(Color.purple)
//                                    .frame(width: offset + 20, height: 30)
//                            Circle()
//                                .fill(Color.orange)
//                                .frame(width: 35, height: 35)
//                                .background (Circle().stroke (Color.white, lineWidth: 5))
//                                .offset(x: offset)
//                                .gesture (DragGesture().onChanged({ (value) in
//                                // Padding Horizontal....
//                                // Padding Horizontal = 30
//                                // Circle radius = 20
//                                // Total
//                            if value.location.x > 15 && value.location.x <=
//                                UIScreen.main.bounds.width - 120{
//                                offset = value.location.x - 20
//                            }
//                        }))
//                        })
                    }
                    .padding(10)
                    VStack{
                        Text("Select the instrument you want to take lessons for.")
//                            .listRowSeparator(.hidden)
                        HStack(spacing: 10){
                            HStack {
                                Spacer()
                                Text("Cello")
                                    .bold()
                                
                                    .padding()
                                    .background(selectedInstrument == "Cello" ? Color.orange : Color(UIColor.systemGray6))
                                    .cornerRadius(8)
                                    .onTapGesture {
                                        withAnimation(.easeInOut(duration: 0.3)) {
                                            selectedInstrument = "Cello"
                                        }
                                    }
                                Spacer()
                                Text("Piano")
                                    .padding()
                                    .bold()
                                
                                    .background(selectedInstrument == "Piano" ? Color.orange : Color(UIColor.systemGray6))
                                    .cornerRadius(8)
                                    .onTapGesture {
                                        withAnimation(.easeInOut(duration: 0.3)) {
                                            selectedInstrument = "Piano"
                                        }
                                    }
                                Spacer()
                                Text("Violin")
                                    .bold()
                                    .padding()
                                    .background(selectedInstrument == "Violin" ? Color.orange :  Color(UIColor.systemGray6))
                                    .cornerRadius(8)
                                    .onTapGesture {
                                        withAnimation(.easeInOut(duration: 0.3)) {
                                            selectedInstrument = "Violin"
                                        }
                                    }
                                Spacer()
                            }
                            
                            
                            
                            
                            
                            
                            
                            
                            
                        }
                    }
                }
                    .padding(10)
                    Section{
                        VStack(alignment: .center){
                            Text("Musical background")
                                .font(.system(size: 30))
                                .bold()
                            Divider()
                        }.listRowSeparator(.hidden)
                        VStack(spacing: 10){
                            CustomSlider(
                                value: $yearsPlaying,
                                name: "Years Playing: ", maxValue: 20, minValue: 0
                            ).padding(5)
                        }.padding(.top, -10)
//                        Divider()
                        Text("Skill Level")
                            .font(.system(size: 20))
                            .listRowSeparator(.hidden, edges: .bottom)
                            .padding(.bottom, -10)
                        Picker("Level", selection: $studentLevel, content:{
                            Text("Beginner").tag(0)
                            Text("Intermediate").tag(1)
                            Text("Advanced").tag(2)
                                .padding(10)

                        }).pickerStyle(.segmented)
                            .onTapGesture(coordinateSpace: .local) { gesture in
                                let pickerWidth = 3/4 * UIScreen.main.bounds.width
                                let segmentWidth = pickerWidth / CGFloat(3) // Assuming 3 segments
                                var newSelection = 0
                                let tapLocationX = gesture.x
                                if tapLocationX < segmentWidth {
                                    newSelection = 0
                                } else if tapLocationX < 2 * segmentWidth {
                                    newSelection = 1
                                } else {
                                    newSelection = 2
                                }
                                
                                withAnimation {
                                    studentLevel = newSelection
                                }
                            }
//                        Divider()
                        Text("Prior Pieces played")
                            .font(.system(size: 20))
                            .listRowSeparator(.hidden, edges: .bottom)
                            .padding(.bottom, -10)
                        TextField("Names of pieces ", text: $description, axis:.vertical)
                            .textFieldStyle(.roundedBorder)
                            .padding(.horizontal, 10)
//                        Divider()
                        Text("Describe what kind of teacher you are looking for. ")
                            .listRowSeparator(.hidden, edges: .bottom)
                            .font(.system(size: 20))
                            .padding(.bottom, -10)
                        TextField("ie. A teacher that will instill good habits. ", text: $teacherDesc, axis:.vertical)
                            .textFieldStyle(.roundedBorder)
                            .padding(.horizontal, 10)
//                        Divider()
                        VStack{
                            Text("Select the lesson formats you want.")
                                .font(.system(size: 20))
                                .listRowSeparator(.hidden, edges: .bottom)
                            HStack{
                                
                                Button("In person"){
                                    
                                }.buttonStyle(FillButtonStyle(isClicked: $teachInperson, color: .teal))
                                Button("Online"){
                                    
                                }.buttonStyle(FillButtonStyle(isClicked: $teachOnline, color: .green))
                                
                                
                            }
                        }
                    }
                    .padding(10)
                Section{
                    VStack(alignment: .leading, spacing: 10){
                        VStack(alignment: .center){
                            Text("Lesson Logistics")
                                .font(.system(size: 30))
                                .bold()
                            Divider()
                        }.listRowSeparator(.hidden)
                        Text("Preferred Cost (Max) of teacher")
                            .font(.system(size: 20))
                        Text("$\(Int(price))")
                        Slider(
                            value: $price,
                            in: 0...200,
                            step: 1
                        )
                        if(editMode){
                            
                        }
                        
                    } //.padding(10)
                    
                    Text("Lesson Length: ")
                        .font(.system(size: 20))
                        .listRowSeparator(.hidden)
                        .padding(.horizontal, 10)
                    VStack(alignment: .leading){
                        HStack{
                            TextField("60", text: Binding(
                                get: {lessonLength},
                                set: {lessonLength = $0.filter{"0123456789".contains($0)}}))
                            .textFieldStyle(.roundedBorder)
                            .frame(maxWidth: 80)
                            
                            Text(" minutes per lesson")
                        }.padding(.bottom, 10)
                        Divider()
                    }.listRowSeparator(.hidden)
                    Text("Enter your location")
                        .font(.system(size: 20))
                        .padding(.horizontal, 10)
                    
                        .listRowSeparator(.hidden)
                    TextField("ie. Seattle, WA", text: $location)
                        .textFieldStyle(.roundedBorder)
                        .listRowSeparator(.visible, edges: .bottom)
                        .padding(.bottom, 10)
                    Text("Describe your ideal lesson schedule, provided below is default schedule.")
                        .padding(.horizontal, 10)
                    
                        .font(.system(size: 20))
                        .listRowSeparator(.hidden)
                    TextField("ie. Weekly Lessons each month", text: $schedule)
                        .textFieldStyle(.roundedBorder)
                        .padding(.bottom, 10)
                }
                Section{
                    VStack(alignment: .center){
                        Text("Login Info")
                            .font(.system(size: 30))
                            .bold()
                        Divider()
                    }.listRowSeparator(.hidden)
                    if(editMode){
                        Text("Email: " + email)
                            .font(.system(size: 20))
                            .padding(.horizontal, 10)
                    }
                    else{
                        TextField("Enter email (your's or parent's)", text: $email)
                            .textFieldStyle(.roundedBorder)
                        TextField("Enter a password", text: $password)
                            .textFieldStyle(.roundedBorder)
                            .listRowSeparator(.hidden)
                        
                    }
                    
                    
                    
                    
                    if(editMode){
                        HStack{
                            Text("Update Email?")
                                .font(.system(size: 20))
                                .padding(.horizontal, 10)
                            iosCheckboxToggleStyle(checked: $changeEmail)
                        }.listRowSeparator(changeEmail ? .hidden : .visible)
                            .padding(.bottom, 10)
                        if(changeEmail){
                            TextField("Enter new email", text: $newEmail)
                                .textFieldStyle(.roundedBorder)
                                .padding(.horizontal, 10)
                                .padding(.bottom, 10)
                            
                        }
                        HStack{
                            Text("Change Password?")
                                .font(.system(size: 20))
                                .padding(.horizontal, 10)
                            
                            
                            iosCheckboxToggleStyle(checked: $changePassword)
                        }
                        .listRowSeparator(changePassword || !changePassword && !changeEmail ? .hidden : .visible)
                            .padding(.bottom, 10)
                        if(changePassword){
                            TextField("Enter new password", text: $newPassword)
                                .textFieldStyle(.roundedBorder)
                                .padding(.horizontal, 10)
                            
                        }
                    }
                    if(editMode){
                        if(changePassword || changeEmail){
                            Text("Enter current password to save changes to profile")
                                .font(.system(size: 20))
                                .listRowSeparator(.hidden)
                                .padding(.horizontal, 10)
                            
                            TextField("Enter current password", text: $password)
                                .textFieldStyle(.roundedBorder)
                                .padding(10)
                        }
                        Button("Update Profile") {
                            updateProfile(){ canUpdate in
                                if canUpdate{
                                    print("UPDATED SUCCESSFULLy")
                                    createStudentObject()
                                    if(profileImageCount > 1){
                                        print("GOING TO UPLOAD AN IMAGE")
                                        modelData.uploadImage(student: modelData.studentUser) { _  in
                                        }
                                    }
                                    modelData.updateStudentData { works in
                                        if(works){
                                            updatedSuccessfully = true
                                            failedUpdate = false
                                        }
                                        else{
                                            failedUpdate = true
                                        }
                                    }
                                }
                                else{
                                    print("FAILED UPDATE")
                                    failedUpdate = true
                                    
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
                        .buttonStyle(BigButtonStyle(color: .orange))
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
                        }
                        .buttonStyle(BigButtonStyle(color: .orange))
                        .listRowSeparator(.hidden)
                            .padding(10)
                    }
                    
                }
                Spacer(minLength: 100)
                    .listRowBackground(Color.clear)
//                    .listRowSeparator(.hidden)

            .navigationDestination(isPresented: $loginSuccessful) {
                StudentAppPage()
            }
            .navigationDestination(isPresented: $loggedOut, destination: {
                HomePage()
            })
//            .navigationTitle("Edit Profile")
//            .toolbar(.hidden, for: .navigationBar)
                
            }
            .gesture(
                TapGesture().onEnded { value in
                    UIApplication.shared.dismissKeyboard()
                })
            .listRowSeparator(.hidden)
            .modifier(FormHiddenBackground())
            .background{
                Image("music_background")
            }
            .alert("Failed to update info: Check password and email", isPresented: $failedUpdate) {
                Button("Try Again", role: .destructive) { }
            }
            .alert("Info updated successfully", isPresented: $updatedSuccessfully) {
                Button("Ok", role: .destructive) { }
            }
            
    }
        
        //creates Student and sets it to modelData.studentUser
        func createStudentObject(){
            //reset newEmail, changeEmail, newPassword, etc
            var format: String = ""
            if(teachOnline){
                format += "Online"
            }
            if(teachInperson){
                format += " In person"
            }
            if(changeEmail){
                email = newEmail
            }
            let loginInfo:KeyValuePairs = [
                "email": email,
                "password": password
            ]
            let musicalBackground:KeyValuePairs = [
                "Instrument": selectedInstrument,
                "Years Playing": String(Double(yearsPlaying)),
                "Skill Level": String(studentLevel),
                "Prior Pieces Played":  description,
                "Budget": String(price)
            ]
            let name = firstName + " " +  lastName
            let studentInfo:KeyValuePairs = [
                "name": name,
                "firstName": firstName,
                "lastName": lastName,
                "age": String(Double(age)),
                "Location": location,
                "Schedule": schedule,
                "Teacher Description": teacherDesc,
                "Format": format,
                "Lesson Length": lessonLength
            ]
            newEmail = ""
            newPassword = ""
            changeEmail = false
            changePassword = false
            


            modelData.studentUser = Student(name: firstName + " " + lastName)
            modelData.studentUser.email = email
            modelData.studentUser.password = password
            
            let uiImage = viewModel.profileImage?.uiImage ?? viewModel.uiImage2 ?? UIImage(systemName: "person.badge.shield.checkmark.fill")
            modelData.studentUser.setUIImage(uiImage: uiImage!)
            //only do this if u selected a diff image
            if(!editMode || profileImageCount > 1){
                modelData.uiImage = uiImage
            }
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
                                            print("GOING TO UPDATE EMAIL")
                                            Auth.auth().currentUser?.updateEmail(to: newEmail){ (error) in
                                                if let error = error{
                                                    print(error)
                                                    print("DIDNT UPDATE EMIAL")
                                                    completion(false)
                                                }
                                                else{
                                                    email = newEmail
                                                    print("UPDATED EMAIL")
                                                    completion(true)
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
                                            completion(false)
                                        }
                                        else{
                                            email = newEmail
                                            print("UPDATED EMAIL")
                                            completion(true)
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
            print("NOT CHANGING EMAIL OR PASSWORD CAN DO")
           completion(true)
        }
    }
    func populateProfileEditor(student:Student){
        print("POPULATING PROFILE EDITOR")
        //personal info
        name = student.name
        print("PERSONAL INFO: ")
        print(student.personalInfo)
        name = value(key: "name", pairs: student.personalInfo)

        firstName = value(key: "firstName", pairs: student.personalInfo)
        lastName = value(key: "lastName", pairs: student.personalInfo)
        print("FIRSTNAME: " + firstName)
        print("LASTNAME: " + lastName)
        age = convertToDouble(s:value(key: "age", pairs: student.personalInfo))
        //loginInfo
        location = value(key: "Location", pairs: student.personalInfo)
        lessonLength = value(key: "Lesson Length", pairs: student.personalInfo)
        let format = value(key: "Format", pairs: student.personalInfo)
        if(format.localizedCaseInsensitiveContains("In person")){
            teachInperson = true
        }
        if(format.localizedCaseInsensitiveContains("Online")){
            teachOnline = true
        }
        schedule = value(key: "Schedule", pairs: student.personalInfo)
        email = modelData.email ?? "template@gmail.com"
        //musical background
        selectedInstrument = value(key: "Instrument", pairs: student.musicalBackground)
        yearsPlaying = convertToDouble(s:value(key: "Years Playing", pairs: student.musicalBackground))
        studentLevel = Int(convertToDouble(s:value(key: "Skill Level", pairs: student.musicalBackground)))
        description = value(key: "Prior Pieces Played", pairs: student.musicalBackground)
        price = convertToDouble(s:value(key: "Budget", pairs: student.musicalBackground))
        teacherDesc = value(key: "Teacher Description", pairs: student.personalInfo)
        print("SEtting profile image 2")
        let image2 = Image(uiImage: modelData.uiImage ?? UIImage(systemName: "heart.fill")!)
        if(!modelData.hasPopulated){
            viewModel.setImageState(imageState: .success(image2))//                            let ima
        }

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
                                print("SETTING THE IMAGE")
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
    
//MAKES THE KEYBOARD GO AEAY

