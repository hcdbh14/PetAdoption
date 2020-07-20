import SwiftUI

struct LoginScreen: View {
    
    @State var showLogin = false
    @State var showRegistration = false
    
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
            VStack(alignment: .leading) {
                
                HStack {
                    Button(action: closeLoginScreen) {
                        Text("חזור")
                            .padding(25)
                    }
                    Spacer()
                }.padding(.bottom, 20)
          
                if (session.session != nil && isEmailVerified) {
                    PostNewDog(showSignUpScreen: $isEmailVerified)
                    
                } else if (session.session != nil && isEmailVerified == false) {
                    VerifyEmailView()
                } else {
                    SignUpView(showLogin: $showLogin, showRegistration: $showRegistration)
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
