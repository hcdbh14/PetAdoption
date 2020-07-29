import SwiftUI

struct PostNewDog: View {
    
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
        }
    }
}
