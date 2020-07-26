import SwiftUI

struct ForgotPasswordView: View {
    
    @Binding var showLogin: Bool
    @Binding var showForgotPassword: Bool
    @State var email: String = "kennnkuro15@gmail.com"
    @State var triggerFade = true
    @EnvironmentObject var session : SessionStore
    
    init(showLogin: Binding<Bool>, forgotPassword: Binding<Bool>) {
        self._showLogin = showLogin
        self._showForgotPassword = forgotPassword
    }
    
    var body: some View {
        VStack {
            Button(action: resetPassword) {
                Text("reset password").foregroundColor(.white)
            }
            
            Button(action: returnToLogin) {
                Text("return to login").foregroundColor(.white)
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
    
    
    func returnToLogin() {
        withAnimation { triggerFade = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            self.showForgotPassword = false
            self.showLogin = true
        }
    }
}

