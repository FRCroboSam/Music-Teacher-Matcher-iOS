import SwiftUI
struct ContentViewTest: View {
    @State private var isShowingNewView = false

    var body: some View {
        NavigationView {
            VStack {
                Text("Home View")
                NavigationLink(destination: NewView().navigationBarBackButtonHidden(true)) {
                    Text("Navigate")
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            if isShowingNewView {
                // Navigate to the new view immediately
                DispatchQueue.main.async {
                    isShowingNewView = false
                }
            }
        }
    }
}

struct NewView: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            Text("New View")
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "chevron.left")
            Text("Back")
        })
    }
}
