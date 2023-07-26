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
    @EnvironmentObject var modelData: ModelData
    @Binding var displayArray: [Teacher]
    @Binding var uiImage: UIImage?
    let status: String
    let displayText: String
    @State private var loggedOut = false
    @State private var showInfo  = false
    @State private var isTapped = false
    var body: some View {
            VStack{
                ZStack{
                    VStack{
                        ProfileImage(image: Image(uiImage:(uiImage ?? UIImage(systemName: "person.fill"))!), size: 100)
                            .overlay(Circle()
                                .strokeBorder(Color.white,lineWidth: 5)
                            )
                        HStack{
                            Text(" " + status + " ")
                                .lineLimit(1)
                                .font(.system(size: 100))
                                .minimumScaleFactor(0.01)
                            
                                .background(Color.white)
                                .clipShape(RoundedRectangle(cornerRadius:40))
                            Button{
                                showInfo.toggle()
                            }label:{
                                Image(systemName: "questionmark.circle.fill")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .background {
                                        Circle().fill(
                                            Color.white
                                        )
                                    }
                            }
                            
                            
                        }

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

                List(displayArray) { teacher in
                    NavigationLink{
                        TeacherProfilePage(teacher: teacher, displayText: displayText, status: status, teacherImage: (teacher.uiImage ?? UIImage(systemName: "person.fill"))!)
                    } label:{
                        HStack{
                            ProfileImage(image: Image(uiImage: (teacher.uiImage ?? UIImage(systemName: "person.fill"))!), size: 50)
                            VStack(alignment: .leading) {
                                Spacer()
                                Text(teacher.name).font(.title)
                                Text(teacher.instrument).font(.subheadline)
                            }
                        }

                    }
                }

            }.background{
                Image("music_background")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .aspectRatio(contentMode: .fill)
            }

        
}

//struct TeacherListView_Previews: PreviewProvider {
//    static var previews: some View {
////        TeacherListView()
//    }
}
