import SwiftUI

struct PostNewDog: View {
    
        @State var triggerFade = true
    @Binding var showSignUpScreen: Bool
    @EnvironmentObject var session: SessionStore
    
    
    init(showSignUpScreen: Binding<Bool>) {
        self._showSignUpScreen = showSignUpScreen
    }
    var body: some View {
        VStack {
        Text("וואלה ברכות, הצלחת להיכנס לחשבון כמו מלכה")
            .font(.system(size: 30, weight: .heavy))
            .foregroundColor(.white)
            .padding(.leading, 25)
            .padding(.top, 25)
            .opacity(triggerFade ? 0 : 1)
                .onAppear() {
                    withAnimation {
                        self.triggerFade = false
                    }
            }
        }.frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            .background(Color("offWhite"))
    }
}
