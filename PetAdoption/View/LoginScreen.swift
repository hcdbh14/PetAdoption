import SwiftUI

struct LoginScreen: View {
    
    @State var showLogin = false
    @State var showRegistration = false
    @State var isEmailVerified = false
    @Binding var showPostPetScreen: Bool
    @EnvironmentObject var session: SessionStore
    
    init(showPostPetScreen: Binding<Bool>) {
        self._showPostPetScreen = showPostPetScreen
    }
    
    var body: some View {
        VStack(alignment: .leading) {
                
                
                HStack {
                    Button(action: closeLoginScreen) {
                        HStack {
                            Image(systemName: "chevron.right")
                            Text("חזור")
                        }
                    }
                    .foregroundColor(Color("orange"))
                    .padding(.top, 60)
                    .padding(.leading, 25)
                    Spacer()
                }
                ZStack {
                    Image("bone").resizable()
                        .renderingMode(.template)
                        .frame(width: 80, height: 80)
                        .opacity(0.8)
                        .foregroundColor(.orange)
                    
                }.frame(width: UIScreen.main.bounds.width, alignment: .trailing)
                .padding(.bottom, -40)
                
                if (session.session != nil && isEmailVerified) {
                    PostNewDog(showSignUpScreen: $isEmailVerified)
                    
                } else if (session.session != nil && isEmailVerified == false) {
                    VerifyEmailView()
                } else if (showLogin) {
                    SignInView(isEmailVerified: $isEmailVerified, showLogin: $showLogin, showRegistration: $showRegistration)
                } else {
                    SignUpView(showLogin: $showLogin, showRegistration: $showRegistration)
                }
                
                Spacer()
                HStack {
                    Image("cuteDog").resizable()
                        .renderingMode(.template)
                        .frame(width: 200, height: 200)
                        .foregroundColor(.orange)
                        .opacity(0.8)
                    Spacer()
                    
                }.frame(width: UIScreen.main.bounds.width)
                    .padding(.bottom, -15)
            }.onAppear(perform: startSession)
    }
    
    
    func startSession() {
        session.listen()
    }
    
    
    func closeLoginScreen() {
        
        UIApplication.shared.endEditing()
        
        withAnimation {
            showPostPetScreen = false
        }
    }
}
