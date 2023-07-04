//
//  CreateTeacherProfilePage.swift
//  MusicAppSeniorProject
//
//  Created by Samuel Wang on 2/20/23.
//

import SwiftUI

struct CreateTeacherProfilePage: View {
    @EnvironmentObject var modelData: TeacherModelData
    @EnvironmentObject var viewModel: ProfileModel

    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var yearsTeaching : Double = 0
    @State private var lessonLength: Int = 60
    @State private var description: String = ""
    @State private var instrument: String = "Cello"
    @State private var lessonType: String = ""
    @State private var location: String = ""
    @State private var cost: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var noUserFound = false
    @State private var registrationSuccessful = false
    @State private var hasMusicDegree = false
    @State private var teachingStyle = ""
    @State private var musicDegree = ""
    @State private var musicalBackground = ""
    @State private var pricingInfo = ""
    @State private var customPricing = false
    @State private var custom = false
    @State private var studentLevel = "Beginner"
    
    @State private var useCamera = false

    var editMode = false
    @State var newEmail = ""
    @State var newPassword = ""
    @State var hasPopulated = false
    var student: Student?
    
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
    
    
    var body: some View {
//        NavigationStack{
            Form{
                    Text("Your Teacher Profile")
                        .font(.system(size: 40))
                        .fontWeight(.bold)
                        .padding(10)
                    Spacer()
                        .frame(height: 0)
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
//                        if(editMode && !hasPopulated){
//                            if(student != nil){
//                                populateProfileEditor(student: student ?? Student(name: "DKFJDJ"))
//                                hasPopulated = true
//                            }
//                            if(modelData.uiImage == nil){
//                                Task {
//                                    await populateImage()
//                                }
//                            }
//
//                        }
                }
                    Text("Help students learn about you!")
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

                    Section{
                        HStack(spacing: 10){
                            Picker("Select your instrument", selection: $instrument, content:{
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
                            Text("Years Teaching:  ")
                            Text("\(Int(yearsTeaching))")
                            Slider(
                                value: $yearsTeaching,
                                in: 6...25,
                                step: 1
                            )
                        }
                        Toggle(isOn: $hasMusicDegree) {
                            Text("Do you have a musical degree?")
                                .foregroundColor(.black)
                        }
                        .toggleStyle(iOSCheckboxToggleStyle())
                        if(hasMusicDegree){
                            TextField("Enter the school or institution name", text: $musicDegree, axis:.vertical)
                                .textFieldStyle(.roundedBorder)
                        }
                        Text("Teaching Style/Background")
                        TextField("Tell students about your teaching style!", text: $teachingStyle, axis:.vertical)
                            .textFieldStyle(.roundedBorder)


                    }
                    .padding(10)

                    VStack(alignment: .leading, spacing: 10){
                        Text("Lesson Info")
                            .font(.system(size: 30))
                        Text("Minimum Level of Student")
                        Picker("Instrument", selection: $studentLevel, content:{
                            Text("Beginner").tag("Beginner")
                            Text("Intermediate").tag("Intermediate")
                            Text("Advanced").tag("Advanced")

                        }).pickerStyle(.segmented)
                        HStack{
                            Picker(selection: $lessonLength,
                                   label: Text("Lesson Length"),
                                   content:{
                                Text("30 min").tag(30)
                                Text("45 min").tag(45)
                                Text("60 min").tag(60)
                                Text("90 min").tag(90)
                                Text("120 min").tag(120)
                            })

                        }

                        HStack{

                            Picker("Lesson Type", selection: $lessonType, content:{
                                Text("In Person").tag("In person")
                                Text("Online").tag("Online")
                                Text("Hybrid").tag("Hybrid")
                            })
                        }
                        Text("Payment Info (Optional)")
                            .font(.system(size: 20))
                        HStack{
                            Text("Custom pricing?")
                            iosCheckboxToggleStyle(checked:$customPricing)
//                            Toggle(isOn: $perLesson) {
//                                Text("Per Lesson?")
//                                    .foregroundColor(.black)
//                            }
//                            .toggleStyle(iOSCheckboxToggleStyle())
                        }
                        if(customPricing){
                            TextField("Describe pricing/tuition rates", text: $pricingInfo, axis:.vertical)
                                .textFieldStyle(.roundedBorder)
                                .frame(height:50)
                        }
                        else{
                            HStack{
                                Text("Price: $")

                                TextField("Enter a number", text: Binding(
                                    get: {cost},
                                    set: {cost = $0.filter{"0123456789".contains($0)}}))
                                .textFieldStyle(.roundedBorder)
                                Text("per lesson")
                            }
                        }

                        VStack(alignment: .leading, spacing: 5){
                            Text("Login Information: ")
                                .font(.system(size: 20))
                            TextField("Email for students to contact you", text: $email)
                                .textFieldStyle(.roundedBorder)
                            TextField("Password: ", text: $password)
                                .textFieldStyle(.roundedBorder)
                        }
                    }
                    .padding(10)

                    Button("Create Account") {
                        createTeacherObject()
                        modelData.submitProfile(teacher: modelData.teacherUser){ isFound in
                            if isFound {
                                noUserFound = false
                                registrationSuccessful = true
                            } else {
                                print("REGISTRATION SUCCESSFUL")
                                noUserFound = true
                                registrationSuccessful = false
                            }
                        }
                    }


                    .navigationBarBackButtonHidden(true)
                    .buttonStyle(.bordered)
                    .padding(10)

                    Spacer()
                        .navigationBarBackButtonHidden(true)
                .navigationDestination(isPresented: $registrationSuccessful) {
                    TeacherAppPage()
                }
                .navigationTitle("Edit Profile")
                .toolbar(.hidden, for: .navigationBar)
            }

//        }
    }
    func createTeacherObject(){
        let loginInfo:KeyValuePairs = [
            "email": email,
            "password": password
        ]
        let degree = hasMusicDegree ? musicalBackground : "No"
        let musicalBackground:KeyValuePairs = [
            "Instrument": instrument,
            "Years Teaching": String(yearsTeaching),
            "Musical Degree": degree,
            "Teaching Style": teachingStyle,
        ]
        let cost = customPricing ? pricingInfo : String(cost + " per lesson")
        let lessonInfo:KeyValuePairs = [
            "Lesson Length": String(lessonLength),
            "Pricing": cost,
            "Minimum Student Level": studentLevel,
        ]
        let name = firstName + " " +  lastName
        let teacherInfo:KeyValuePairs = [
            "name": name,
            "firstName": firstName,
            "lastName": lastName
        ]
        modelData.teacherUser = Teacher(name: firstName + " " + lastName)
        modelData.teacherUser.email = email
        modelData.teacherUser.password = password
        modelData.teacherUser.populateInfo(teacherInfo: teacherInfo, loginInfo: loginInfo, musicalBackground: musicalBackground, lessonInfo: lessonInfo)
    }
}

struct CreateTeacherProfilePage_Previews: PreviewProvider {
    static var previews: some View {
        CreateTeacherProfilePage()
            .environmentObject(TeacherModelData())
    }
}
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

