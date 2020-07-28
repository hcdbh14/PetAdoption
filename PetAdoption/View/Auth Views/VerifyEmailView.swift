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
        
        VStack(spacing: 8) {
            
            
            HStack {
                Text("נשלח מייל לאימות החשבון")
                    .font(.system(size: 30, weight: .heavy))
                    .foregroundColor(.white)
                    .padding(.leading, 25)
                Spacer()
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
    
    func checkIfEmailVerified() {
        print(session.checkIfEmailVerified())
    }
}
