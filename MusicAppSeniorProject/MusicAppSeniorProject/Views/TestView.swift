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
        // Your custom complicated view graph
        Group {
            if imageManager.image != nil {
                Image(uiImage: imageManager.image!)
            } else {
                Rectangle().fill(Color.gray)
            }
        }
        // Trigger image loading when appear
        .onAppear { self.imageManager.load(url: URL(string:"https://firebasestorage.googleapis.com:443/v0/b/musicapp-52b7f.appspot.com/o/jOH4EANrxIfRiN1e4XCYLeg1HY03?alt=media&token=3560fe33-6c4c-4941-a4b6-721b4789f15c"))
            
        }
        // Cancel image loading when disappear
        .onDisappear { self.imageManager.cancel() }
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
