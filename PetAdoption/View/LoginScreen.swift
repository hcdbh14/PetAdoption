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
            if (session.session != nil) {
                Text("Welcome back user!")
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
}


struct SignInView: View {
    
    @State var email: String = ""
    @State var password: String = ""
    @State var error: String = ""
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
                    .foregroundColor(Color("offWhite"))
                
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
    var body: some View {
        VStack {
            Text("Sign UP view")
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
