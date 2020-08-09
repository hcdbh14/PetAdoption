import SwiftUI
import Firebase

struct VerifyEmailView: View {
    
    @State private var error: String = ""
    @State private var triggerFade = true
    @Binding private var showPostPet: Bool
    @State private var emailVerified = false
    @Binding private var emailVerification: Bool
    @State private var waitingForResponse = false
    @EnvironmentObject private var session: SessionStore
    
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
                    .padding(.top, 50)
                Spacer()
            }
            
            
            Button(action: sendMailAgain) {
                Text("לא קיבלתי מייל, שלחו שוב")
                    .foregroundColor(.orange)
                    .font(.system(size: 16, weight: .semibold))
            }
            
            Button(action: checkIfEmailVerified) {
                if waitingForResponse {
                    
                    ActivityIndicator(isAnimating: true)
                        .configure { $0.color = .white }
                } else {
                    Text("קיבלתי את המייל ואישרתי")
                        .frame(width: UIScreen.main.bounds.width - 100, height: 50)
                        .foregroundColor(.white)
                        .background(Color("orange"))
                        .cornerRadius(30)
                        .shadow(radius: 5)
                }
            }.frame(width: UIScreen.main.bounds.width - 100, height: 50)
                .foregroundColor(.white)
                .background(Color("orange"))
                .cornerRadius(30)
                .shadow(radius: 5)
                .disabled(waitingForResponse)
                .padding(15)
            
            Text(error)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.red)
                .frame(width: UIScreen.main.bounds.width, height: 16, alignment: .center)
                     .padding(.bottom, 133)
        }.opacity(triggerFade ? 0 : 1)
            .onAppear() {
                withAnimation {
                    self.triggerFade = false
                }
        }
    }
    
    private func sendMailAgain() {
        self.session.verifyEmail()
    }
    
    private func checkIfEmailVerified() {
        waitingForResponse = true
        
        session.checkIfEmailVerified() { (error) in
            if let error = error {
                print(error.localizedDescription)
                self.waitingForResponse = false
            } else {
                self.emailVerified = Auth.auth().currentUser?.isEmailVerified ?? false
                
                if self.emailVerified {
                    withAnimation {
                    self.emailVerification = false
                    self.showPostPet = true
                    }
                } else {
                    self.error = "החשבון עדין לא מאומת"
                }
                self.waitingForResponse = false
            }
        }
    }
}
