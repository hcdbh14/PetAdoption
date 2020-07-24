import SwiftUI

struct SignInView: View {
    
    @State var email: String = ""
    @State var password: String = ""
    @State var error: String = ""
    @Binding var showLogin: Bool
    @Binding var isEmailVerified: Bool
    @Binding var showRegistration: Bool
    @EnvironmentObject var session : SessionStore
    
    init(isEmailVerified: Binding<Bool>, showLogin: Binding<Bool>, showRegistration: Binding<Bool>) {
        
        self._showLogin = showLogin
        self._showRegistration = showRegistration
        self._isEmailVerified = isEmailVerified
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
        self.showLogin = false
        self.showRegistration = true
    }
    var body: some View {
        VStack {
            VStack {
                HStack(spacing: 15) {
                    Image(systemName: "envelope.fill")
                        .foregroundColor(.gray)
                    TextField("Email", text: $email)
                }.frame(height: 15)
                .modifier(TextFieldModifier())
                .padding(15)
                
                
                HStack(spacing: 15) {
                    Image(systemName: "lock.fill")
                        .foregroundColor(.gray)
                    SecureField("Password", text: $password)
                }.frame(height: 15)
                .modifier(TextFieldModifier())
                .padding(15)
                
                
                
            }
            Button(action: signIn) {
                Text("Login")
                    .foregroundColor(Color.black.opacity(0.7))
                    .padding(.vertical)
                    .frame(width: UIScreen.main.bounds.width - 150)
                
            }.buttonStyle(ButtonModifier())
            
            Text("(OR)")
                .foregroundColor(.gray)
            
            Button(action: moveToSignUp) {
                Text("Sign Up")
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .frame(height: 50)
                    .foregroundColor(Color.black)
            }
            
            if showRegistration {
                SignUpView(showLogin: $showLogin, showRegistration: $showRegistration)
            }
            
            if (error != "") {
                Text(error)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.red)
                    .padding()
            }
        }
    }
}

