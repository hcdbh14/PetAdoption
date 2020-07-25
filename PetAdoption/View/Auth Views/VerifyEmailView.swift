import SwiftUI

struct VerifyEmailView: View {
    
    @State var triggerFade = true
    @Binding var showPostPet: Bool
    @Binding var emailVerification: Bool
    @EnvironmentObject var session: SessionStore
    
    init(emailVerification: Binding<Bool>, showPostPet: Binding<Bool>) {
        self._showPostPet = showPostPet
        self._emailVerification = emailVerification
    }
    
    var body: some View {
        
        VStack {
            Text("weve send a conformation mail").foregroundColor(.white)
            Button(action: signOut) {
                Text("log out")
            }
            
            Button(action: checkIfEmailVerified) {
                    Text("check")
            }
        }.opacity(triggerFade ? 0 : 1)
        .onAppear() {
            withAnimation {
                self.triggerFade = false
            }
        }
    }
    
    func signOut() {
        withAnimation { triggerFade = true }
        emailVerification = false
        session.signOut()
    }
    
    func checkIfEmailVerified() {
        print(session.checkIfEmailVerified())
    }
}
