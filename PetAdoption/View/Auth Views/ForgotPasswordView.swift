import SwiftUI

struct ForgotPasswordView: View {
    
    @State private var mailSend = false
    @Binding private var showLogin: Bool
    @State private var error: String = ""
    @State private var email: String = ""
    @State private var triggerFade = true
    @State private var waitingForResponse = false
    @Binding private var showForgotPassword: Bool
    @EnvironmentObject private var session : SessionStore
    @Environment (\.colorScheme) private var colorScheme: ColorScheme
    
    init(showLogin: Binding<Bool>, forgotPassword: Binding<Bool>) {
        self._showLogin = showLogin
        self._showForgotPassword = forgotPassword
    }
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text("הכניסו כתובת מייל")
                    .font(.system(size: 30, weight: .heavy))
                    .foregroundColor(.white)
                    .padding(.leading, 25)
                Spacer()
            }
            
            VStack {
                HStack(spacing: 15) {
                    
                    Image(systemName: "envelope.fill")
                        .foregroundColor(Color.gray)
                    
                    if colorScheme == .light {
                        TextField("אימייל", text: $email)
                            .colorInvert()
                            .onReceive(email.publisher.collect()) {
                                self.email = String($0.prefix(254))
                        }
                    } else {
                        TextField("אימייל", text: $email)
                            .onReceive(email.publisher.collect()) {
                                self.email = String($0.prefix(254))
                        }
                    }
                }.frame(height: 15)
                    .padding(.leading, 25)
                line.frame(width: UIScreen.main.bounds.width  / 1.2, height: 1)
            }.padding(15)
            
            HStack {
                
                Button(action: returnToLogin) {
                    
                    Image(systemName: "arrow.right").resizable()
                        .frame(width: 15, height: 15)
                        .foregroundColor(.orange)
                    Text("חזרה למסך כניסה")
                        .foregroundColor(.orange)
                        .font(.system(size: 14, weight: .semibold))
                    
                }.padding(.leading, 20)
                Spacer()
                
                Button(action: resetPassword) {
                    Text("הנפקת סיסמה חדשה")
                        .foregroundColor(.orange)
                        .font(.system(size: 14, weight: .semibold))
                    Image(systemName: "arrow.left").resizable()
                        .frame(width: 15, height: 15)
                        .foregroundColor(.orange)
                }.padding(.trailing, 20)
                    .disabled(waitingForResponse)
            }
            HStack {
                if waitingForResponse {
                    ActivityIndicator(isAnimating: true)
                        .configure { $0.color = .white }
                    
                } else if mailSend {
                    Text("נשלח מייל לאיפוס סיסמה")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.green)
                        .frame(width: UIScreen.main.bounds.width, alignment: .center)
                }
                else {
                    Text(error)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.red)
                        .frame(width: UIScreen.main.bounds.width, alignment: .center)
                    
                }
            }.frame(height: 50)
                .padding(.top, 40)
                .padding(.bottom, 139)
        }.opacity(triggerFade ? 0 : 1)
            .onAppear() {
                withAnimation {
                    self.triggerFade = false
                }
        }
    }
    
    
    private func resetPassword() {
        
        mailSend = false
        
        UIApplication.shared.endEditing()
        
        if email.isEmpty {
            error = "לא הוזן כתובת מייל"
            return
        }
        
        if !email.contains("@") || !email.contains(".") {
            error = "כתובת מייל שהוזן לא תקין"
            return
        }
        waitingForResponse = true
        
        session.passwordReset(email: email) { (error) in
            if let error = error {
                print(error.localizedDescription)
                let errorHandler = ErrorTranslater()
                self.error = errorHandler.passwordResetErrors(error.localizedDescription)
                
            } else {
                self.error = ""
                self.mailSend = true
            }
            self.waitingForResponse = false
        }
    }
    
    
    private func returnToLogin() {
        withAnimation { triggerFade = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            self.showForgotPassword = false
            self.showLogin = true
        }
    }
}
