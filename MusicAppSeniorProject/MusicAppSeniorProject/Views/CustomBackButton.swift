//
//  CustomBackButton.swift
//  MusicAppSeniorProject
//
//  Created by Samuel Wang on 8/22/23.
//

import SwiftUI

struct CustomBackButton: View {

    let dismiss: DismissAction
    
    var body: some View {
        let shape = RoundedRectangle(cornerRadius: 20)

        Button {
            dismiss()
        } label: {
            HStack(spacing: 3){
                Image(systemName: "arrowshape.backward")
                    .foregroundColor(Color.orange)
                    .font(.system(size: 22))

                Image(systemName: "house.fill")
                    .font(.system(size: 25))
                    .foregroundColor(Color.orange)


        }.background(
                shape
                    .strokeBorder(Color.purple,lineWidth: 2)
                    .background(Color.purple, in: shape)
                    .padding(-5)
            )

        }
    }
}
//struct CustomBackButton_Previews: PreviewProvider {
//    @Environment(\.dismiss) private var dismiss
//
//    static var previews: some View {
//        CustomBackButton()
//    }
//}
struct CustomLogoutButton: View {

    let dismiss: DismissAction
    
    var body: some View {
        let shape = RoundedRectangle(cornerRadius: 20)

        Button {
            dismiss()
        } label: {
            HStack(spacing: 3){
                Image(systemName: "arrow.uturn.backward")
                    .foregroundColor(Color.orange)
                    .font(.system(size: 22))

                Text("Logout")
                    .font(.system(size: 25))
                    .foregroundColor(Color.orange)


        }.background(
                shape
                    .strokeBorder(Color.purple,lineWidth: 2)
                    .background(Color.purple, in: shape)
                    .padding(-5)
            )

        }
    }
}
//struct CustomBackButton_Previews: PreviewProvider {
//    @Environment(\.dismiss) private var dismiss
//
//    static var previews: some View {
//        CustomBackButton()
//    }
//}
