//
//  ProfilePageUI.swift
//  MusicAppSeniorProject
//
//  Created by Samuel Wang on 8/27/23.
//

import SwiftUI
enum Level: Hashable{
    case beginner, intermediate, advanced
    var title: String {
        switch self {
        case .beginner: return "Beginner"
        case .intermediate: return "Intermediate"
        case .advanced: return "Advanced"
        }
    }
    
    var color: Color {
        switch self {
            case .beginner: return Color.red
            case .intermediate: return Color.teal
            case .advanced: return Color.red
        }
    }
}
struct StudentProfilePageUI: View {
    @EnvironmentObject var modelData: TeacherModelData
    @Environment(\.dismiss) var dismiss
    let student: Student?
    @State var name: String = ""
    @State var yearsExperience: Int = 0
    @State var pricing: String = ""
    @State var location: String = ""
    @State var email: String = ""
    @State var skillLevel: Level = .beginner
    @State var priorPiecesPlayed: String = ""
    @State var schedule: String = ""
    @State var instrument: String = "Cello"
    @State var lessonLength: String = ""
    @State var teacherDesc: String = ""
    @State var ageDescription: String = ""
    @State var format: Int = 0
    @State var lessonFormat: String = ""


    var deviceHeight: CGFloat {
        UIScreen.main.bounds.height
    }
    var deviceWidth: CGFloat {
        UIScreen.main.bounds.width
    }
    var body: some View {

        ScrollView(showsIndicators: false){
            ZStack{
                VStack{
                    VStack{
                        Image("music_background")
                            .resizable()
                            .scaledToFill()
                            .frame(height: 2/5 * deviceHeight)
                            .mask(Rectangle().edgesIgnoringSafeArea(.top))
                            .offset(y: -50)

                        
                        
                    }.frame(maxHeight: 1/4 * deviceHeight)
                        .onAppear{
                            populateInfo(student: student ?? Student(name: "Bob"))
                        }
                    VStack(alignment: .center){
                        HStack{
                            Spacer()
                            ProfileImageFromURL(url: student?.imageURL ?? "", size: 90)
                                .scaleEffect(x: 1.75, y: 1.75)
                                .offset(y: -50)
                                .zIndex(4)

                            Spacer()
                        }
                        
                        HStack{
                            Button {
                                modelData.declineStudent(studentUID: student?.uid ?? "NONE")
                                dismiss()

                            } label: {
                                VStack{
                                    Image(systemName:"x.circle")
                                        .resizable()
                                        .frame(width: 50, height: 50)
                                        .foregroundColor(Color.red)
                                        .zIndex(6)
                                        .background(Color.white)
                                        .clipShape(Circle())
                                        
                                }
                            }
                            Spacer()
                                .frame(width: 30)
                            Button {
                                modelData.matchStudent(studentUID: student?.uid ?? "NONE")
                                dismiss()
                            } label: {
                                VStack{
                                    Image(systemName:"checkmark.circle")
                                        .resizable()
                                        .frame(width: 50, height: 50)
                                        .foregroundColor(Color.green)
                                        .zIndex(6)
                                        .background(Color.white)
                                        .clipShape(Circle())

                                        
                                }
                            }
                        }.background{
                            RoundedRectangle(cornerRadius: 30)
                                .fill(Color.white)
                                .shadow(radius: 5)
                                .padding(-10)
                                

                        }.padding(.top, -40)
                        Spacer()
                            .frame(height: 20)
                        Text(name)
                            .font(.system(size: 35))
                            .bold()
                        Spacer()
                            .frame(height: 10)
                        HStack{
                            Text(" " + String(skillLevel.title) + " ")
                                .font(.system(size: 20))

                                .foregroundColor(skillLevel.color)
                                .background{
                                    RoundedRectangle(cornerRadius: 10)
                                        .strokeBorder(skillLevel.color, lineWidth: 1)
                                        .background(skillLevel.color)
                                        .opacity(0.5)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                        .brightness(0.2)
                                    
                                }
                            Text(instrument)
                                .font(.system(size: 20))
                                .foregroundColor(Color.brown)
                                .background{
                                    RoundedRectangle(cornerRadius: 10)
                                        .strokeBorder(Color.brown, lineWidth: 1)
                                        .background(Color.brown)
                                        .opacity(0.5)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                        .brightness(0.2)
                                    
                                }
                            Text(ageDescription)
                                .font(.system(size: 20))
                                .foregroundColor(Color.teal)
                                .background{
                                    RoundedRectangle(cornerRadius: 10)
                                        .strokeBorder(Color.teal, lineWidth: 1)
                                        .background(Color.teal)
                                        .opacity(0.5)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                        .brightness(0.2)
                                    
                                }
                        }
                        Spacer()
                            .frame(height: 20)
                    
                        Divider()

                        VStack(alignment: .leading){
                            Spacer()
                            
                            HStack{
                                Image("years_of_exp_icon")
                                    .resizable()
                                    .renderingMode(.template)
                                    .foregroundColor(Color.blue)
                                    .frame(width: 30, height: 30)
                                Text(String(yearsExperience) + "  years of experience")
                                    .font(.system(size: 20))
                                
                            }
                            Spacer()
                                .frame(height: 10)
                            HStack{
                                Image(systemName: "house")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30, height: 30)
                                Text(location)
                                    .font(.system(size: 20))
                                
                                
                            }
                            HStack{
                                Image(systemName: "envelope")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30, height: 30)
                                Text(student?.email ?? "genericemail@gmail.com")
                                    .font(.system(size: 20))
                                
                                
                            }

                            
                            Spacer()
                                .frame(height: 10)
                        }
                    }
                    .zIndex(0)
                    .frame(width: 7/8 * deviceWidth)
                    .background(
                        RoundedRectangle(cornerRadius: 40)
                            .fill(Color.white)
                            .shadow(radius: 5)
                        
                    )
                    .offset(y: -50)
                    .padding(.bottom, -50)
                    Spacer()
                        .frame(height: 30)
                    VStack{
                        Spacer()
                            .frame(height: 15)
                        Text("Prior Pieces Played")
                            .font(.system(size: 35))
                            .bold()
                        Spacer()
                            .frame(height: 5)
                        Divider()
                        Text("They have played: " + priorPiecesPlayed)
                            .multilineTextAlignment(.leading)
                            .frame(width: 3/4 * deviceWidth)
                            .font(.system(size: 22, weight: .light, design: .rounded))
                            .foregroundColor(.gray)
                        Spacer()
                            .frame(height: 10)
                        
                    }.frame(width: 7/8 * deviceWidth)
                        .background(
                            RoundedRectangle(cornerRadius: 40)
                                .fill(Color.white)
                                .shadow(radius: 5)
                            
                        )
                    Spacer()
                        .frame(height: 35)
                    VStack(){
                        Spacer()
                            .frame(height: 15)
                            Text("About")
                                .font(.system(size: 35))
                                .bold()
                                .padding(-5)
                            
                            Divider()
                                .frame(width: 300)
                                .overlay(Color.orange)

                            Text(teacherDesc)
                                .multilineTextAlignment(.leading)
                                .frame(width: 3/4 * deviceWidth)
                                .font(.system(size: 22, weight: .light, design: .rounded))
                                .foregroundColor(.gray)
                            Spacer()
                                .frame(height: 10)
                            
                        
                    }.frame(width: 7/8 * deviceWidth)
                        .background(
                            RoundedRectangle(cornerRadius: 40)
                                .fill(Color.white)
                                .shadow(radius: 5)
                                .padding(.bottom, -10))
                    Spacer()
                        .frame(height: 35)
                    VStack{
                        Spacer()
                            .frame(height: 10)
                        Text("Lesson Format")
                            .font(.system(size: 35))
                            .bold()
                            .padding(-5)
                        Divider()
                            .frame(width: 300)
                        Spacer()
                            .frame(height: 10)
                        
                        VStack(alignment: .leading){
                            HStack{
                                Image(systemName: "person.circle")
                                    .resizable()
                                    .foregroundColor(.orange)
                                    .frame(width: 30, height: 30)
                                if(format == 0  || format == 2){
                                    Text(" In Person ")
                                        .foregroundColor(.green)
                                        .background{
                                            RoundedRectangle(cornerRadius: 10)
                                                .strokeBorder(Color.green, lineWidth: 1)
                                                .background(Color.green)
                                                .opacity(0.5)
                                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                                .brightness(0.2)
                                                
                                        }
                                }
                                if(format == 2){
                                    Text(" OR ")
                                        .foregroundColor(.red)
                                }
                                if(format == 1 || format == 2){
                                    Text(" Online ")
                                        .foregroundColor(.blue)
                                        .background{
                                            RoundedRectangle(cornerRadius: 10)
                                                .strokeBorder(Color.blue, lineWidth: 1)
                                                .background(Color.blue)
                                                .opacity(0.5)
                                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                                .brightness(0.2)
                                        }
                                }
                            }
                            

                            HStack{
                                Image(systemName: "calendar.circle")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(Color.teal)
                                Text(schedule)
                            }
                        }

                    }.frame(width: 7/8 * deviceWidth)
                        .background(
                            RoundedRectangle(cornerRadius: 40)
                                .fill(Color.white)
                                .shadow(radius: 5)
                                .padding(.bottom, -10))

                    Spacer(minLength: 500)
                }
                    .background(ScrollViewConfigurator {
                        $0?.bounces = false               // << here !!
                    })
                    .toolbarBackground(.hidden, for: .navigationBar)
                    .navigationBarBackButtonHidden(true) // Hide default button
                    .navigationBarItems(leading: CustomBackButton(dismiss: dismiss))
            }
//            Image("music_background")
//                .resizable()
//                .scaledToFill()
//                .edgesIgnoringSafeArea(.all)
//                .mask(Rectangle().edgesIgnoringSafeArea(.top))
            
        }
    }
    func determineSkillLevel(level : Int) -> Level{
        switch(level){
            case 0:
                return .beginner
            case 1:
                return .intermediate
            case 2:
                return .advanced
            default:
                return .beginner
        }
    }
    func populateInfo(student: Student){
        print("POPULATING INFO FOR: " + student.name)
        name = student.getStringProperty(key:"name", pairs: student.personalInfo)
        location = student.getStringProperty(key:"Location", pairs: student.personalInfo)
        let age = Int(student.getDoubleProperty(key: "age", pairs: student.personalInfo))
        ageDescription = determineAgeRange(age)
        yearsExperience = Int(student.getDoubleProperty(key: "Years Playing", pairs: student.musicalBackground))
        pricing = student.getStringProperty(key: "Pricing", pairs: student.musicalBackground)
        instrument = student.getStringProperty(key: "Instrument", pairs: student.musicalBackground)
        lessonLength = student.getStringProperty(key: "Lesson Length", pairs: student.musicalBackground) ?? "60"
        skillLevel = determineSkillLevel(level: Int(student.getStringProperty(key: "Skill Level", pairs: student.musicalBackground)) ?? 0)
        priorPiecesPlayed = student.getStringProperty(key: "Prior Pieces Played", pairs: student.musicalBackground) ?? "Twinkle Twinkle Little Star"
        schedule = student.getStringProperty(key: "Schedule", pairs: student.personalInfo) ?? "Twinkle Twinkle Little Star"
        teacherDesc = student.getStringProperty(key: "Teacher Description", pairs: student.personalInfo) ?? "Looking for a teacher who can instill good practice habits."
        lessonFormat = student.getStringProperty(key: "Format", pairs: student.personalInfo) ?? "In person"
        if(lessonFormat.contains("Online") && lessonFormat.contains("In")){
            format = 2
        }
        else if(lessonFormat.contains("In")){
            format = 1
        }
        else{
            format = 0
        }
    }
    func determineAgeRange(_ age: Int) -> String{
        if(age <= 5){
            return "5+"
        }
        else if(age > 5 && age <= 10){
            return "Under 10"
        }
        else if(age > 10 && age <= 15){
            return "Under 15"
        }
        else if(age > 15 && age <= 20 ){
            return "Under 20"
        }
        else{
            return "21+"
        }
        
    }
}

//struct StudentProfilePageUI_Previews: PreviewProvider {
//    static var previews: some View {
//        StudentProfilePageUI()
//    }
//}
