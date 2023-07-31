import SwiftUI
struct ContentViewTest: View {
@State private var login = "Tony"
@State private var password = "1234"

var body: some View {
    
    ZStack {
        VStack {
            HStack {
                Text("Enter Login and Password")
            }

            HStack {
                Image(systemName: "person")
                TextField("Login", text: $login)
            }
            
            HStack {
                SecureField("Password", text: $password)
            }
            
            Button("Login") {
                   
            }
         }
      }
   }
}
struct ContentViewTest_Previews: PreviewProvider {
    static var previews: some View {
        ContentViewTest()
    }
}
