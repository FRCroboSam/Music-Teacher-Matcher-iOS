

import SwiftUI

struct CustomTabBarContainerView<Content:View>: View {
    @Binding var selection: TabBarItem
    let content: Content
    @State private var tabs: [TabBarItem] = []
    var deviceHeight: CGFloat {
        UIScreen.main.bounds.height
    }
    init(selection: Binding<TabBarItem>, @ViewBuilder content: () -> Content) {
        self._selection = selection
        self.content = content()
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            content
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
                
            
            CustomTabBarView(tabs: tabs, selection: $selection, localSelection: selection)
                //.offset(y: selection == .editProfile ? 0 : -1/30 * deviceHeight)
            
        }
        .onPreferenceChange(TabBarItemsPreferenceKey.self, perform: { value in
            print("TABS ARE CHANIGNG")
                self.tabs = value
            
        })
    }
}

//struct CustomTabBarContainerView_Previews: PreviewProvider {
//    
//    static let tabs: [TabBarItem] = [
//        .home, .favorites, .profile
//    ]
//    
//    static var previews: some View {
//        CustomTabBarContainerView(selection: .constant(tabs.first!)) {
//            Color.red
//        }
//    }
//}
