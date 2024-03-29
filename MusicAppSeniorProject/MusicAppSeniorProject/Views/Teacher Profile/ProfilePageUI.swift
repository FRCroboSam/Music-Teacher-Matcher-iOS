//
//  ProfilePageUI.swift
//  MusicAppSeniorProject
//
//  Created by Samuel Wang on 8/27/23.
//

import SwiftUI
//enum Status: Hashable{
//    case advanced, intermediate, advanced
//    var title: String {
//        switch self {
//        case .beginner: return "Beginner"
//        case .intermediate: return "Intermediate"
//        case .advanced: return "Advanced"
//        }
//    }
//    
//    var color: Color {
//        switch self {
//            case .beginner: return Color.red
//            case .intermediate: return Color.teal
//            case .advanced: return Color.red
//        }
//    }
//}
struct ProfilePageUI: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var modelData: ModelData
    let teacher: Teacher?
    let status: String
    @State var name: String = ""
    @State var instrument: String = ""
    @State var yearsExperience: Int = 0
    @State var musicDegree: String = ""
    @State var location: String = ""
    @State var levels: String = ""
    @State var studentDesc: String = ""
    @State var about: String = ""
    @State var email: String = ""
    @State var lessonFormat: String = ""
    @State var lessonLength: Int = 60
    @State var pricing: String = ""
    @State var schedule: String = ""
    @State var isFavorite: Bool = false
    @State var format: Int = 0
    @State var canRequest: Bool = false
    @State var matchText: String = "Contact at: "
    @State var pricingText: String = ""
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
                            .edgesIgnoringSafeArea(.all)
                            .offset(y: -50)
                        
                        
                    }.frame(maxHeight: 1/4 * deviceHeight)
                        .onAppear{
                            populateInfo(teacher: teacher ?? Teacher(name: "bob"))
                        }
                    VStack(alignment: .center){
                        HStack{
                            Spacer()
                            ProfileImageFromURL(url: teacher?.imageURL ?? "", size: 90)
                                .scaleEffect(x: 1.75, y: 1.75)
                                .offset(y: -80)
                                .zIndex(4)

                            Spacer()
                        }

                    
                         StatusLabelView(text: status)
                             .padding(.top, -60)

                        


                        Text(name)
                            .lineLimit(1)
                            .minimumScaleFactor(0.01)
                            .font(.system(size: 35))
                            .bold()
                            .padding(.bottom, 5)
                            .padding(.top, -10)
                            .frame(maxWidth: 3/4 * deviceWidth)

                        HStack{
                            Text(instrument + " teacher")
                                .font(.system(size: 20))
                                .italic()
                                .foregroundColor(.gray)
                                .offset(y: -7)
                        }
                        
//
//                            .offset(y: -60)
//                            .padding(.bottom, -80)
                       
                        Divider()
                            .padding(.top, -10)
                        VStack(alignment: .leading){
                            Spacer()
                            HStack{
                                Image("years_of_exp_icon")
                                    .resizable()
                                    .renderingMode(.template)
                                    .foregroundColor(Color.blue)
                                    .frame(width: 30, height: 30)
                                Text(String(yearsExperience) + " years of experience")
                                    .font(.system(size: 20))
                                
                            }
                            Spacer()
                                .frame(height: 10)
                            HStack{
                                Image(systemName: "graduationcap.fill")
                                    .resizable()
                                    .foregroundColor(Color.brown)
                                    .frame(width: 30, height: 30)
                                Text(musicDegree)
                                    .font(.system(size: 20))
                                
                            }
                            HStack{
                                Image(systemName: "house")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30, height: 30)
                                Text(location)
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
                    .padding(.bottom, -40)
                    Spacer()
                        .frame(height: 30)
                    VStack{
                        Spacer()
                            .frame(height: 15)
                        Text("Preferred Students")
                            .font(.system(size: 35))
                            .bold()
                        Spacer()
                            .frame(height: 5)
                        HStack{
                            if(levels.contains("Beginner")){
                                Text(" Beginner ")
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
                            if(levels.contains("Intermediate")){
                                Text(" Intermediate ")
                                    .foregroundColor(.teal)
                                    .background{
                                        RoundedRectangle(cornerRadius: 10)
                                            .strokeBorder(Color.teal, lineWidth: 1)
                                            .background(Color.teal)
                                            .opacity(0.5)
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                            .brightness(0.2)

                                    }
                            }
                            if(levels.contains("Advanced")){
                                Text(" Advanced ")
                                    .foregroundColor(.red)
                                    .background{
                                        RoundedRectangle(cornerRadius: 10)
                                            .strokeBorder(Color.red, lineWidth: 1)
                                            .background(Color.red)
                                            .opacity(0.5)
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                            .brightness(0.2)
                                    }
                            }
                        }
                        Divider()
                        Text(studentDesc)
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
                        .frame(height: 30)
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

                            Text(about)
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
                        .frame(height: 40)
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
                                    if(format == 0  || format == 1){
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

//                                    Spacer()

                            }
                            
                            HStack{
                                Image(systemName: "dollarsign.circle")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(Color.green)
                                Text(pricingText)
                            }
                            HStack{
                                Image(systemName: "calendar.circle")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(Color.teal)
                                Text(schedule)
                            }
                            HStack{
                                Image(systemName: "clock.circle")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(Color.purple)
                                Text(String(lessonLength) + " minute lessons")
                            }
                        }



                    }.frame(width: 7/8 * deviceWidth)
                        .background(
                            RoundedRectangle(cornerRadius: 40)
                                .fill(Color.white)
                                .shadow(radius: 5)
                                .padding(.bottom, -10))
                    Spacer(minLength: 50)
                        
                    if(status == "Matched"){
                        Text(matchText)
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color(UIColor.systemGray2))
                            .background{
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.white)
                                    .shadow(radius: 5)
                                    .padding(-10)
                                    .overlay{
                                        RoundedRectangle(cornerRadius: 10)
                                            .strokeBorder(Color.yellow, lineWidth: 1)
                                            .padding(-10)
                                    }
                            }
                            .frame(maxWidth: 2/3 * deviceWidth)
                    }
                    else if(status == "Requested"){
                       Button("Cancel your request"){
                           modelData.cancelTeacherRequest(teacherId: teacher?.uid ?? "No UID", score: teacher?.score ?? -2300)
                           dismiss()
                       }.buttonStyle(BigButtonStyle(color: .red))
                        .scaleEffect(x: 0.75, y: 0.75)
                   }
                    else{
                        HStack{
                            Button("Request"){
                                modelData.requestTeacher(teacherId: teacher?.uid ?? "No UID", score: teacher?.score ?? -10000)
                                dismiss()
                            }.buttonStyle(BigButtonStyle(color: .green))
                                .scaleEffect(x: 0.75, y: 0.75)
                            Button("Decline"){
                                modelData.declineTeacher(teacherId: teacher?.uid ?? "No UID")
                                dismiss()
                            }.buttonStyle(BigButtonStyle(color: .red))
                                .scaleEffect(x: 0.75, y: 0.75)
                        }
                        
                    }
                }
                    .background(ScrollViewConfigurator {
                        $0?.bounces = false               // << here !!
                    })
            }

            .toolbarBackground(.hidden, for: .navigationBar)
            .navigationBarBackButtonHidden(true) // Hide default button
            .navigationBarItems(leading: CustomBackButton(dismiss: dismiss))

