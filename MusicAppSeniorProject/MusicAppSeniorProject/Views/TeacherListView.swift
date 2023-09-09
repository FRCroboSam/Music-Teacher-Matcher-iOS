//
//  TeacherListView.swift
//  MusicAppSeniorProject
//
//  Created by Samuel Wang on 6/19/23.
//

import SwiftUI
import SDWebImageSwiftUI
enum teacherType{
    case AVAILABLE, REQUESTED, DECLINED, MATCHED
}
struct TeacherListView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var viewModel: ProfileModel
    @EnvironmentObject var modelData: ModelData
    @Binding var displayArray: [Teacher]
    let status: String
    @Binding var uiImage: UIImage?
    let displayText: String
    @State private var loggedOut = false
    @State private var showInfo  = false
    @State private var searchTeacher = ""
    @State private var listHeight = 500.0
    @State private var offset: Double = 0.0
    @State private var isAppearing: Bool = false
    var deviceHeight: CGFloat {
        UIScreen.main.bounds.height
    }
    var deviceWidth: CGFloat {
        UIScreen.main.bounds.width
    }
    func getColor() -> Color{
        if(status == "Available"){
           return .green
        }
        if(status == "Requested"){
           return .teal
        }
        if(status == "Matched"){
           return .yellow
        }
        return .green
    }
    var body: some View {
        NavigationStack{
            ZStack{
                VStack(spacing: 0){
                    GeometryReader{ geometry in
                        ZStack{
                            VStack(alignment: .center, spacing: 10){
                                Section{
                                    //TODO: REIMPLEMENT IMAGE STRUCTURE TO USE WEBIMAGE
                                    ProfileImage(image: Image(uiImage:(uiImage ?? UIImage(systemName: "person.fill"))!), size: 100)
                                        .overlay(Circle()
                                            .strokeBorder(Color.white,lineWidth: 5)
                                        ).modifier(CenterModifier())
                                        .padding(.top, max(30, 1/15 * deviceHeight))
                                        .padding(.bottom, max(10, 0.0117 * deviceHeight))
                            
                                    HStack{
                                        Text(" " + status + " Teachers ")
                                            .scaledToFill()
                                            .lineLimit(1)
                                            .font(.custom("MarkerFelt-Wide", size: 40))
                                            .minimumScaleFactor(0.01)
                                            .foregroundColor(.white)
                                            .background(getColor())
                                            .clipShape(RoundedRectangle(cornerRadius:10))
                                            .overlay(alignment: .topTrailing){
                                                if(status == "Available"){
                                                    Button{
                                                        withAnimation(.easeInOut(duration: 0.2)){
                                                            showInfo.toggle()
                                                        }
                                                    }label:{
                                                        Image(systemName: "info.circle")
                                                            .resizable()
                                                            .frame(width: 20, height: 20)
                                                            .background {
                                                                Circle().fill(
                                                                    Color.white
                                                                )
                                                            }
                                                    }.offset(x: 2, y: -15)
                                                }
                                                
                                            }
                                        
                                        
                                    }.frame(maxWidth: 10/11 * deviceWidth)
                                        .onTapGesture {
                                            withAnimation(.easeInOut(duration: 0.2)){
                                                showInfo.toggle()
                                            }
                                        }
                                }
                            }
                        }
                    }.frame(maxHeight: 1/5 * deviceHeight)
                        .onTapGesture {
                            showInfo = false
                        }

                        .background{
                            Image("music_background")
                                .resizable()
                                .scaledToFill()
                                .edgesIgnoringSafeArea(.all)
                                .aspectRatio(contentMode: .fill)
                        }
                    
                    Spacer()
                        .frame(height: min(0.1 * UIScreen.main.bounds.height, 70))
                    ZStack{
                        VStack(spacing: 0){
                            //                        Section{
                            HStack {
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(.black)
                                TextField("Enter a teacher name", text: $searchTeacher)
                                    .foregroundColor(.black)
                                    .textContentType(.newPassword)
                                    .keyboardType(.asciiCapable)
                                    .autocorrectionDisabled()
                                    .listRowSeparator(.hidden)
                                
                                
                            }.modifier(customViewModifier(roundedCornes: 30, startColor: Color(UIColor.systemGray5), endColor: Color(UIColor.systemGray5), textColor: .black, ratio: 0.925))
                                .padding(.top, 10)
                                .offset(y: 20)
                            
                            //TODO: TRY EMBEDDING THE LIST IN A ZSTACK THAT WAY YOU CAN USE THE FRAME THING AND ITLL ONLY AFFECT THE LIST
                            //make the offset however big divider offset is and frame big enough to cover between divider and search
                            Rectangle()
                                .offset(y:20)
                                .frame(maxHeight: 30)
                                .foregroundColor(Color.white)
                                .zIndex(4)
                            Divider()
                                .offset(y:20)
                                .zIndex(6)
                            //                        }
                            ScrollViewReader{ proxy in
                                
                                    List{
                                        Section{
                                            if(displayArray.count < 1){
                                                Text("No " + status + " teachers at this time.")
                                                    .font(.system(size: 20))
                                                    .italic()
                                                    .modifier(CenterModifier())
                                                    .foregroundColor(Color(UIColor.systemGray3))
//                                                    .background{
//                                                        RoundedRectangle(cornerRadius: 20)
//                                                            .fill(Color.white)
//                                                            .shadow(radius: 10)
//                                                            .padding(-10)
//                                                            .overlay{
//                                                                RoundedRectangle(cornerRadius: 20)
//                                                                    .stroke(Color(UIColor.lightGray), lineWidth: 1)
//                                                                    .padding(-10)
//                                                            }
//                                                    }
                                                    .listRowSeparator(.hidden)
                                            }
                                            else{
                                                ForEach(Array(displayArray.enumerated()), id: \.element.id) { index, teacher in
                                                    if(teacher.name.contains(searchTeacher) || searchTeacher == ""){
                                                        NavigationLink{
                                                            ProfilePageUI(teacher: teacher, status: status)
                                                        } label:{
                                                            HStack{
                                                                if(teacher.imageURL.count > 8){
                                                                    ProfileImageFromURL(url: teacher.imageURL, size: 50)
                                                                }
                                                                else{
                                                                    CircularProfileImage(imageState: .empty, size: 50)
                                                                    
                                                                }
                                                                VStack(alignment: .leading) {
                                                                    Spacer()
                                                                    Text(teacher.name).font(.system(size: 25))
                                                                    Text(teacher.instrument).font(.subheadline)
                                                                }.foregroundColor(.black)
                                                            }
                                                            .buttonStyle(BigButtonStyle())
                                                            .swipeActions {
                                                                Button("Decline") {
                                                                    print("Awesome!")
                                                                }
                                                                .tint(.red)
                                                            }
                                                        }.id(index)
                                                        
                                                    }
                                                } .onMove { from, to in
                                                    
                                                    displayArray.move(fromOffsets: from, toOffset: to)
                                                }
                                            }
                                            
                                        } //header: {
                                        //                                Text(displayText)
                                        //                                    .font(.system(size: 20))
                                        //                                    .textCase(.none)
                                        //                            }
                                        .listSectionSeparator(.hidden, edges: .top)
                                        HStack{
                                            Button("Log Out"){
                                                modelData.logOut()
                                                loggedOut = true
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                                    viewModel.setImageState(imageState: .failure(SampleError.errorRequired))
                                                    modelData.reset()
                                                }
                                            }
                                            .modifier(CenterModifier())
                                            .buttonStyle(BigButtonStyle(color: .purple))
                                            .padding(.top, -20)
                                        }
                                        .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                                        .listRowSeparator(.hidden)
                                    }
                                    .edgesIgnoringSafeArea(.all)
                                    .listStyle(GroupedListStyle())
                                    .scrollContentBackground(.hidden)
                                    .animation(.easeInOut(duration: 1.0), value: UUID())

                                
                                Spacer()
                                    .ignoresSafeArea(.all)
                                    .frame(height: 30)
                                    .listRowSeparator(.hidden)
                                
                                    .navigationDestination(isPresented: $loggedOut, destination: {
                                        HomePage()
                                    })

                            }
                            .zIndex(2)
                        }
                        
                        .background{
                            Color.white
                        }.cornerRadius(20)
                            .frame(width: deviceWidth, height: 2/3 * deviceHeight)
                            .contentShape(Rectangle())
                            .zIndex(3)
                        
                    }.padding(.top, 20)
                    
                }
                if(showInfo && status == "Available"){
                    VStack(alignment: .leading){

                        Text("The app shows you 5 new teachers at a time.")
                            .lineLimit(2, reservesSpace: true)
                            .modifier(CenterModifier())
                            .foregroundColor(Color(UIColor.systemGray2))
                        Divider()
                        HStack{
                            Text("If you request a teacher, the teacher can either match or decline your request.")
                                .lineLimit(2, reservesSpace: true)
                                .foregroundColor(Color(UIColor.systemGray2))
                        }
                        Divider()
                        HStack{
                            Text("Once matched, you can contact the teacher to set up an appointment!")
                                .lineLimit(2, reservesSpace: true)
                                .foregroundColor(Color(UIColor.systemGray2))
                        }
                        Text("(Tap to Dismiss)")
                            .lineLimit(2)
                            .modifier(CenterModifier())
                            .italic()
                            .foregroundColor(Color(UIColor.systemGray3))
                        
                        
                    }
                    .background{
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white)
                            .shadow(radius: 10)
                            .padding(-10)
                            .overlay{
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color(UIColor.lightGray), lineWidth: 1)
                                    .padding(-10)
                            }

                    }.zIndex(30)
                    .frame(maxWidth: 3/4 * deviceWidth, maxHeight: 500)
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.2)){
                            showInfo = false
                        }
                    }
                }
            }
        }
    }
//struct TeacherListView_Previews: PreviewProvider {
//    static var previews: some View {
////        TeacherListView()
//    }
}
struct CenterModifier: ViewModifier {
    func body(content: Content) -> some View {
        HStack {
            Spacer()
            content
            Spacer()
        }
    }
}



struct FitToWidth: ViewModifier {
    var fraction: CGFloat = 1.0
    func body(content: Content) -> some View {
        GeometryReader { g in
        content
            .font(.system(size: 1000))
            .minimumScaleFactor(0.005)
            .lineLimit(1)
            .frame(width: g.size.width*self.fraction)
        }
    }
}
