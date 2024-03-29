
//
//  PopupView.swift
//  Popup SuwiftUI
//
//  Created by Eniela Vela on 2022-11-12.
//
import SwiftUI

struct PopupView: View {
    var body: some View {
        VStack (spacing: .zero) {
            icon
            title
            content
            
        }.padding()
            .multilineTextAlignment(.center)
            .background(Color.red)
    }
}

struct PopupView_Previews: PreviewProvider {
    static var previews: some View {
        PopupView()
    }
}

private extension PopupView {
    var icon: some View {
  Image (systemName: "info")
    .symbolVariant(.circle.fill)
    .font (.system(size: 50,
    weight: .bold,
                  design: .rounded)
    )
    .foregroundStyle(.white)
           }
           
    var title: some View {
    Text ("Text here")

    .font (
    .system(size: 30,
    weight: .bold,
    design: .rounded)
    )
 
    .padding ()
    }
    
    var content: some View {
    Text ("Lorem ipsum dolor sit amet, consectetur.")
    .font (.callout)
    .foregroundColor(.black.opacity(0.8))
          }
          
}
