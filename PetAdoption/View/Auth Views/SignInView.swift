import SwiftUI

struct SignInView: View {
    
    @Binding private var showLogin: Bool
    @State private var triggerFade = true
    @State private var email: String = ""
    @State private var error: String = ""
    @Binding private var showPostPet: Bool
    @State private var password: String = ""
    @Binding private var emailVerification: Bool
    @Binding private var showForgotPassword: Bool
    @State private var waitingForResponse = false
    @EnvironmentObject private var session : SessionStore
    @Environment (\.colorScheme) private var colorScheme: ColorScheme
    
    init(emailVerification: Binding<Bool>, showLogin: Binding<Bool>, forgotPassword: Binding<Bool>, showPostPet: Binding<Bool>) {
        
        self._showLogin = showLogin
        self._showPostPet = showPostPet
        self._showForgotPassword = forgotPassword
        self._emailVerification = emailVerification
    }
    
    var body: some View {
        VStack(spacing: 8) {
            
            HStack {
                Text("כניסה")
                    .font(.system(size: 36, weight: .heavy))
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
                            .onReceive(email.publisher.collect()) {
                                self.email = String($0.prefix(254))
                        }
                        .colorInvert()
                    } else {
                        TextField("אימייל", text: $email)
                            .onReceive(email.publisher.collect()) {
                                self.email = String($0.prefix(254))
                        }
                    }
                    
                    
                }.frame(height: 15)
                    .padding(.leading, 25)
                
                line.frame(width: UIScreen.main.bounds.width  / 1.2, height: 1)
            } .padding(15)
            
            
            VStack {
                HStack(spacing: 15) {
                    Image(systemName: "lock.fill")
                        .foregroundColor(Color.gray)
                    if colorScheme == .light {
                        SecureField("סיסמה", text: $password)
                            .onReceive(password.publisher.collect()) {
                                if self.password.count > 18 {
                                    self.error = "ניתן להקליד עד 18 תווים בלבד בשדה סיסמה"
                                }
                                self.password = String($0.prefix(18))
                        }
                            
                        .colorInvert()
                    } else {
                        SecureField("סיסמה", text: $password)
                            .onReceive(password.publisher.collect()) {
                                if self.password.count > 18 {
                                    self.error = "ניתן להקליד עד 18 תווים בלבד בשדה סיסמה"
                                }
                                self.password = String($0.prefix(18))
                        }
                    }
                }.frame(height: 15)
                    .padding(.leading, 25)
                line.frame(width: UIScreen.main.bounds.width  / 1.2, height: 1)
            }.padding(15)
            
            Button(action: moveToForgotPassword) {
                Text("שכחתי סיסמה")
                    .foregroundColor(.orange)
                    .font(.system(size: 16, weight: .semibold))
            }
            
            Button(action: signIn) {
                if waitingForResponse {
                    
                    ActivityIndicator(isAnimating: true)
                        .configure { $0.color = .white }
                } else {
                    Text("כניסה")
                        .frame(width: UIScreen.main.bounds.width - 100, height: 50)
                        .foregroundColor(.white)
                        .background(Color("orange"))
                        .cornerRadius(30)
                        .shadow(radius: 5)
                }
            }.frame(width: UIScreen.main.bounds.width - 100, height: 50)
                .foregroundColor(.white)
                .background(Color("orange"))
                .cornerRadius(30)
                .shadow(radius: 5)
                .disabled(waitingForResponse)
                .padding(15)
            
            HStack {
                Button(action: moveToSignUp) {
                    Text("לא רשום?")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                    Text("הרשמה")
                        .font(.system(size: 16, weight: .bold))
                        .underline()
                        .foregroundColor(.orange)
                }
            }.frame(width: UIScreen.main.bounds.width, alignment: .center)
            
            Text(error)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.red)
                .frame(width: UIScreen.main.bounds.width, height: 16, alignment: .center)
                .padding(.bottom, 20)
            
        }.opacity(triggerFade ? 0 : 1)
            .onAppear() {
                withAnimation {
                    self.triggerFade = false
                }
        }
    }
    
    
    func signIn() {
        
        UIApplication.shared.endEditing()
        
        if email.isEmpty {
            error = "לא הוזן כתובת מייל"
            return
        }
        
        if !email.contains("@") || !email.contains(".") {
            error = "כתובת מייל שהוזן לא תקין"
            return
        }
        
        if password.isEmpty {
            error = "לא הוזן סיסמה"
            return
        }
        
        if password.count < 6 {
            error = "סיסמה אמורה להיות 6 תווים לפחות"
            return
        }
        waitingForResponse = true
        
        session.signIn(email: email, password: password) { (result, error) in
            
            if let error = error {
                print(error.localizedDescription)
                let errorHandler = ErrorTranslater()
                self.error = errorHandler.signInErrors(error.localizedDescription)
                self.waitingForResponse = false
            } else {
                withAnimation { self.triggerFade = true }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.email = ""
                    self.password = ""
                    if result?.user.isEmailVerified ?? false {
                        withAnimation {
                            self.emailVerification = false
                            self.showPostPet = true
                        }
                    } else {
                        self.emailVerification = true
                    }
                }
            }
        }
    }
    
    
    private func moveToSignUp() {
        withAnimation { triggerFade = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            self.showLogin = false
        }
    }
    
    
    private func moveToForgotPassword() {
        withAnimation { triggerFade = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            self.showLogin = false
            self.showForgotPassword = true
        }
    }
}

