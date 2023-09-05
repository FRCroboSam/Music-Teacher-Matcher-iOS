//
//  CustomSlider.swift
//  CustomSlider
//
//  Created by Ganesh on 25/06/23.
//

import SwiftUI

struct CustomSlider: View {
    @Binding var value:CGFloat
    @State var offset: CGFloat
    private var name: String
    private var maxValue:CGFloat
    private var minValue: CGFloat
    
    init(value: Binding<CGFloat>, name: String, maxValue: CGFloat, minValue: CGFloat) {
        self._value = value
        self.maxValue = maxValue
        self.minValue = minValue
        self.offset = 0
        self.name = name 

    }
    var body: some View {
        let shape = RoundedRectangle(cornerRadius: 5)
        VStack{
            ZStack{
                HStack{
                    Text(name)
                    Spacer(minLength: 10)
                    Text(String(Double(value)))
                        .font(.system(size: 20))
                        .background(
                            shape
                                .strokeBorder(Color.black,lineWidth: 2)
                                .background(Color.white, in: shape)
                                .padding(-5)
                        )
                }
           
            }

            ZStack(alignment: Alignment (horizontal: .leading, vertical: .center), content: {
                Capsule()
                    .fill(Color.black.opacity(0.25))
                    .frame(width: 3/4 * UIScreen.main.bounds.width, height: 30)
                Capsule()
                    .fill(Color.purple)
                    .frame(width: offset + 20, height: 30)
                Circle()
                    .fill(Color.orange)
                    .frame(width: 35, height: 35)
                    .background (Circle().stroke (Color.white, lineWidth: 5))
                    .offset(x: offset)
                    .simultaneousGesture (DragGesture().onChanged({ (value2) in
                        // Padding Horizontal....
                        // Padding Horizontal = 30
                        // Circle radius = 20
                        // Total
                        if value2.location.x >= 17.5 && value2.location.x <=
                            3/4 * UIScreen.main.bounds.width - 13 {
                            offset = value2.location.x - 17.5
                        }
                        value = getValue(offset:offset)
                        
                    }))
            })
        }.onAppear {
            // Initialize offset based on the provided value
            offset = getOffset(value: value)
        }
        .onChange(of: value) { newValue in
            print("VALUE IS CHANGING" + String(Double(newValue)))
            offset = getOffset(value: newValue)
        }

    }
    func getOffset(value: CGFloat) -> CGFloat{
        let percent = (min(maxValue, max(minValue, value)) - minValue) / (maxValue - minValue)
        let maxOffset = 3/4 * (UIScreen.main.bounds.width - 13 - 17.5)
        let offset = percent * (3/4 * UIScreen.main.bounds.width - 13 - 17.5)
        return offset
    }
    func getValue(offset: CGFloat) -> Double{
        let totalAmount = maxValue - minValue
        print("OFFSET: " + String(Double(offset)))
        print("SCREEN SIZE IS: " + String(Double(UIScreen.current?.bounds.size.width ?? 0.0)))
        let maxOffset = 3/4 * UIScreen.main.bounds.width - 13 - 17.5
        var percent = (offset / maxOffset)
        percent = min(1, max(0, percent))
        //percent = (distance of offset on x)/3/4 * UIScreen.main.bounds.widt
        print("PERCENT: " + String(Double(percent)))
        let amount = Double(Double((percent * totalAmount)).rounded() + minValue)
        
        return amount
    }
    
}
extension UIWindow {
    static var current: UIWindow? {
        for scene in UIApplication.shared.connectedScenes {
            guard let windowScene = scene as? UIWindowScene else { continue }
            for window in windowScene.windows {
                if window.isKeyWindow { return window }
            }
        }
        return nil
    }
}


extension UIScreen {
    static var current: UIScreen? {
        UIWindow.current?.screen
    }
}


