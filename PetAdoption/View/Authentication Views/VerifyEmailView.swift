import SwiftUI

struct VerifyEmailView: View {
    
    @State var triggerFade = true
    @Binding var emailVerification: Bool
    @EnvironmentObject var session: SessionStore
    
    init(emailVerification: Binding<Bool>) {
        self._emailVerification = emailVerification
    }
    
    var body: some View {
        
        VStack {
            Text("weve send a conformation mail")
            Button(action: signOut) {
                Text("log out")
            }
        }.opacity(triggerFade ? 0 : 1)
        .onAppear() {
            withAnimation {
                self.triggerFade = false
            }
        }
    }
    
    func signOut() {
        emailVerification = false
        session.signOut()
    }
}
