//
//  CustomTabBar.swift
//  TestProject0105
//
//  Created by Federico on 01/05/2022.
//

import SwiftUI

enum Tab: String, CaseIterable {
    case available
    case requested
    case matched
    case editProfile
}

struct TabBarView: View {
    @Binding var selectedTab: Tab
    @Binding var isTeacher: Bool
    @Binding var modelData: ModelData
//    private var fillImage: String {
//        switch selectedTab{
//            case .available:
//                return "person.crop.circle.fill.badge.plus"
//            case .requested:
//                return "person.crop.circle.badge.questionmark"
//            case .matched:
//                return "person.crop.circle.badge.checkmark"
//            case .editProfile:
//                return "person.crop.circle.fill"
//        }
//    }
    private var tabColor: Color {
        switch selectedTab {
        case .available:
            return .blue
        case .requested:
            return .purple
        case .matched:
            return .green
        case .editProfile:
            return .teal
        }
    }
    private var tabNotifs: [Int]
    func getImageName(tab: Tab) -> String{
        switch tab {
            case .available:
                return "person.crop.circle.fill.badge.plus"
            case .requested:
                return "person.crop.circle.badge.questionmark"
            case .matched:
                return "person.crop.circle.badge.checkmark"
            case .editProfile:
                return "person.crop.circle.fill"
        }
    }

    
    var body: some View {
        VStack {
            HStack {
                ForEach(Tab.allCases, id: \.rawValue) { tab in
                    let show = (!isTeacher && tab == .available) || (tab != .available)
                    let name = getImageName(tab: tab)
                    if(show){
                        Spacer()
                        Image(systemName: name)
                            .scaleEffect(tab == selectedTab ? 1.25 : 1.0)
                            .foregroundColor(tab == selectedTab ? tabColor : .gray)
                            .font(.system(size: 20))
                            .onTapGesture {
                                withAnimation(.easeInOut(duration: 0.1)) {
                                    selectedTab = tab
                                }
                            }
                        Spacer()
                    }

                }
            }
            .frame(width: nil, height: 60)
            .background(.orange)
            .cornerRadius(20)
            .padding()
        }
    }
}

//struct CustomTabBar_Previews: PreviewProvider {
//    static var previews: some View {
//        TabBarView(selectedTab: .constant(.requested), isTeacher: .constant(false), modelData: ModelData())
//    }
//}

struct TabBarItem<Content: View>: View {
    let tab: Tab
    let isSelected: Bool
    let onTap: () -> Void
    let tabColor: Color
    let imageName: String
    
    var body: some View {
        Image(systemName: imageName)
            .scaleEffect(isSelected ? 1.25 : 1.0)
            .foregroundColor(isSelected ? tabColor : .gray)
            .font(.system(size: 20))
            .onTapGesture(perform: onTap)
    }
}

