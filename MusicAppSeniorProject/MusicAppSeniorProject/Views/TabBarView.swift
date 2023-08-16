import SwiftUI
struct TabBarView: View {
    var tabbarItems: [String]

    @State var selectedIndex = 0
    @Namespace private var menuItemTransition

    var body: some View {
        ScrollViewReader { scrollView in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(tabbarItems.indices, id: \.self) { index in
                     
                        TabbarItem(imageIcon: "", name: tabbarItems[index], isActive: selectedIndex == index, namespace: menuItemTransition)
                            .onTapGesture {
                                withAnimation(.easeInOut) {
                                    selectedIndex = index
                                }
                            }
                    }
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(25)

        }

    }
}
struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView(tabbarItems: [ "Random", "Travel", "Wallpaper", "Food", "Interior Design" ])
    }
}
struct TabbarItem: View {
    var imageIcon: String
    var name: String
    var isActive: Bool = false
    let namespace: Namespace.ID
 
    var body: some View {
        if isActive {
            VStack{
                Image(systemName: "person.crop.circle.fill.badge.plus")
                    .aspectRatio(contentMode:.fill)
                    
                Text(name)
                    .font(.subheadline)
                    .padding(.horizontal)
                    .padding(.vertical, 4)
                    .foregroundColor(.white)
                    .background(Capsule().foregroundColor(.purple))
                    .matchedGeometryEffect(id: "highlightmenuitem", in: namespace)
            }

        } else {
            VStack{
                Image(systemName: "person.crop.circle.fill.badge.plus")
                Text(name)
                    .font(.subheadline)
                    .padding(.horizontal)
                    .padding(.vertical, 4)
                    .foregroundColor(.black)
            }

        }
 
    }
}
