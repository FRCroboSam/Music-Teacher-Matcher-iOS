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
extension String {
   var isNumeric: Bool {
     return !(self.isEmpty) && self.allSatisfy { $0.isNumber }
   }
}
struct CreateTeacherProfilePage: View {
    @EnvironmentObject var modelData: TeacherModelData
    @EnvironmentObject var viewModel: ProfileModel
    var teacher: Teacher?
    
    @State private var name: String = ""
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var yearsTeaching : CGFloat = 0
    @State private var lessonLength: String = ""
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
    @State private var studentDesc = ""

    @State private var schedule = ""

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
    @State private var lessonFormat: Int = 0

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
    
    @State private var playsCello = false
    @State private var playsViolin = false
    @State private var playsPiano = false
    
    @State private var teachBeginners = false
    @State private var teachIntermediates = false
    @State private var teachAdvanced = false
    
    //toodo: Finish implementing this
    @State private var teachOnline = false
    @State private var teachInperson = false
    @State private var failedPhotoUpdate = false
    @State private var successfulPhotoUpdate = false

    
    var deviceWidth: CGFloat {
        UIScreen.main.bounds.width
    }

    var deviceHeight: CGFloat {
        UIScreen.main.bounds.height
    }
    
    
    var body: some View {
        //        NavigationStack{
        
        Form{
            
            if(editMode){
                Text("Edit Your Profile Settings")
                    .font(.system(size: 35))
                    .fontWeight(.bold)
                    .padding(10)
            }
            else{
                VStack{
                    Text("Your Teacher Profile")
                        .font(.system(size: 40))
                        .fontWeight(.bold)
                        .padding(10)
                        .modifier(CenterModifier())

                    Divider()

                }.listRowSeparator(.hidden)
            }
            VStack{
                Text("Answer these questions to help students determine if you are compatible!")
                    .font(.system(size: 20))
                    .padding(.bottom, 10)
                Divider()
            }.listRowSeparator(.hidden)

            
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
                Text("Don't close the app until you see a notification that the photo was uploaded")
                    .italic()
                    .font(.system(size: 15))
                    .foregroundColor(Color(UIColor.systemGray4))
            }.listRowSeparator(.hidden)

            .onAppear{
                UITableView.appearance().backgroundView = UIImageView(image: UIImage(named: "music_background"))
                print("APPEARING")
                if(editMode){
                    if(teacher != nil){
                        print("POPULATING PROFILE EDITOR")
                        populateProfileEditor(teacher: teacher ?? Teacher(name: "DKFJDJ"))
                        modelData.hasPopulated = true
                    }
                    if(modelData.uiImage == nil){
                        print("UIIMAGE NIL BUT URL IS: " + (modelData.imageURL ?? "DF"))
                        Task {
                            await populateImage()
                        }
                    }
                    
                }
                else if(!editMode){
                    print("UIIMAGE NIL??" + String(modelData.uiImage == nil))
//                    viewModel.setImageState(imageState: .empty)
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
                    }.buttonStyle(FillButtonStyle(isClicked: $playsCello, color: .brown))
                    Button("Piano"){
                    }.buttonStyle(FillButtonStyle(isClicked: $playsPiano, color: .blue))
                    Button("Violin"){
                    }.buttonStyle(FillButtonStyle(isClicked: $playsViolin, color: .red))

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
                        name: "Years Teaching/Playing: ", maxValue: 25, minValue: 0
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
                            
                        }.buttonStyle(FillButtonStyle(isClicked: $teachBeginners, color: .green))
                        Button("Intermediate"){
                            
                        }.buttonStyle(FillButtonStyle(isClicked: $teachIntermediates, color: .teal))
                        
                    }
                    Button("Advanced"){
                        
                    }.buttonStyle(FillButtonStyle(isClicked: $teachAdvanced, color: .red))
                }
                
                Text("Describe the level interested students should be at. ")
                    .font(.system(size: 20))
                    .listRowSeparator(.visible, edges: .top)
                    .padding(.top, 10)
                TextField("ie. pre-requisite pieces, skills, etc.", text: $studentDesc, axis:.vertical)
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
                            get: {lessonLength},
                            set: {lessonLength = $0.filter{"0123456789".contains($0)}}))
                        .textFieldStyle(.roundedBorder)
                        .frame(maxWidth: 80)
                        
                        Text(" minutes per lesson")
                    }.padding(.bottom, 10)
                    Divider()
                }.listRowSeparator(.hidden)
                
                VStack(alignment: .leading){
                    Text("Select the lesson formats you support")
                    HStack{
                        Button("In person"){
                            
                        }.buttonStyle(FillButtonStyle(isClicked: $teachInperson, color: .teal))
                        Button("Online"){
                            
                        }.buttonStyle(FillButtonStyle(isClicked: $teachOnline, color: .green))

                        
                    }

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
                Text("Describe your ideal lesson schedule, provided below is default schedule.")
                    .listRowSeparator(.hidden)
                TextField("ie. Weekly Lessons each month", text: $schedule)
                    .textFieldStyle(.roundedBorder)
                    .padding(.bottom, 10)
                Text("Enter your location: city, state")
                    .listRowSeparator(.hidden)
                TextField("ie 'Seattle, Washington'", text: $location)
                    .modifier(customViewModifier(roundedCornes: 10, startColor: Color(UIColor.systemGray5), endColor: Color(UIColor.systemGray5), textColor: Color.black))
                if(!editMode){
                    VStack(alignment: .leading, spacing: 5){
                        Text("Login Information: ")
                            .font(.system(size: 20))
                            .padding(.bottom, 10)
                        TextField("Email for students to contact you", text: $email)
                            .textFieldStyle(.roundedBorder)
                        TextField("Password: ", text: $password)
                            .textFieldStyle(.roundedBorder)
                    }
                }
                else{
                    Text("Email: " + (email ?? "No email found"))
                        .font(.system(size: 20))
                    HStack{
                        Text("Update Email?")
                        iosCheckboxToggleStyle(checked: $changeEmail)
                    }.listRowSeparator(changeEmail ? .hidden : .visible)
                        .padding(.bottom, 10)
                    if(changeEmail){
                        TextField("Enter new email", text: $newEmail)
                            .textFieldStyle(.roundedBorder)
                    }
                    HStack{
                        Text("Change Password?")
                        iosCheckboxToggleStyle(checked: $changePassword)
                    }.listRowSeparator(changePassword ? .hidden : .visible)
                        .padding(.bottom, 10)
                    if(changePassword){
                        TextField("Enter new password", text: $newPassword)
                            .textFieldStyle(.roundedBorder)
                    }
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
                                    modelData.uploadImage(teacher: modelData.teacherUser) { success  in
                                        if(success){
                                            failedPhotoUpdate = false
                                            successfulPhotoUpdate = true
                                        }
                                        else{
                                            failedPhotoUpdate = true
                                            successfulPhotoUpdate = false
                                        }
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
                    }
                    .buttonStyle(BigButtonStyle(color: .orange))
                    .padding(10)
                    .listRowSeparator(.hidden)
                    Spacer()
                        .frame(height: 20)
                    Button("Delete Account"){
                        loggedOut = true
                        modelData.deleteAccount()
                    }
                        .buttonStyle(BigButtonStyle(color: .red))
                        .padding(10)
                        .listRowSeparator(.hidden)
                }
                else{
                    Button("Submit Profile") {
                        createTeacherObject()
                        modelData.submitProfile(teacher: modelData.teacherUser){ isFound in
                            if isFound {
                                noUserFound = false
                                loginSuccessful = true
                                editMode = true
                                modelData.uploadImage(teacher: modelData.teacherUser){ _ in
                                    
                                }
                            } else {
                                noUserFound = true
                                loginSuccessful = false
                            }
                        }
                    }.listRowSeparator(.hidden)
                        .buttonStyle(BigButtonStyle(color: .orange))
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
                .alert("Failed to update info: Check password and email", isPresented: $failedUpdate) {
                    Button("Try Again", role: .destructive) { }
                }
                .alert("Info updated successfully", isPresented: $updatedSuccessfully) {
                    Button("Ok", role: .destructive) { }
                }
                .alert("Photo uploaded successfully", isPresented: $successfulPhotoUpdate) {
                    Button("Ok", role: .destructive) { }
                }
                .alert("Failed to upload Photo", isPresented: $failedPhotoUpdate) {
                    Button("Ok", role: .destructive) { }
                }
            }.modifier(FormHiddenBackground())
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
            }

            .background{
                Image("music_background")
            }
        }
        func createTeacherObject(){
            print("YEARS TEACHING: " + String(Double(yearsTeaching)))
            var instrument: String = ""
            var levels: String = ""
            var format: String = ""
            if(teachOnline){
                format += "Online"
            }
            if(teachInperson){
                format += " In person"
            }
            if(playsCello){
                instrument += "Cello"
            }
            if(playsViolin){
                instrument += " Violin"
            }
            if(playsPiano){
                instrument += " Piano"
            }
            
            if(teachBeginners){
                levels += "Beginner"
            }
            if(teachIntermediates){
                levels += " Intermediate"
            }
            if(teachAdvanced){
                levels += " Advanced"
            }
            print("LEVELS IS: " + levels)
            let loginInfo:KeyValuePairs = [
                "email": email,
//                "password": password
            ]
            let degree = hasMusicDegree ? musicDegree : "No"
            let musicalBackground:KeyValuePairs = [
                "Instrument": instrument,
                "Years Teaching": String(Double(yearsTeaching)),
                "Musical Degree": degree,
                "Teaching Style": teachingStyle,
                "Student Description": studentDesc
            ]
            let cost = customPricing ? pricingInfo : String(cost)
            let lessonInfo:KeyValuePairs = [
                "Lesson Length": String(lessonLength),
                "Pricing": cost,
                "Levels": levels,
                "Schedule": schedule,
                
            ]
            let name = firstName + " " +  lastName
            let teacherInfo:KeyValuePairs = [
                "name": name,
                "firstName": firstName,
                "lastName": lastName,
                "Location": location,
                "Format": format
            ]
            modelData.teacherUser = Teacher(name: firstName + " " + lastName)
            modelData.teacherUser.email = email
            modelData.teacherUser.password = password
            //get image from editablecircle profile view thing
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
                                                        modelData.email = newEmail
                                                        print(email)
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
                                                modelData.teacherUser.email = email
                                                modelData.email = email
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

            print(teacher.lessonInfo)
            print(teacher.teacherInfo)
            //personal info
            name = teacher.name
            firstName = value(key: "firstName", pairs: teacher.teacherInfo)
            lastName = value(key: "lastName", pairs: teacher.teacherInfo)
            location = value(key:"Location", pairs: teacher.teacherInfo)
            
            yearsTeaching = convertToDouble(s:value(key: "Years Teaching", pairs: teacher.musicalBackground))
            email = modelData.email ?? "template@gmail.com"
            
            let actualCost = value(key: "Pricing", pairs: teacher.lessonInfo)
            if(!actualCost.isNumeric){
                customPricing = true
                pricingInfo = actualCost
            }
            else{
                cost = actualCost
            }
            schedule = value(key: "Schedule", pairs: teacher.lessonInfo)
            studentDesc = value(key: "Student Description", pairs: teacher.musicalBackground) ?? "Student should know pieces like Twinkle Twinkle Little Star "
            musicDegree = value(key: "Musical Degree", pairs: teacher.musicalBackground)
            if(musicDegree != "No"){
                hasMusicDegree = true
            }
            let instruments = value(key: "Instrument", pairs: teacher.musicalBackground)
            let format = value(key: "Format", pairs: teacher.teacherInfo)
            if(instruments.localizedCaseInsensitiveContains("Cello")){
                playsCello = true
            }
            if(instruments.localizedCaseInsensitiveContains("Violin")){
                playsViolin = true
            }
            if(instruments.localizedCaseInsensitiveContains("Piano")){
                playsPiano = true
            }
            print("FORMAT IS: " + format)
            if(format.localizedCaseInsensitiveContains("person")){
                teachInperson = true
            }
            if(format.localizedCaseInsensitiveContains("Online")){
                teachOnline = true
            }
            
            let taughtLevels = value(key: "Levels", pairs: teacher.lessonInfo) ?? value(key: "Minimum Student Level", pairs: teacher.lessonInfo) ?? "Beginner"
            print("LEVELS TAUGHT: " + taughtLevels)
            if(taughtLevels.localizedCaseInsensitiveContains("Beginner")){
                teachBeginners = true
            }
            if(taughtLevels.localizedCaseInsensitiveContains("Intermediate")){
                teachIntermediates = true
            }
            if(taughtLevels.localizedCaseInsensitiveContains("Advanced")){
                teachAdvanced = true
            }
            
            
            

            
            if(instruments.localizedCaseInsensitiveContains("Cello")){
                playsCello = true
            }
            if(instruments.localizedCaseInsensitiveContains("Violin")){
                playsViolin = true
            }
            if(instruments.localizedCaseInsensitiveContains("Piano")){
                playsPiano = true
            }
            lessonLength = value(key: "Lesson Length", pairs: teacher.lessonInfo) ?? "60"
            teachingStyle = value(key: "Teaching Style", pairs: teacher.musicalBackground)
            musicalBackground = value(key: "Musical Degree", pairs: teacher.musicalBackground)
            let image2 = Image(uiImage: modelData.uiImage ?? UIImage(systemName: "person.fill")!)
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
//                                    print("NOT NIL ANYMORE")

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




