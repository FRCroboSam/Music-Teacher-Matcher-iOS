import SwiftUI

struct TestView: View {
    
    @State var name: String = ""
    @State var password: String = ""
    @State var showPassword: Bool = false
    @State var numNotifications = 4 
    var isSignInButtonDisabled: Bool {
        [name, password].contains(where: \.isEmpty)
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image("music_background2") // your image
                    .resizable()
//                    .scaledToFill()
                    .ignoresSafeArea()
                VStack() {
                    Image("app_icon")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height:200)
                    Text("Music Matcher")
                    //                    .font(.largeTitle)
                        .font(.system(size: 45))
                        .foregroundColor(.white)
                        .bold()
                        .italic()
                    Text("Hello this is some sample text that i am writing to show that this text goes off the screen.")
                }.foregroundColor(.white)
            }.frame(maxWidth: geometry.size.width)
        }
    }
}

        //        VStack(alignment: .leading, spacing: 15) {
        //            Spacer()
        //
        //            TextField("Name",
        //                      text: $name ,
        //                      prompt: Text("Login").foregroundColor(.blue)
        //            )
        //            .padding(10)
        //            .overlay {
        //                RoundedRectangle(cornerRadius: 10)
        //                    .stroke(.blue, lineWidth: 2)
        //            }
        //            .padding(.horizontal)
        //
        //            HStack {
        //                Group {
        //                    if showPassword {
        //                        TextField("Password", // how to create a secure text field
        //                                    text: $password,
        //                                    prompt: Text("Password").foregroundColor(.red)) // How to change the color of the TextField Placeholder
        //                    } else {
        //                        SecureField("Password", // how to create a secure text field
        //                                    text: $password,
        //                                    prompt: Text("Password").foregroundColor(.red)) // How to change the color of the TextField Placeholder
        //                    }
        //                }
        //                .padding(10)
        //                .overlay {
        //                    RoundedRectangle(cornerRadius: 10)
        //                        .stroke(.red, lineWidth: 2) // How to add rounded corner to a TextField and change it colour
        //                }
        //
        //                Button {
        //                    showPassword.toggle()
        //                } label: {
        //                    Image(systemName: showPassword ? "eye.slash" : "eye")
        //                        .foregroundColor(.red) // how to change image based in a State variable
        //                }
        //
        //            }.padding(.horizontal)
        //
        //            Spacer()
        //
        //            Button {
        //                print("do login action")
        //            } label: {
        //                Text("Sign In")
        //                    .font(.title2)
        //                    .bold()
        //                    .foregroundColor(.white)
        //            }
        //            .frame(height: 50)
        //            .frame(maxWidth: .infinity) // how to make a button fill all the space available horizontaly
        //            .background(
        //                isSignInButtonDisabled ? // how to add a gradient to a button in SwiftUI if the button is disabled
        //                LinearGradient(colors: [.gray], startPoint: .topLeading, endPoint: .bottomTrailing) :
        //                    LinearGradient(colors: [.blue, .red], startPoint: .topLeading, endPoint: .bottomTrailing)
        //            )
        //            .cornerRadius(20)
        //            .disabled(isSignInButtonDisabled) // how to disable while some condition is applied
        //            .padding()
        //        }
        //    }

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
