//
//  CreateTeacherProfilePage.swift
//  MusicAppSeniorProject
//
//  Created by Samuel Wang on 2/20/23.
//

import SwiftUI
import FirebaseAuth
import Combine
//TODO: make sure studentLevel new number logic works
struct CreateTeacherProfilePage: View {
    @EnvironmentObject var modelData: TeacherModelData
    @EnvironmentObject var viewModel: ProfileModel
    var teacher: Teacher?
    
    @State private var name: String = ""
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var yearsTeaching : CGFloat = 0
    @State private var lessonLength: Int = 60
    @State private var description: String = ""
    @State private var instrument: String = "Cello"
    @State private var lessonType: String = ""
    @State private var cost: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var noUserFound = false
    @State private var registrationSuccessful = false
    @State private var hasMusicDegree = false
    @State private var teachingStyle = ""
    @State private var musicDegree = ""
    @State private var musicalBackground = ""
    
    //pricing if custom
    @State private var customPricing = false
    @State private var pricingInfo = ""
    @State private var location = ""
    
    @State private var custom = false
    @State private var studentLevel = 0
    @State private var loginSuccessful = false
    
    @State private var useCamera = false
    
    @State var editMode = false
    @State var hasPopulated = false
    @State var newEmail = ""
    @State var newPassword = ""
    @State private var changePassword: Bool = false
    @State private var changeEmail: Bool = false
    
    @State var invalidEmail = false
    @State var invalidNewPassword = false
    @State var invalidPassword = false
    @State var loggedOut = false
    //    @State var tag:Int? = nil
    
    //    @State private var sldkfj: String = ""
    
    //for checking which fields were updated
    @State private var profileImageCount = 0
    @State private var failedUpdate = false
    @State private var updatedSuccessfully = false
    
    var deviceWidth: CGFloat {
        UIScreen.main.bounds.width
    }

