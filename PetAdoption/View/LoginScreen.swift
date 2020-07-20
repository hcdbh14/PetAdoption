import SwiftUI

struct LoginScreen: View {
    
    @State var isEmailVerified = false
    @Binding var showPostPetScreen: Bool
    @EnvironmentObject var session: SessionStore
    func getUser() {
        session.listen()
        
    }
    init(showPostPetScreen: Binding<Bool>) {
        self._showPostPetScreen = showPostPetScreen
    }
    
    var body: some View {
        Group {
            VStack(alignment: .center) {
                Spacer()
                Button(action: closeLoginScreen) {
                    Text("close")
                }
                if (session.session != nil && isEmailVerified) {
                    PostNewDog(showSignUpScreen: $isEmailVerified)
                    
                } else if (session.session != nil && isEmailVerified == false) {
                    VerifyEmailView()
                } else {
                    SignInView(isEmailVerified: $isEmailVerified)
                }
                Spacer()
            }
        }.onAppear(perform: getUser)
    
        
        //        HStack {
        //
        //            VStack {
        //                Spacer()
        //                Button(action: {
        //                    withAnimation {
        //                        self.showPostPetScreen.toggle()
        //                    }
        //                }, label:  { Text("dismiss")})
        //                Spacer()
        //            }
        //
        //        }
    }
    
    func closeLoginScreen() {
        
        UIApplication.shared.endEditing()
        
        withAnimation {
            showPostPetScreen = false
        }
    }
}


struct SignInView: View {
    
    
    @State var email: String = ""
    @State var password: String = ""
    @State var error: String = ""
    @State var showSignUpScreen = false
    @Binding var isEmailVerified: Bool
    @EnvironmentObject var session : SessionStore
    
    init(isEmailVerified: Binding<Bool>) {
        self._isEmailVerified = isEmailVerified
    }
    
    func signIn() {
        session.signIn(email: email, password: password) { (result, error) in
            if let error = error {
                self.error = error.localizedDescription
            } else {
                self.email = ""
                self.password = ""
                isEmailVerified = result?.user.isEmailVerified ?? false
            }
        }
    }
    
    func toggleSignUp() {
        self.showSignUpScreen = true
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
            
            Button(action: toggleSignUp) {
                Text("Sign Up")
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .frame(height: 50) 
                    .foregroundColor(Color.black)
            }
            
            if showSignUpScreen {
                SignUpView(showSignUpScreen: $showSignUpScreen)
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


struct SignUpView: View {
    
    @State var email: String = ""
    @State var password: String = ""
    @State var error: String = ""
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
                self.session.verifyEmail()
                self.email = ""
                self.password = ""
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 15) {
            
            TextField("Email address", text: $email)
                .background(RoundedRectangle(cornerRadius: 5).strokeBorder(Color("offBlack"), lineWidth: 1))
            
            SecureField("Password", text: $password)
                .background(RoundedRectangle(cornerRadius: 5).strokeBorder(Color("offBlack"), lineWidth: 1))
            
            Button(action: signUp) {
                Text("Sign up")
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .frame(height: 50)
                    .foregroundColor(Color.black)
                
            }
        }
    }
}



struct VerifyEmailView: View {
    
    @EnvironmentObject var session: SessionStore
    
    var body: some View {
        
        VStack {
            Text("weve send a conformation mail")
            Button(action: signOut) {
                Text("log out")
            }
            
        }
    }
    
    func signOut() {
        session.signOut()
    }
}



struct TextFieldModifier: ViewModifier {
    func body(content: Content) -> some View {
        
        content.padding(20)
            .background(Color("offLightWhite"))
            .cornerRadius(15)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.black.opacity(0.05), lineWidth: 4)
                    .shadow(color: Color.black.opacity(0.2), radius: 6, x: 5, y: 5)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .shadow(color: Color.black.opacity(0.2), radius: 6, x: -5, y: -5)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
            )
    }
}


struct ButtonModifier: ButtonStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(Color("offLightWhite"))
            .cornerRadius(15)
            .overlay(
                VStack {
                    if configuration.isPressed {
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.black.opacity(0.05), lineWidth: 4)
                            .shadow(color: Color.black.opacity(0.2), radius: 3, x: 5, y: 5)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .shadow(color: Color.black.opacity(0.2), radius: 3, x: -5, y: -5)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                    }
                }
            )
            .shadow(color: Color.black.opacity(configuration.isPressed ? 0 : 0.2), radius: 5, x: 5, y: 5)
            .shadow(color: Color.white.opacity(configuration.isPressed ? 0 : 0.7), radius: 5, x: 5, y: 5)
    }
}
