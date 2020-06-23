import SwiftUI

struct BarButtons : View {
    
    @EnvironmentObject var mainVM: MainVM
    var body : some View {
        HStack {
            Button(action: {
                print("pressed")
                
            }) {
                Image(systemName: "info.circle")
                    .foregroundColor(.blue)
            }
            .buttonStyle(CircleButtonStyle(isBig: false, buttonType: .info, mainVM: self._mainVM))
            Spacer(minLength: 12)
            
            Button(action: {
            
            }) {
                Image(systemName: "xmark").resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.orange)
            }
            .buttonStyle(CircleButtonStyle(isBig: true, buttonType: .reject, mainVM: self._mainVM))

            Spacer(minLength: 12)
            
            Button(action: {
            }) {
                Image(systemName: "suit.heart.fill").resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.pink)
            }
            .buttonStyle(CircleButtonStyle(isBig: true, buttonType: .pick, mainVM: self._mainVM))
            Spacer(minLength: 12)
            
            Button(action: {
                print("pressed")
            }) {
                Image(systemName: "square.and.arrow.up")
                    .foregroundColor(.purple)
            }
            .buttonStyle(CircleButtonStyle(isBig: false, buttonType: .share, mainVM: self._mainVM))
        }
    }
}
