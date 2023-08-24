import SwiftUI

struct CustomizeListView: View {

var titles = ["First Section" : ["Manage your workout", "View recorded workouts", "Weight tracker", "Mediation"], "Second Section" : ["Your workout", "Recorded workouts", "Tracker", "Mediations"]]


var body: some View {
    List {
        ForEach(titles.keys.sorted(by: <), id: \.self){ key in
            Section(key) {
                VStack(alignment: .leading, spacing: 0){
                    ForEach(titles[key]!, id: \.self) { title in
                        HStack{
                            Text(title)
                            Spacer()
                            Image(systemName: "arrow.right")
                        }//: HSTACK
                        .padding(20)
                        Divider()
                    }//: LOOP
                }//: VSTACK
                .overlay(
                    RoundedRectangle(cornerRadius: 10, style: .circular).stroke(Color(uiColor: .tertiaryLabel), lineWidth: 1)
                )
                .foregroundColor(Color(uiColor: .tertiaryLabel))
            }//: SECTION
        }//: LOOP
    }//: LIST
    .listRowBackground(Color.orange)
    .listStyle(InsetListStyle())
    .background(Color.orange)
}
}

struct CustomizeListView_Previews: PreviewProvider {
static var previews: some View {
    CustomizeListView()
}
}
