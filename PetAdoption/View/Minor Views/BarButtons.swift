import SwiftUI

struct BarButtons : View {
    
    @State private var isEnabled = true
    @EnvironmentObject var mainVM: CardVM
    
    var body : some View {
        HStack {
            Button(action: {
                print("pressed")
                
            }) {
                Image(systemName: "info.circle")
                    .foregroundColor(.blue)
            }
            .buttonStyle(CircleButtonStyle(isBig: false, buttonType: .info, isEnabled: $isEnabled, mainVM: self._mainVM))
            Spacer(minLength: 12)
            
            Button(action: {
            
            }) {
                Image(systemName: "xmark").resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.red)
            }
            .buttonStyle(CircleButtonStyle(isBig: true, buttonType: .reject, isEnabled: $isEnabled, mainVM: self._mainVM))

            Spacer(minLength: 12)
            
            Button(action: {
            }) {
                Image(systemName: "suit.heart.fill").resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.orange)
            }
            .buttonStyle(CircleButtonStyle(isBig: true, buttonType: .pick, isEnabled: $isEnabled, mainVM: self._mainVM))
            Spacer(minLength: 12)
            
            Button(action: {
                print("pressed")
            }) {
                Image(systemName: "square.and.arrow.up")
                    .foregroundColor(.purple)
            }
            .buttonStyle(CircleButtonStyle(isBig: false, buttonType: .share, isEnabled: $isEnabled, mainVM: self._mainVM))
        }
    }
}


struct ButtomBar: View {
    
    var body : some View {
        Path{ path in
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: UIScreen.main.bounds.width, y: 0))
            path.addLine(to: CGPoint(x: UIScreen.main.bounds.width, y: 55))
            path.addLine(to: CGPoint(x: 0, y: 55))
            
        }.fill(Color.offWhite)
            .rotationEffect(.init(degrees: 180))
    }
}