    var deviceHeight: CGFloat {
        UIScreen.main.bounds.height
    }
    
    
    var body: some View {
        //        NavigationStack{
        
        Form{
            
            Text("Your Teacher Profile")
                .font(.system(size: 40))
                .minimumScaleFactor(0.01)
                .fontWeight(.bold)
                .lineLimit(1)
                .padding(10)
                .modifier(CenterModifier())
                .listRowSeparator(.hidden)
            
            VStack(alignment: .center){
                EditableCircularProfileImage()
                    .onReceive(viewModel.$imageSelection){ (value) in
                        print("PROFILE IMAGE CHANGING")
                        profileImageCount += 1
                    }.modifier(CenterModifier())
                
                Text("Select a Profile Picture")
                    .font(.system(size: 20))
                    .fontWeight(.bold)
                    .padding(10)
                    .modifier(CenterModifier())
                    .listRowSeparator(.hidden)
                
                Button("Use Camera to take a photo") {
                    useCamera = true
                }
                    .buttonStyle(.bordered)
                    .padding(10)
                    .navigationDestination(isPresented: $useCamera) {
                        CameraView()
                    }
                    .modifier(CenterModifier())
            }.listRowSeparator(.hidden)

            .onAppear{
                UITableView.appearance().backgroundView = UIImageView(image: UIImage(named: "music_background"))
                print("APPEARING")
                if(editMode && !hasPopulated){
                    if(teacher != nil){
                        populateProfileEditor(teacher: teacher ?? Teacher(name: "DKFJDJ"))
                        hasPopulated = true
                    }
                    if(modelData.uiImage == nil){
                        Task {
                            await populateImage()
                        }
                    }
                    
                }
            }
            Section{
                VStack{
                    Text("About")
                        .font(.system(size: 30))
                        .bold()
                        .padding(.top, 10)
                        .modifier(CenterModifier())
                    Divider()
                }.listRowSeparator(.hidden)

                Text("Enter your name")
                    .font(.system(size: 20))
                    .listRowSeparator(.hidden, edges: .bottom)
                    .padding(.horizontal, 10)
                    .padding(.bottom, -20)
                HStack(spacing: 10){
                    TextField("First Name ", text: $firstName)
                        .textFieldStyle(.roundedBorder)
                    TextField("Last Name ", text: $lastName)
                        .textFieldStyle(.roundedBorder)
                }.padding(.bottom, 10)
                Text("Select the instrument(s) you teach ")
                    .font(.system(size: 20))
                    .padding(.horizontal, 10)
                    .padding(.bottom, -5)
                HStack(spacing: 10){
                    Button("Cello"){
                        
                    }.buttonStyle(FillButtonStyle(color: .red))
                    Button("Piano"){
                        
                    }.buttonStyle(FillButtonStyle(color: .red))
                    Button("Violin"){
                        
                    }.buttonStyle(FillButtonStyle(color: .red))
                }.listRowSeparator(.hidden)
                .padding(10)
            }
            Section{
                VStack{
                    Text("Musical Background")
                        .font(.system(size: 30))
                        .bold()
                        .padding(.top, 10)
                        .modifier(CenterModifier())
                    Divider()
                }.listRowSeparator(.hidden)
                VStack(spacing: 10){
                    CustomSlider(
                        value: $yearsTeaching,
                        name: "Years Playing: ", maxValue: 25, minValue: 0
                    ).padding(5)
                }
                HStack{
                    Text("Do you have a music degree?")
                        .font(.system(size: 20))

                    Toggle(isOn: $hasMusicDegree) {
                        Image(systemName: hasMusicDegree ? "checkmark.square.fill" : "square")                        .font(.system(size: 20))
                    }
                    .toggleStyle(.button)
                }
                .listRowSeparator(.hidden, edges: .top)
                .listRowSeparator(hasMusicDegree ? .hidden : .visible)

                if(hasMusicDegree){
                    TextField("Enter the school or institution name", text: $musicDegree, axis:.vertical)
                        .textFieldStyle(.roundedBorder)
                        .padding(.bottom, 10)
                        .listRowSeparator(.visible, edges: .bottom)
                }

                Text("Teaching Style")
                    .font(.system(size: 30))
                    .minimumScaleFactor(0.01)
                    .lineLimit(1)
                    .listRowSeparator(.hidden)
                    .padding(.top, 10)
                TextField("Tell students about your teaching style!", text: $teachingStyle, axis:.vertical)
                    .textFieldStyle(.roundedBorder)
                    .listRowSeparator(.hidden)
                Spacer()
                    .frame(height: 5)
            }
            Section{
                VStack{
                    Text("Student Preferences")
                        .font(.system(size: 30))
                        .bold()
                        .padding(.top, 10)
                        .modifier(CenterModifier())
                    Divider()
                }.listRowSeparator(.hidden)
                Text("Select the levels of students you teach.")
                    .font(.system(size: 20))
                    .listRowSeparator(.hidden)
                VStack(alignment: .center){
                    HStack{
                        Button("Beginner"){
                            
                        }.buttonStyle(FillButtonStyle(color: .green))
                        Button("Intermediate"){
                            
                        }.buttonStyle(FillButtonStyle(color: .teal))
                        
                    }
                    Button("Advanced"){
                        
                    }.buttonStyle(FillButtonStyle(color: .red))
                }
                
                Text("Describe the level interested students should be at. ")
                    .font(.system(size: 20))
                    .listRowSeparator(.visible, edges: .top)
                    .padding(.top, 10)
                TextField("ie. pre-requisite pieces, skills, etc.", text: $teachingStyle, axis:.vertical)
                    .textFieldStyle(.roundedBorder)
                    .listRowSeparator(.hidden)
                    .padding(.bottom, 10)
                
            }
            Section{
                VStack{
                    Text("Lesson Info")
                        .font(.system(size: 30))
                        .bold()
                        .padding(.top, 10)
                        .modifier(CenterModifier())
                    Divider()
                }.listRowSeparator(.hidden)
                Text("Lesson Length: ")
                    .listRowSeparator(.hidden)
                VStack(alignment: .leading){
                    HStack{
                        TextField("60", text: Binding(
                            get: {cost},
                            set: {cost = $0.filter{"0123456789".contains($0)}}))
                        .textFieldStyle(.roundedBorder)
                        .frame(maxWidth: 80)
                        
                        Text(" minutes per lesson")
                    }.padding(.bottom, 10)
                    Divider()
                }.listRowSeparator(.hidden)
                
                VStack(alignment: .leading){
                    Text("Payment Info (Optional)")
                        .font(.system(size: 20))
                    HStack{
                        Text("Custom pricing?")
                        iosCheckboxToggleStyle(checked:$customPricing)
                    }.listRowSeparator(customPricing ? .hidden : .visible)
                        .padding(.bottom, 10)
                    if(customPricing){
                        TextField("Describe pricing/tuition rates", text: $pricingInfo, axis:.vertical)
                            .textFieldStyle(.roundedBorder)
                            .frame(height:50)
                    }
                    else{
                        Text("Enter your price per lesson")
                            .listRowSeparator(.hidden)
                        VStack{
                            HStack{
                                Image(systemName: "dollarsign")
                                TextField(" ", text: Binding(
                                    get: {cost},
                                    set: {cost = $0.filter{"0123456789".contains($0)}}))
                                .textFieldStyle(.roundedBorder)
                                .frame(width: 50)
                                Text("per lesson")
                            }
                            Divider()
                        }.listRowSeparator(.hidden)
                        
                        
                    }
                }
                Text("Enter your location: city, state")
                    .listRowSeparator(.hidden)
                TextField("Location, ie 'Seattle, Washington'", text: $location)
                    .padding(20)
                VStack(alignment: .leading, spacing: 5){
                    Text("Login Information: ")
                        .font(.system(size: 20))
                        .padding(.bottom, 10)
                    TextField("Email for students to contact you", text: $email)
                        .textFieldStyle(.roundedBorder)
                    TextField("Password: ", text: $password)
                        .textFieldStyle(.roundedBorder)
                }
                if(editMode){
                    if(changePassword || changeEmail){
                        Text("Enter current password to save changes to profile")
                            .listRowSeparator(.hidden)
                        
                        TextField("Enter current password", text: $password)
                            .textFieldStyle(.roundedBorder)
                    }
                    Button("Update Profile") {
                        updateProfile(){ canUpdate in
                            if canUpdate{
                                print("UPDATED SUCCESSFULLy")
                                createTeacherObject()
                                if(profileImageCount > 1){
                                    print("GOING TO UPLOAD AN IMAGE")
                                    modelData.uploadImage(teacher: modelData.teacherUser) { _  in
                                    }
                                }
                                modelData.updateTeacherData { works in
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
                    .buttonStyle(.bordered)
                    .padding(10)
                    .listRowSeparator(.hidden)
                    Button("Sign out"){
                        modelData.logOut()
                        loggedOut = true
                    }.buttonStyle(.bordered)
                }
                else{
                    Button("Submit Profile") {
                        createTeacherObject()
                        modelData.submitProfile(teacher: modelData.teacherUser){ isFound in
                            if isFound {
                                noUserFound = false
                                loginSuccessful = true
                                editMode = true
                            } else {
                                noUserFound = true
                                loginSuccessful = false
                            }
                        }
                    }.listRowSeparator(.hidden)
                        .buttonStyle(.bordered)
                        .padding(10)
                }
            }
                Spacer()
                    .frame(height: 100)
                    .listRowBackground(Color.clear)
                .navigationDestination(isPresented: $loginSuccessful) {
                    TeacherAppPage()
                }
                .navigationDestination(isPresented: $loggedOut, destination: {
                    HomePage()
                })
            }.modifier(FormHiddenBackground())
            

            .background{
                Image("music_background")
            }
        }
        func createTeacherObject(){
            let loginInfo:KeyValuePairs = [
                "email": email,
                "password": password
            ]
            let degree = hasMusicDegree ? musicalBackground : "No"
            let musicalBackground:KeyValuePairs = [
                "Instrument": instrument,
                "Years Teaching": String(Double(yearsTeaching)),
                "Musical Degree": degree,
                "Teaching Style": teachingStyle,
            ]
            let cost = customPricing ? pricingInfo : String(cost)
            let lessonInfo:KeyValuePairs = [
                "Lesson Length": String(lessonLength),
                "Pricing": cost,
                "Minimum Student Level": String(studentLevel),
            ]
            let name = firstName + " " +  lastName
            let teacherInfo:KeyValuePairs = [
                "name": name,
                "firstName": firstName,
                "lastName": lastName,
                "Location": location
            ]
            modelData.teacherUser = Teacher(name: firstName + " " + lastName)
            modelData.teacherUser.email = email
            modelData.teacherUser.password = password
            let uiImage = viewModel.profileImage?.uiImage ?? viewModel.uiImage2 ?? UIImage(systemName: "person.badge.shield.checkmark.fill")
            modelData.teacherUser.setUIImage(uiImage: uiImage!)
            //only do this if u selected a diff image
            if(!editMode || profileImageCount > 1){
                modelData.uiImage = uiImage
            }
            modelData.teacherUser.populateInfo(teacherInfo: teacherInfo, loginInfo: loginInfo, musicalBackground: musicalBackground, lessonInfo: lessonInfo)
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
        func populateProfileEditor(teacher: Teacher){
            //personal info
            name = teacher.name
            firstName = value(key: "firstName", pairs: teacher.teacherInfo)
            lastName = value(key: "lastName", pairs: teacher.teacherInfo)
            location = value(key:"Location", pairs: teacher.teacherInfo)
            
            yearsTeaching = convertToDouble(s:value(key: "Years Teaching", pairs: teacher.musicalBackground))
            email = modelData.email ?? "template@gmail.com"
            cost = value(key: "Pricing", pairs: teacher.lessonInfo)
            
            instrument = value(key: "Instrument", pairs: teacher.musicalBackground)
            lessonLength = Int(value(key: "Lesson Length", pairs: teacher.lessonInfo)) ?? 60
            studentLevel = Int(value(key: "Minimum Student Level", pairs: teacher.lessonInfo)) ?? 60
            teachingStyle = value(key: "Teaching Style", pairs: teacher.musicalBackground)
            musicalBackground = value(key: "Musical Degree", pairs: teacher.musicalBackground)
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
    
}
    //struct CreateTeacherProfilePage_Previews: PreviewProvider {
    //    static var previews: some View {
    //        CreateTeacherProfilePage()
    //            .environmentObject(TeacherModelData())
    //    }
    //}
    struct iOSCheckboxToggleStyle: ToggleStyle {
        func makeBody(configuration: Configuration) -> some View {
            // 1
            Button(action: {
                
                // 2
                configuration.isOn.toggle()
                
            }, label: {
                HStack {
                    // 3
                    configuration.label
                    Image(systemName: configuration.isOn ? "checkmark.square" : "square")
                        .foregroundColor(.black)
                    
                }
            })
        }
    }
    
    struct FormHiddenBackground: ViewModifier {
        func body(content: Content) -> some View {
            if #available(iOS 16.0, *) {
                content.scrollContentBackground(.hidden)
                
            } else {
                content.onAppear {
                    UITableView.appearance().backgroundColor = .blue
                }
                .onDisappear {
                    UITableView.appearance().backgroundColor = .systemGroupedBackground
                }
            }
        }
    }

