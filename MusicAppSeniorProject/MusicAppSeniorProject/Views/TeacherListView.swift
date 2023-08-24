//
//  TeacherListView.swift
//  MusicAppSeniorProject
//
//  Created by Samuel Wang on 6/19/23.
//

import SwiftUI

enum teacherType{
    case AVAILABLE, REQUESTED, DECLINED, MATCHED
}
struct TeacherListView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var modelData: ModelData
    @Binding var displayArray: [Teacher]
    @Binding var uiImage: UIImage?
    let status: String
    let displayText: String
    @State private var loggedOut = false
    @State private var showInfo  = false
    @State private var searchTeacher = ""
    var deviceHeight: CGFloat {
        UIScreen.main.bounds.height
    }
    var deviceWidth: CGFloat {
        UIScreen.main.bounds.width
    }
    var body: some View {
        NavigationStack{
            VStack(spacing: 0){
                Spacer()
                    .frame(height: 1/15 * deviceHeight)
                ZStack{
                    VStack(spacing: 10){
                        HStack{
                            Button("Log Out"){
                                modelData.logOut()
                                loggedOut = true
                            }
                            .scaleEffect(x:1/2, y: 1/2)
                            .modifier(CenterModifier())
                            .buttonStyle(BigButtonStyle())
//                            Spacer(minLength: 2/3 * deviceWidth)
                        }
                        ProfileImage(image: Image(uiImage:(uiImage ?? UIImage(systemName: "person.fill"))!), size: 100)
                            .overlay(Circle()
                                .strokeBorder(Color.white,lineWidth: 5)
                            )
                        HStack{
                            Text(" " + status + " ")
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
                            
                            
                        }
//                        HStack {
//                            Image(systemName: "magnifyingglass")
//                            SecureField("Search", text: $searchTeacher)
//                                .foregroundColor(.white)
//                                .textContentType(.newPassword)
//                                .keyboardType(.asciiCapable)
//                                .autocorrectionDisabled()
//
//                        }.modifier(customViewModifier(roundedCornes: 20, startColor: .orange, endColor: .pink, textColor: .white))
                    }
                    if(showInfo){
                        //                        VStack{
                        //                            Spacer()
                        ZStack{
                            RoundedRectangle(cornerRadius:10).strokeBorder(Color.black, lineWidth: 3).background(Color.white)
                                .padding(20)
                            
                            Text(" " + displayText + " ")
                                .padding(25)
                                .font(.system(size: 30))
                                .minimumScaleFactor(0.01)
                            
                        }
                        //                        }
                        
                        //
                        //                            .background(RoundedRectangle(cornerRadius: 4).strokeBorder(Color.black, lineWidth: 2))
                        //                            .font(.system(size: 500))
                        //                            .minimumScaleFactor(0.01)
                        //                            .padding(20)
                        
                    }
                }.onTapGesture {
                    showInfo = false
                }
                Spacer(minLength: 30)
                List{
                    Section{
                        ForEach(displayArray) { teacher in
                            NavigationLink{
                                TeacherProfilePage(teacher: teacher, displayText: displayText, status: status, teacherImage: (teacher.uiImage ?? UIImage(systemName: "person.fill"))!)
                            } label:{
                                HStack{
                                    ProfileImage(image: Image(uiImage: (teacher.uiImage ?? UIImage(systemName: "person.fill"))!), size: 50)
                                    VStack(alignment: .leading) {
                                        Spacer()
                                        Text(teacher.name).font(.title)
                                        Text(teacher.instrument).font(.subheadline)
                                    }.foregroundColor(.white)
                                }
                                
                            }
                            .listRowBackground(
                                RoundedRectangle(cornerRadius: 20)
                                //                                    .background(.clear)
                                    .foregroundColor(Color.orange)
                                    .padding(
                                        EdgeInsets(
                                            top: 5,
                                            leading: 0,
                                            bottom: 5,
                                            trailing: 0
                                        )
                                    )
                            )
                            .listRowSeparator(.hidden)
                            
                            
                        }
                        
                    }
                    .listRowSeparator(.hidden)
                    
//                    Spacer()
//                        .listRowBackground(Color.teal)
//                        .frame(height: 1/25 * deviceHeight)
                    //                    Spacer(minLength: 100)
                }
                .scrollContentBackground(.hidden)
                .frame(maxWidth: 7/8 * deviceWidth)
                .background{
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.teal)
                }
                Spacer()
                    .ignoresSafeArea(.all)
                    .frame(height: 1/7 * deviceHeight)
            }
                .background{
                    Image("music_background")
                        .resizable()
                        .scaledToFill()
                        .edgesIgnoringSafeArea(.all)
                        .aspectRatio(contentMode: .fill)
                }
                
                .navigationDestination(isPresented: $loggedOut, destination: {
                    HomePage()
                })
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