//            Image("music_background")
//                .resizable()
//                .scaledToFill()
//                .edgesIgnoringSafeArea(.all)
//                .mask(Rectangle().edgesIgnoringSafeArea(.top))
            
        }
    }
    func populateInfo(teacher: Teacher){
        print("STATUS: " + status)
        name = teacher.name
        location = teacher.getStringProperty(key:"Location", pairs: teacher.teacherInfo)

        yearsExperience = Int(teacher.getDoubleProperty(key: "Years Teaching", pairs: teacher.musicalBackground))
        pricing = teacher.getStringProperty(key: "Pricing", pairs: teacher.lessonInfo)
        if(pricing.isNumeric){
            pricingText = "$" + pricing + " per lesson"
        }
        else{
            pricingText = pricing
        }
        instrument = teacher.getStringProperty(key: "Instrument", pairs: teacher.musicalBackground)
        lessonLength = Int(teacher.getDoubleProperty(key: "Lesson Length", pairs: teacher.lessonInfo)) ?? 60
        levels = (teacher.getStringProperty(key: "Levels", pairs: teacher.lessonInfo))
        about = teacher.getStringProperty(key: "Teaching Style", pairs: teacher.musicalBackground) ?? "Specializing in classical pedagogy with a focus on relaxed, effortless technique."
        studentDesc = teacher.getStringProperty(key: "Student Description", pairs: teacher.musicalBackground) ?? "Student should know pieces like Twinkle Twinkle Little Star "
        musicDegree = teacher.getStringProperty(key: "Musical Degree", pairs: teacher.musicalBackground) ?? "Student should know pieces like Twinkle Twinkle Little Star "
        if(musicDegree == "No" || musicDegree == "Generic User"){
            musicDegree = "No musical degree."
        }
        lessonFormat = teacher.getStringProperty(key: "Format", pairs: teacher.lessonInfo) ?? "In person"
        email = teacher.getStringProperty(key: "email", pairs: teacher.loginInfo) ?? "In person"
        if(lessonFormat.contains("Online") && lessonFormat.contains("In")){
            format = 2
        }
        else if(lessonFormat.contains("In")){
            format = 1
        }
        else{
            format = 0
        }
        schedule = teacher.getStringProperty(key: "Schedule", pairs: teacher.lessonInfo)
        matchText = "Contact " + teacher.name + " at " + email + " to schedule an appointment!"

    }
}

//struct ProfilePageUI_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfilePageUI(teacher: Teacher(name: "BOB"))
//    }
//}
struct ScrollViewConfigurator: UIViewRepresentable {
    let configure: (UIScrollView?) -> ()
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        DispatchQueue.main.async {
            configure(view.enclosingScrollView())
        }
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}
extension UIView {
    func enclosingScrollView() -> UIScrollView? {
        var next: UIView? = self
        repeat {
            next = next?.superview
            if let scrollview = next as? UIScrollView {
                return scrollview
            }
        } while next != nil
        return nil
    }
}

struct StatusLabelView: View {
    let text: String
    func getColor() -> Color{
        if(text == "Available"){
           return .green
        }
        if(text == "Requested"){
           return .teal
        }
        if(text == "Matched"){
           return .yellow
        }
        return .green
    }
    var body: some View {
        
        HStack {
            SparklesImage()
                .foregroundColor(getColor())
            Text(text)
                .font(.system(size: 30))
                .italic()
                .bold()
                .foregroundColor(getColor())
            SparklesImage()
                .foregroundColor(getColor())
        }
        .background {
            RoundedRectangle(cornerRadius: 30)
                .fill(Color.white)
                .shadow(radius: 5)
                .padding(-10)
//                .overlay {
//                    RoundedRectangle(cornerRadius: 30)
//                        .stroke(Color.yellow)
//                        .padding(-10)
//                }
        }
    }
}
