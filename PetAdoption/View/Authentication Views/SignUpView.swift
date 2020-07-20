import SwiftUI

struct SignUpView: View {
    
    @State var error: String = ""
    @State var email: String = ""
    @State var password: String = ""
    @State var fullName: String = ""
    @Binding var showSignUpScreen: Bool
    @EnvironmentObject var session: SessionStore
    
    init(showSignUpScreen: Binding<Bool>) {
        self._showSignUpScreen = showSignUpScreen
    }
    
    func signUp() {
        session.signUp(email: email, password: password) { (result, error) in
            if let error = error {
                self.error = error.localizedDescription
            } else {
                session.saveUserData(email: self.email, fullName: self.fullName)
                self.session.verifyEmail()
                self.fullName = ""
                self.email = ""
                self.password = ""
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 8) {
            
            HStack(spacing: 15) {
                Image(systemName: "person.fill")
                    .foregroundColor(.gray)
                TextField("Name", text: $fullName)
            }.frame(height: 15)
            .modifier(TextFieldModifier())
            .padding(15)
            
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
            
            Button(action: signUp) {
                Text("Sign up")
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .frame(height: 50)
                    .foregroundColor(Color.black)
            }
        }
    }
}
