import SwiftUI

struct ForgotPasswordView: View {
    
    @State var email: String = "kennnkuro15@gmail.com"
    @State var triggerFade = true
    @EnvironmentObject var session : SessionStore
    
    var body: some View {
        VStack {
            Button(action: resetPassword) {
                Text("reset password").foregroundColor(.white)
            }
        }.opacity(triggerFade ? 0 : 1)
            .onAppear() {
                withAnimation {
                    self.triggerFade = false
                }
        }
    }
    
    func resetPassword() {
        session.passwordReset(email: email)
    }
}

