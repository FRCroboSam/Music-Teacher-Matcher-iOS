//import SwiftUI
//import UIKit
//
//
//struct TestView: View {
//    
//    @State var name: String = ""
//    @State var password: String = ""
//    @State var showPassword: Bool = false
//    @State var numNotifications = 4
//    @State var userType = "Student"
//    @State var sheetHeight = 300.0
//
//    var isSignInButtonDisabled: Bool {
//        [name, password].contains(where: \.isEmpty)
//    }
//
//
//    var body: some View {
//        ZStack{
//            Text("HEFL")
//            sheetView
//                .frame(height: sheetHeight)
//                .gesture(DragGesture(minimumDistance: 1)
//                    .onChanged{ v in
//                        sheetHeight = 300 - v.translation.height
//                    }
//                    .onEnded{ _ in
//                        sheetHeight = 300
//                    }
//                )
//        }
//    }
//}
//
//
//struct TestView_Previews: PreviewProvider {
//    static var previews: some View {
//        TestView()
//    }
//}
//
//
//struct sheetView: View{
//    
//    var body: some View {
//        RoundedRectangle(cornerRadius: 18, style: .continuous)
//            .fill(.regularMaterial)
//            .edgesIgnoringSafeArea(.bottom)
//            .overlay {
//                // Handle
//                Capsule()
//                    .fill(.ultraThinMaterial)
//                    .colorScheme(.dark)
//                    .frame(width: 60, height: 8)
//                    .padding()
//            }
//    }
//}
