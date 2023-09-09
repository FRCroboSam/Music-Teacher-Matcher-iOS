//
//  TeacherListView.swift
//  MusicAppSeniorProject
//
//  Created by Samuel Wang on 6/19/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct StudentListView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var modelData: TeacherModelData
    @EnvironmentObject var viewModel: ProfileModel

    @Binding var displayArray: [Student]
    @Binding var uiImage: UIImage?
    let status: String
    let displayText: String
    @State private var loggedOut = false
    @State private var showInfo  = false
    @State private var searchStudent = ""
    @State private var listHeight = 500.0
    @State private var offset: Double = 0.0

    var deviceHeight: CGFloat {
        UIScreen.main.bounds.height
    }
    var deviceWidth: CGFloat {
        UIScreen.main.bounds.width
    }
    func log(_ log: String) -> EmptyView {
        print("** \(log)")
        return EmptyView()
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
                                        Text(" " + status + " ")
                                            .scaledToFill()
                                            .lineLimit(1)
                                            .font(.custom("MarkerFelt-Wide", size: 40))
                                            .foregroundColor(.white)
                                            .minimumScaleFactor(0.01)
                                        
                                            .background(Color.teal)
                                            .clipShape(RoundedRectangle(cornerRadius:10))
                                            .overlay(alignment: .topTrailing){
                                                Button{
                                                    showInfo.toggle()
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
                                TextField("Enter a student name", text: $searchStudent)
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
                                            Text("No " + status + " students at this time.")
                                                .font(.system(size: 20))
                                                .italic()
                                                .modifier(CenterModifier())
                                                .foregroundColor(Color(UIColor.systemGray3))
                                                .listRowSeparator(.hidden)
                                        }
                                        else{
                                            ForEach(Array(displayArray.enumerated()), id: \.element.id) { index, student in
                                                
                                                if(student.name.contains(searchStudent) || searchStudent == ""){
                                                    NavigationLink{
                                                        StudentProfilePageUI(student: student)
                                                        //                                                TeacherProfilePage(teacher: teacher, displayText: displayText, status: status, teacherImage: (teacher.uiImage ?? UIImage(systemName: "person.fill"))!)
                                                    } label:{
                                                        HStack{
                                                            
                                                            if(student.imageURL.count > 5 && student.imageURL != "NONE"){
                                                                ProfileImageFromURL(url: student.imageURL, size: 50)
                                                                
                                                            }
                                                            else{
                                                                CircularProfileImage(imageState: .empty, size: 50)
                                                            }
                                                            VStack(alignment: .leading) {
                                                                Text(student.name).font(.system(size: 25))
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
                                                modelData.reset()
                                                viewModel.setImageState(imageState: .failure(SampleError.errorRequired))

                                            }
                                        }
                                        .modifier(CenterModifier())
                                        .buttonStyle(BigButtonStyle(color: .red))
                                    }
                                    .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                                    .listRowSeparator(.hidden)
                                }
                                .edgesIgnoringSafeArea(.all)
                                .listStyle(GroupedListStyle())
                                .scrollContentBackground(.hidden)
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
                if(showInfo && status == "Requested Students"){
                    VStack(alignment: .leading){
                        
                        Text("The app shows you all students who have requested you.")
                            .lineLimit(2, reservesSpace: true)
                            .modifier(CenterModifier())
                            .foregroundColor(Color(UIColor.systemGray3))
                        Divider()
                        HStack{
                            Image(systemName:"checkmark.circle")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(Color.green)
                                .zIndex(6)
                                .background(Color.white)
                                .clipShape(Circle())
                            Text("Matches with the student so they can contact you for an appointment ")
                                .lineLimit(2, reservesSpace: true)
                                .foregroundColor(Color(UIColor.systemGray2))
                        }
                        HStack{
                            Image(systemName:"x.circle")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(Color.red)
                                .zIndex(6)
                                .background(Color.white)
                                .clipShape(Circle())
                            Text("Not interested, explore other students")
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


