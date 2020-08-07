import SwiftUI

struct AuthViewManager: View {
    
    @State var showLogin = false
    @State var showPostPet = false
    @State var EmailVerification = false
    @State var showForgotPassword = false
    @Binding var showAuthScreen: Bool
    @EnvironmentObject var session: SessionStore
    
    init(showPostPetScreen: Binding<Bool>) {
        self._showAuthScreen = showPostPetScreen
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            
            if showPostPet == false && session.checkIfUserCanEnter() == false {
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
                    
                    if session.session != nil && EmailVerification {
                        Button(action: signOut) {
                            Text("התנתקות")
                                .foregroundColor(Color("orange"))
                                .padding(.top, 60)
                                .padding(.trailing, 25)
                        }
                    }
                }.opacity(showPostPet || session.checkIfUserCanEnter() ? 0 : 1)
            }
            
            if showPostPet || session.checkIfUserCanEnter() == false {
                ZStack {
                    Image("bone").resizable()
                        .renderingMode(.template)
                        .frame(width: 80, height: 80)
                        .opacity(showPostPet || session.checkIfUserCanEnter() ? 0 : 0.8)
                        .foregroundColor(.orange)
                    
                }.frame(width: UIScreen.main.bounds.width, alignment: .trailing)
                    .padding(.bottom, -40)
            }
            
            if (session.session != nil && EmailVerification == false && showPostPet || session.checkIfUserCanEnter()) {
                PostNewDog(showAuthScreen: $showAuthScreen, showPostPet: $showPostPet)
                
            } else if (session.session != nil && EmailVerification) {
                VerifyEmailView(emailVerification: $EmailVerification, showPostPet: $showPostPet)
                
            } else if (showLogin) {
                SignInView(emailVerification: $EmailVerification, showLogin: $showLogin, forgotPassword: $showForgotPassword, showPostPet: $showPostPet)
            } else if (showForgotPassword) {
                ForgotPasswordView(showLogin: $showLogin, forgotPassword: $showForgotPassword)
            } else {
                SignUpView(showLogin: $showLogin, emailVerification: $EmailVerification)
            }
            
            Spacer()
            HStack {
                Image("cuteDog").resizable()
                    .renderingMode(.template)
                    .frame(width: 200, height: 200)
                    .foregroundColor(.orange)
                    .opacity(showPostPet || session.checkIfUserCanEnter() ? 0 : 0.8)
                Spacer()
                
            }.frame(width: UIScreen.main.bounds.width + 20)
                .background(Color("offBlack"))
                .padding(.leading, -20)
            
        }.onAppear(perform: startSession)
    }
    
    
    func startSession() {
        session.listen()
    }
    
    func signOut() {
        session.signOut()
        showLogin = true
        showPostPet = false
        EmailVerification = false
    }
    
    func closeLoginScreen() {
        
        UIApplication.shared.endEditing()
        
        withAnimation {
            showAuthScreen = false
        }
    }
}
