import SwiftUI

struct LoginScreen: View {
    
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
            if (session.session != nil) {
               PostNewDog()
            } else {
               SignInView()
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
    @EnvironmentObject var session : SessionStore
    
    func signIn() {
        session.signIn(email: email, password: password) { (result, error) in
            if let error = error {
                self.error = error.localizedDescription
            } else {
                self.email = ""
                self.password = ""
            }
            
        }
    }
    
    func toggleSignUp() {
        self.showSignUpScreen = true
    }
    var body: some View {
        VStack {
            Text("Welcome back!")
            Text("Sign in to continue")
            
            VStack {
                TextField("Email address", text: $email)
                    .background(RoundedRectangle(cornerRadius: 5).strokeBorder(Color("offBlack"), lineWidth: 1))
                
                SecureField("Password", text: $password)
                    .background(RoundedRectangle(cornerRadius: 5).strokeBorder(Color("offBlack"), lineWidth: 1))
            }
            Button(action: signIn) {
                Text("Sign in")
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .frame(height: 50)
                    .foregroundColor(Color.black)
                
            }
            
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
                self.email = ""
                self.password = ""
            }
        }
    }
    
    var body: some View {
        VStack {
            Text("Create Account")
                .font(.system(size: 32, weight: .heavy))
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



struct AuthView: View {
    var body: some View {
        VStack {
            SignInView()
        }
    }
    
}
