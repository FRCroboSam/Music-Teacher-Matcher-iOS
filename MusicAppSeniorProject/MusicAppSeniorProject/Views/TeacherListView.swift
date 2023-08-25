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
                                    ProfileImage(image: Image(uiImage:(uiImage ?? UIImage(systemName: "person.fill"))!), size: 100)
                                        .overlay(Circle()
                                            .strokeBorder(Color.white,lineWidth: 5)
                                        ).modifier(CenterModifier())
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


                                    }.modifier(CenterModifier())
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
                    .frame(height: 1/15 * deviceHeight)
                VStack(spacing: 0){
                    HStack{
                        Rectangle()
                            .fill(Color.white)
                            .frame(maxWidth: 1)
                            HStack {
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(.black)
                                TextField("Enter a teacher name", text: $searchTeacher)
                                    .foregroundColor(.white)
                                    .textContentType(.newPassword)
                                    .keyboardType(.asciiCapable)
                                    .autocorrectionDisabled()
                                    .listRowSeparator(.hidden)


                            }.modifier(customViewModifier(roundedCornes: 30, startColor: .blue, endColor: .purple, textColor: .black))

                        Rectangle()
                            .fill(Color.white)
                            .frame(maxWidth: 1)
                    }.fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .infinity)
                    Spacer(minLength: 10)
                    Divider()
                    List{
                        Section{
                            ForEach(Array(displayArray.enumerated()), id: \.element.id) { index, teacher in
                                NavigationLink{
                                    TeacherProfilePage(teacher: teacher, displayText: displayText, status: status, teacherImage: (teacher.uiImage ?? UIImage(systemName: "person.fill"))!)
                                } label:{
                                    HStack{
                                        ProfileImage(image: Image(uiImage: (teacher.uiImage ?? UIImage(systemName: "person.fill"))!), size: 50)
                                        VStack(alignment: .leading) {
                                            Spacer()
                                            Text(teacher.name).font(.system(size: 25))
                                            Text(teacher.instrument).font(.subheadline)
                                        }.foregroundColor(.black)
                                    }
                                   .padding(.top, index == 0 ? -30 : 0)


                                }
                            }
                        }
                        .listSectionSeparator(.hidden, edges: .top)
                        HStack{
                            Button("Log Out"){
                                modelData.logOut()
                                loggedOut = true
                            }
                            .modifier(CenterModifier())
                            .buttonStyle(BigButtonStyle())
                        }
                        .listRowInsets(EdgeInsets(top: -20, leading: 0, bottom: 0, trailing: 0))
                        .listRowSeparator(.hidden)
                    }
                    .frame( maxWidth: .infinity)
                    .edgesIgnoringSafeArea(.all)
                    .listStyle(GroupedListStyle())
                    .scrollContentBackground(.hidden)
                    Spacer()
                        .ignoresSafeArea(.all)
                        .frame(height: 1/10 * deviceHeight)
                        .listRowSeparator(.hidden)
                        .background(Color.orange)

                        .navigationDestination(isPresented: $loggedOut, destination: {
                            HomePage()
                        })
                }
                .background{
                    Color.white
                }.cornerRadius(20)
                .frame(maxWidth: .infinity)
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



