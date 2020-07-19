import SwiftUI

struct PostNewDog: View {
    
    @Binding var showSignUpScreen: Bool
    @EnvironmentObject var session: SessionStore
    
    
    init(showSignUpScreen: Binding<Bool>) {
        self._showSignUpScreen = showSignUpScreen
    }
    var body: some View {
        VStack {
        Text("Welcome back user!")
            Button(action: signOut) {
                Text("log out")
            }
        }
    }
    
    func signOut() {
        session.signOut()
    }
}


