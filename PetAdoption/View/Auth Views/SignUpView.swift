import SwiftUI

struct SignUpView: View {
    
    @State var triggerFade = true
    @Binding var showLogin: Bool
    @State var error: String = ""
    @State var email: String = ""
    @State var password: String = ""
    @State var fullName: String = ""
    @State var waitingForResponse = false
    @Binding var emailVerification: Bool
    @EnvironmentObject var session: SessionStore
    @Environment (\.colorScheme) var colorScheme: ColorScheme
    
    init(showLogin: Binding<Bool>, emailVerification: Binding<Bool>) {
        
        self._showLogin = showLogin
        self._emailVerification = emailVerification
    }
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text("הרשמה")
                    .font(.system(size: 36, weight: .heavy))
                    .foregroundColor(.white)
                    .padding(.leading, 25)
                Spacer()
            }
            
            VStack {
                HStack(spacing: 15) {
                    Image(systemName: "person.fill")
                        .foregroundColor(Color.gray)
                    
                    if colorScheme == .light {
                        TextField("שם מלא", text: $fullName)
                            .onReceive(fullName.publisher.collect()) {
                                if self.fullName.count > 28 {
                                    self.error = "ניתן להקליד עד 28 תווים בלבד בשדה שם"
                                }
                                self.fullName = String($0.prefix(28))
                            }
                            .colorInvert()
                    } else {
                        TextField("שם מלא", text: $fullName)
                            .onReceive(fullName.publisher.collect()) {
                                if self.fullName.count > 28 {
                                    self.error = "ניתן להקליד עד 28 תווים בלבד בשדה שם"
                                }
                                self.fullName = String($0.prefix(28))
                            }
                    }
                    
                    
                }.frame(height: 15)
                .padding(.leading, 25)
                
                line.frame(width: UIScreen.main.bounds.width  / 1.2, height: 1)
            }.padding(15)
            
            
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
            } .padding(15)
            
            
            VStack {
                HStack(spacing: 15) {
                    Image(systemName: "lock.fill")
                        .foregroundColor(Color.gray)
                    if colorScheme == .light {
                        SecureField("סיסמה", text: $password)
                            .colorInvert()
                            .onReceive(password.publisher.collect()) {
                                if self.password.count > 18 {
                                    self.error = "ניתן להקליד עד 18 תווים בלבד בשדה סיסמה"
                                }
                                self.password = String($0.prefix(18))
                            }
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
            
            Button(action: signUp) {
                if waitingForResponse {
                                            
                    ActivityIndicator(isAnimating: true)
                        .configure { $0.color = .white }
                } else {
                Text("המשך")
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
            .padding(15)
            
            HStack {
                Button(action: moveToLogin) {
                    Text("כבר רשום?")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                    Text("כניסה")
                        .font(.system(size: 16, weight: .bold))
                        .underline()
                        .foregroundColor(.orange)
                }
            }.frame(width: UIScreen.main.bounds.width, alignment: .center)
            
            
            Text(error)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.red)
                .frame(width: UIScreen.main.bounds.width, alignment: .center)
            
            
        }.opacity(triggerFade ? 0 : 1)
        .onAppear() {
            withAnimation {
                self.triggerFade = false
            }
        }
    }
    
    private func triggerFadeAnimation() {
        withAnimation { triggerFade = true }
    }
    
    func moveToLogin() {
        triggerFadeAnimation()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.showLogin = true
        }
    }
    
    func signUp() {
        
        if fullName.isEmpty {
            error = "לא הוזן שם מלא"
            return
        }
        
        if fullName.count < 5 {
            error = "השם מלא אמור להכיל 5 תווים לפחות"
            return
        }
        
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
        
        session.signUp(email: email, password: password) { (result, error) in
            if let error = error {
                print(error.localizedDescription)
                let errorHandler = ErrorTranslater()
                self.error = errorHandler.signUpErrors(error.localizedDescription)
                self.waitingForResponse = false
                
            } else {
                self.session.verifyEmail()
                self.session.saveUserData(email: self.email, fullName: self.fullName)
                self.triggerFadeAnimation()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.emailVerification = true
                    self.fullName = ""
                    self.email = ""
                    self.password = ""
                }
            }
        }
    }
}
