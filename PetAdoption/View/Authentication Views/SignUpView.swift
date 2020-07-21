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
                    .foregroundColor(Color("orange"))
                    .padding(.leading, 25)
                Spacer()
                
                HStack {
                    Button(action: moveToLogin) {
                        Text("כבר רשום?")
                        .font(.system(size: 18, weight: .semibold))
                            
                        Text("כניסה")
                          .font(.system(size: 18, weight: .bold))
                            .underline()
                    }
                }.foregroundColor(Color("orange"))
                .padding(.trailing, 25)
            }
            
            
            HStack(spacing: 15) {
                Image(systemName: "person.fill")
                    .foregroundColor(Color.gray)
                TextField("שם מלא", text: $fullName)
                    .foregroundColor(.black)
            }.frame(height: 15)
            .modifier(TextFieldModifier())
            .padding(15)
            
            HStack(spacing: 15) {
                Image(systemName: "envelope.fill")
                    .foregroundColor(Color.gray)
                TextField("אימייל", text: $email)
                    .foregroundColor(.black)
            }.frame(height: 15)
            .modifier(TextFieldModifier())
            .padding(15)
            
            
            HStack(spacing: 15) {
                Image(systemName: "lock.fill")
                    .foregroundColor(Color.gray)
                SecureField("סיסמה", text: $password)
                    .foregroundColor(.black)
            }.frame(height: 15)
            .modifier(TextFieldModifier())
            .padding(15)
            
            Button(action: signUp) {
                Text("המשך")
                    .frame(width: UIScreen.main.bounds.width - 100, height: 50)
                    .foregroundColor(.white)
                    .background(Color("orange"))
                    .cornerRadius(30)
                    .shadow(radius: 5)
            }
        }
    }
}
