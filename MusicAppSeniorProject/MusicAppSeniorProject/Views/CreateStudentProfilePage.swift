//
//  ProfilePage.swift
//  MusicAppSeniorProject
//
//  Created by Samuel Wang on 1/27/23.
//

import SwiftUI
import FirebaseAuth
import Combine
enum Instrument: String, CaseIterable, Identifiable {
    case cello, piano, violin
    var id: Self { self }
}


struct CreateStudentProfilePage: View{
    @EnvironmentObject var modelData: ModelData
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
    @EnvironmentObject var viewModel: ProfileModel
    @State var displayImage: Bool = false
    @State private var useCamera = false
    @State private var toggle: Bool = false

    var editMode = false
    @State var hasPopulated = false
    var student: Student?
    //    @State var tag:Int? = nil
    
    //    @State private var sldkfj: String = ""
    
    
    var body: some View {
//        NavigationStack{
            Form{
                Section{
                    Text("Your Student Profile")
                        .font(.system(size: 40))
                        .fontWeight(.bold)
                        .padding(10)
                    VStack{
                        EditableCircularProfileImage()
                        Text("Select a Profile Picture")
                            .font(.system(size: 20))
                            .fontWeight(.bold)
                            .padding(10)
//                        NavigationLink(destination:CameraView()){
//                            Text("Use camera to take a photo")
//                        }.buttonStyle(BorderlessButtonStyle())

                    }
                    .onAppear{
                        print("APPEARING")
                        if(editMode && !hasPopulated){
                            if(student != nil){
                                populateProfileEditor(student: student ?? Student(name: "DKFJDJ"))
                                hasPopulated = true
                            }
                            Task {
                                await populateImage()
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
                        }
                        .padding(10)
                        VStack(alignment: .leading, spacing: 5){
                            Text("Login Info")
                                .font(.system(size: 20))
                            TextField("Enter email (your's or parent's)", text: $email)
                                .textFieldStyle(.roundedBorder)
                            TextField("Enter a password", text: $password)
                                .textFieldStyle(.roundedBorder)
                        }
                        .padding(10)

                    }

                    Button("Submit Profile") {
                        createStudentObject()
                        modelData.registerStudentUser(){ isFound in
                            if isFound {
                                noUserFound = false
                                loginSuccessful = true
                            } else {
                                noUserFound = true
                                loginSuccessful = false
                            }
                        }
                    }
                        .buttonStyle(.bordered)
                        .padding(10)

                        Spacer()
//                    }

            .navigationDestination(isPresented: $loginSuccessful) {
                StudentAppPage()
            }
            .navigationTitle("Edit Profile")
//            .toolbar(.hidden, for: .navigationBar)
                
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
            modelData.studentUser.setUIImage(uiImage: uiImage!)
            modelData.uiImage = uiImage
            modelData.studentUser.populateInfo(personalInfo: studentInfo, loginInfo: loginInfo, musicalBackground: musicalBackground)
            
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

        let image = Image(systemName: "camera.fill")
//                            let image = Image(uiImage: modelData.uiImage ?? UIImage(systemName: "person.fill")!)
//        viewModel.setImageState(imageState: .success(image))

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
                            print("UIIMAGE IS NULL: " + String(modelData.uiImage == nil))
                            DispatchQueue.main.async {
                                let image2 = Image(uiImage: modelData.uiImage ?? UIImage(systemName: "camera.macro")!)
                                print("DOING SOMEThing")
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
    

