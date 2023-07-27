import SwiftUI
struct NotificationNumLabel : View {
    @Binding var number : Int
    var body: some View {
        ZStack {
            Capsule().fill(Color.red).frame(width: 30, height: 45, alignment: .topTrailing).position(CGPoint(x: 150, y: 0))
            Text("\(number)").foregroundColor(Color.white)
                .font(Font.system(size: 35).bold()).position(CGPoint(x: 150, y: 0))
            
        }
    }
    func numOfDigits() -> Float {
        let numOfDigits = Float(String(number).count)
        return numOfDigits == 1 ? 1.5 : numOfDigits
    }
}
