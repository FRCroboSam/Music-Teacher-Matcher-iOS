import SwiftUI
struct OvalTextFieldStyle: TextFieldStyle {
    var deviceWidth: CGFloat {
        UIScreen.main.bounds.width
    }
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(50)
            .frame(maxWidth: 3/4 * deviceWidth)
            .background(LinearGradient(gradient: Gradient(colors: [Color.orange, Color.orange]), startPoint: .topLeading, endPoint: .bottomTrailing))
            .cornerRadius(20)
            .shadow(color: .gray, radius: 10)
    }
}
