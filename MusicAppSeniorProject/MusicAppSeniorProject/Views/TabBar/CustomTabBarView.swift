//
//  CustomTabBarView.swift
//  SwiftfulThinkingAdvancedLearning
//
//  Created by Nick Sarno on 9/6/21.
//

import SwiftUI
struct ImageOverlay: View {
    var numNotifs: Int
    var body: some View {
        if(numNotifs > 0){
            ZStack {
                GeometryReader { geometry in
                    let size = min(geometry.size.width, geometry.size.height)
                    
                    Color.red
                        .cornerRadius(size / 2)
                    if(numNotifs <= 9){
                        Text(String(numNotifs))
                            .font(.system(size: size * 0.6))
                            .foregroundColor(.white)
                            .frame(width: size, height: size)
                            .background(Color.clear) // Make sure the text itself doesn't exceed the circular background
                    }
                    else{
                        Text("9+")
                            .font(.system(size: size * 0.5))
                            .foregroundColor(.white)
                            .frame(width: size, height: size)
                            .background(Color.clear) // Make sure the text itself doesn't exceed the circular background
                    }

                }
            }
            .frame(width: 15, height: 15)
            .cornerRadius(10.0)
            .offset(x:10)
            }
        }


}
struct CustomTabBarView: View {
    @EnvironmentObject var teacherModelData: TeacherModelData
    @EnvironmentObject var modelData: ModelData

    let tabs: [TabBarItem]
    @Binding var selection: TabBarItem
    @Namespace private var namespace
    @State var localSelection: TabBarItem
    
    var body: some View {
        tabBarVersion2
            .onChange(of: selection, perform: { value in
                withAnimation(.easeInOut) {
                    localSelection = value
                }
            })
    }
}

//struct CustomTabBarView_Previews: PreviewProvider {
//
//    static let tabs: [TabBarItem] = [
//        .home, .favorites, .profile
//    ]
//
//    static var previews: some View {
//        VStack {
//            Spacer()
//            CustomTabBarView(tabs: tabs, selection: .constant(tabs.first!), localSelection: tabs.first!)
//        }
//    }
//}

extension CustomTabBarView {
    
    private func tabView(tab: TabBarItem) -> some View {
        VStack {
            Image(systemName: tab.iconName)
                .font(.subheadline)
            Text(tab.title)
                .font(.system(size: 10, weight: .semibold, design: .rounded))
                .overlay(alignment: .topLeading){
                    ImageOverlay(numNotifs: getNumNotifs(tab:tab))
                }
        }
        .foregroundColor(localSelection == tab ? tab.color : Color.gray)
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity)
        .background(localSelection == tab ? tab.color.opacity(0.2) : Color.clear)
        .cornerRadius(10)
    }
    private func getNumNotifs(tab: TabBarItem) -> Int{
        switch tab{
            case .available:
                return modelData.isStudent ?? true ? modelData.availableTeachers.count : 0
            case .requested:
                return modelData.isStudent ?? true ? modelData.requestedTeachers.count : teacherModelData.requestedStudents.count
            case .matched:
                return modelData.isStudent ?? true ? modelData.matchedTeachers.count : teacherModelData.matchedStudents.count
            case .editProfile:
                return 0
            
        }
    }
    private var tabBarVersion1: some View {
        HStack {
            ForEach(tabs, id: \.self) { tab in
                tabView(tab: tab)
                    .onTapGesture {
                        switchToTab(tab: tab)
                    }
            }
        }
        .padding(6)
        .background(Color.white.ignoresSafeArea(edges: .bottom))
    }
    
    private func switchToTab(tab: TabBarItem) {
        selection = tab
    }
    
}

extension CustomTabBarView {
    
    private func tabView2(tab: TabBarItem) -> some View {
        VStack {
            Image(systemName: tab.iconName)
                .font(.title)
                .overlay(alignment: .topTrailing){
                    ImageOverlay(numNotifs: getNumNotifs(tab: tab))
                }
            Text(tab.title)
                .font(.system(size: 15, weight: .semibold, design: .rounded))

        }
        .foregroundColor(localSelection == tab ? tab.color : Color.gray)
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity)
        .background(
            ZStack {
                if localSelection == tab {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(tab.color.opacity(0.2))
                        .matchedGeometryEffect(id: "background_rectangle", in: namespace)
                }
            }
        )
    }
    
    private var tabBarVersion2: some View {
        HStack {
            ForEach(tabs, id: \.self) { tab in
                tabView2(tab: tab)
                    .onTapGesture {
                        switchToTab(tab: tab)
                    }
            }
        }
        .padding(6)
        .background(Color.white.ignoresSafeArea(edges: .bottom))
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)
        .padding(.horizontal)
    }
    
}
