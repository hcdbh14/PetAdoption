import SwiftUI

enum ButtonType {
    case info
    case pick
    case reject
    case share
}

struct CircleButtonStyle: ButtonStyle {
    
    let isBig: Bool
    let buttonType: ButtonType
    @EnvironmentObject var mainVM: MainVM
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(isBig ?  25 :  15)
            .contentShape(Circle())
            .onTapGesture {
                switch self.buttonType {
                case .pick:
                    self.mainVM.decision = .picked
                case .reject:
                    self.mainVM.decision = .rejected
                default:
                    return
                }
                print("pressed")
        }
        .background(
            Group {
                if configuration.isPressed {
                    Circle()
                        .fill(Color.offWhite)
                        .overlay(
                            Circle()
                                .stroke(Color.gray, lineWidth: 4)
                                .blur(radius: 4)
                                .offset(x: 2, y: 2)
                                .mask(Circle().fill(LinearGradient(Color.black, Color.clear)))
                    )
                        .overlay(
                            Circle()
                                .stroke(Color.white, lineWidth: 9)
                                .blur(radius: 4)
                                .offset(x: -2, y: -2)
                                .mask(Circle().fill(LinearGradient(Color.clear, Color.black)))
                    )
                } else {
                    Circle()
                        .fill(Color.offWhite)
                        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
                        .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
                }
            }
        )
    }
}
