import SwiftUI

struct SignUpView: View {
    
    @Binding var showLogin: Bool
    @Binding var showRegistration: Bool
    
    @State var error: String = ""
    @State var email: String = ""
    @State var password: String = ""
    @State var fullName: String = ""
    @EnvironmentObject var session: SessionStore
    
    init(showLogin: Binding<Bool>, showRegistration: Binding<Bool>) {
        
        self._showLogin = showLogin
        self._showRegistration = showRegistration
    }
    
    func moveToLogin() {
        showLogin = true
        showRegistration = false
    }
    
    func signUp() {
        session.signUp(email: email, password: password) { (result, error) in
            if let error = error {
                self.error = error.localizedDescription
            } else {
                self.session.saveUserData(email: self.email, fullName: self.fullName)
                self.session.verifyEmail()
                self.fullName = ""
                self.email = ""
                self.password = ""
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                
                Text("הרשמה")
                    .font(.system(size: 36, weight: .heavy))
                    .foregroundColor(Color("lightPurple"))
                    .padding(.leading, 25)
                Spacer()
                
                HStack {
                    Button(action: moveToLogin) {
                        Text("כבר רשום?")
                        Text("כניסה")
                            .bold()
                            .underline()
                    }
                }.foregroundColor(Color("lightPurple"))
                .padding(.trailing, 25)
            }
            
            
            HStack(spacing: 15) {
                Image(systemName: "person.fill")
                    .foregroundColor(Color("lightBlue"))
                TextField("שם מלא", text: $fullName)
                    .foregroundColor(.black)
            }.frame(height: 15)
            .modifier(TextFieldModifier())
            .padding(15)
            
            HStack(spacing: 15) {
                Image(systemName: "envelope.fill")
                    .foregroundColor(Color("lightBlue"))
                TextField("אימייל", text: $email)
                    .foregroundColor(.black)
            }.frame(height: 15)
            .modifier(TextFieldModifier())
            .padding(15)
            
            
            HStack(spacing: 15) {
                Image(systemName: "lock.fill")
                    .foregroundColor(Color("lightBlue"))
                SecureField("סיסמה", text: $password)
                    .foregroundColor(.black)
            }.frame(height: 15)
            .modifier(TextFieldModifier())
            .padding(15)
            
            Button(action: signUp) {
                Text("המשך")
                    .frame(width: UIScreen.main.bounds.width - 100, height: 50)
                    .foregroundColor(.white)
                    .background(LinearGradient(Color("lightPink"), Color("lightPurple")))
                    .cornerRadius(30)
            }
        }
    }
}
