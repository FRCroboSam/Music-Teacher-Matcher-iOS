import SwiftUI
import SDWebImageSwiftUI
import UIKit


struct TestView: View {
    
    @State var name: String = ""
    @State var password: String = ""
    @State var showPassword: Bool = false
    @State var numNotifications = 4
    @State var userType = "Student"
    @State var sheetHeight = 300.0

    var isSignInButtonDisabled: Bool {
        [name, password].contains(where: \.isEmpty)
    }

    @ObservedObject var imageManager = ImageManager()
    var body: some View {
        GeometryReader { geo in
            ScrollView {
                Rectangle()
                .frame(width: geo.size.width, height: 1800)
                .foregroundColor(.orange)
                .background(ScrollViewConfigurator {
                    $0?.bounces = false               // << here !!
                })
                Spacer()
            }
        }
    }
}


struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}


struct sheetView: View{
    
    var body: some View {
        RoundedRectangle(cornerRadius: 18, style: .continuous)
            .fill(.regularMaterial)
            .edgesIgnoringSafeArea(.bottom)
            .overlay {
                // Handle
                Capsule()
                    .fill(.ultraThinMaterial)
                    .colorScheme(.dark)
                    .frame(width: 60, height: 8)
                    .padding()
            }
    }
}
