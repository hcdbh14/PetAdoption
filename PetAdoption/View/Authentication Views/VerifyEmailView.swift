import SwiftUI

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
