//
//  CustomSlider.swift
//  CustomSlider
//
//  Created by Ganesh on 25/06/23.
//

import SwiftUI

struct CustomSlider: View {
    @Binding var offset:CGFloat
    private var maxValue:CGFloat
    private var minValue: CGFloat
    
    init(value: Binding<CGFloat>, maxValue: CGFloat, minValue: CGFloat) {
        self._offset = value
        self.maxValue = maxValue
        self.minValue = minValue
    }
    var body: some View {
        VStack{
            Text(getValue(offset:offset))
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
                    .simultaneousGesture (DragGesture().onChanged({ (value) in
                        // Padding Horizontal....
                        // Padding Horizontal = 30
                        // Circle radius = 20
                        // Total
                        if value.location.x >= 13 && value.location.x <=
                            3/4 * UIScreen.main.bounds.width - 13 {
                            offset = value.location.x - 17.5
                        }
                    }))
            })
        }

    }
    func getValue(offset: CGFloat) -> String{
        let totalAmount = maxValue - minValue
        print("OFFSET: " + String(Double(offset)))
        print("SCREEN SIZE IS: " + String(Double(UIScreen.current?.bounds.size.width ?? 0.0)))
        let maxOffset = 3/4 * UIScreen.main.bounds.width - 13 - 17.5
        var percent = (offset / maxOffset)
        percent = min(1, max(0, percent))
        //percent = (distance of offset on x)/3/4 * UIScreen.main.bounds.widt
        print("PERCENT: " + String(Double(percent)))
        let amount = Double(Double((percent * totalAmount)).rounded() + minValue)
        
        return String(amount)
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


