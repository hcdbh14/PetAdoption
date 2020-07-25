import SwiftUI

struct SignUpView: View {
    
    @State var triggerFade = true
    @Binding var showLogin: Bool
    @State var error: String = ""
    @State var email: String = ""
    @State var password: String = ""
    @State var fullName: String = ""
    @Binding var showRegistration: Bool
    @EnvironmentObject var session: SessionStore
    @Environment (\.colorScheme) var colorScheme: ColorScheme
    
    init(showLogin: Binding<Bool>, showRegistration: Binding<Bool>) {
        
        self._showLogin = showLogin
        self._showRegistration = showRegistration
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
                            .colorInvert()
                    } else {
                        TextField("שם מלא", text: $fullName)
                    }
                    
                    
                }.frame(height: 15)
                .padding(.leading, 25)
                //            .modifier(TextFieldModifier())
                
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
                //            .modifier(TextFieldModifier())
                
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
                                if password.count > 18 {
                                    self.error = "ניתן להקליד עד 18 תווים בלבד בשדה סיסמה"
                                }
                                self.password = String($0.prefix(18))
                            }
                    } else {
                        SecureField("סיסמה", text: $password)
                            
                            .onReceive(password.publisher.collect()) {
                                if password.count > 18 {
                                    self.error = "ניתן להקליד עד 18 תווים בלבד בשדה סיסמה"
                                }
                                self.password = String($0.prefix(18))
                            }
                    }
                    
                }.frame(height: 15)
                .padding(.leading, 25)
                //            .modifier(TextFieldModifier())
                
                line.frame(width: UIScreen.main.bounds.width  / 1.2, height: 1)
            }.padding(15)
            
            Button(action: signUp) {
                Text("המשך")
                    .frame(width: UIScreen.main.bounds.width - 100, height: 50)
                    .foregroundColor(.white)
                    .background(Color("orange"))
                    .cornerRadius(30)
                    .shadow(radius: 5)
            }.padding(15)
            
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
    
    func moveToLogin() {
        withAnimation { triggerFade = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.showLogin = true
            self.showRegistration = false
        }
    }
    
    func signUp() {
        session.signUp(email: email, password: password) { (result, error) in
            if let error = error {
                print(error.localizedDescription)
                let errorHandler = ErrorTranslater()
                self.error = errorHandler.signUpErrors(error.localizedDescription)
                
            } else {
                self.session.saveUserData(email: self.email, fullName: self.fullName)
                self.session.verifyEmail()
                self.fullName = ""
                self.email = ""
                self.password = ""
            }
        }
    }
}

