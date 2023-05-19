
import SwiftUI

struct iosCheckboxToggleStyle: View {
    @Binding var checked: Bool

    var body: some View {
        Image(systemName: checked ? "checkmark.square.fill" : "square")
            .foregroundColor(checked ? Color(UIColor.systemBlue) : Color.secondary)
            .onTapGesture {
                self.checked.toggle()
            }
    }
}

struct CheckBoxView_Previews: PreviewProvider {
    struct CheckBoxViewHolder: View {
        @State var checked = false

        var body: some View {
            iosCheckboxToggleStyle(checked: $checked)
        }
    }

    static var previews: some View {
        CheckBoxViewHolder()
    }
}
