import SwiftUI

struct SignInView: View {
    
    @State var triggerFade = true
    @State var email: String = ""
    @State var password: String = ""
    @State var error: String = ""
    @Binding var showLogin: Bool
    @Binding var isEmailVerified: Bool
    @Binding var showRegistration: Bool
    @EnvironmentObject var session : SessionStore
    @Environment (\.colorScheme) var colorScheme: ColorScheme
    
    init(isEmailVerified: Binding<Bool>, showLogin: Binding<Bool>, showRegistration: Binding<Bool>) {
        
        self._showLogin = showLogin
        self._showRegistration = showRegistration
        self._isEmailVerified = isEmailVerified
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
                            .colorInvert()
                    } else {
                        TextField("אימייל", text: $email)
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
                    } else {
                        SecureField("סיסמה", text: $password)
                    }
                    
                    
                    
                }.frame(height: 15)
                    .padding(.leading, 25)
                //            .modifier(TextFieldModifier())
                
                line.frame(width: UIScreen.main.bounds.width  / 1.2, height: 1)
            }.padding(15)
            
            Button(action: signIn) {
                Text("כניסה")
                    .frame(width: UIScreen.main.bounds.width - 100, height: 50)
                    .foregroundColor(.white)
                    .background(Color("orange"))
                    .cornerRadius(30)
                    .shadow(radius: 5)
            }.padding(15)
            
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
             .padding(.bottom, 62)
        
            
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
    
    
    func signIn() {
        session.signIn(email: email, password: password) { (result, error) in
            if let error = error {
                self.error = error.localizedDescription
            } else {
                self.email = ""
                self.password = ""
                self.isEmailVerified = result?.user.isEmailVerified ?? false
            }
        }
    }
    
    func moveToSignUp() {
        withAnimation { triggerFade = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.showLogin = false
            self.showRegistration = true
        }
    }
}

