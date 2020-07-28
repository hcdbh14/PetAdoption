import SwiftUI
import Firebase

struct VerifyEmailView: View {
    
    @State var emailVerified = false
    @State var error: String = ""
    @State var waitingForResponse = false
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
            
            Spacer()
            HStack {
                Text("נשלח מייל לאימות החשבון")
                    .font(.system(size: 30, weight: .heavy))
                    .foregroundColor(.white)
                    .padding(.leading, 25)
                Spacer()
            }
            
            Button(action: checkIfEmailVerified) {
                if waitingForResponse {
                    
                    ActivityIndicator(isAnimating: true)
                        .configure { $0.color = .white }
                } else {
                    Text("קיבלתי את המייל וסיימתי את האימות")
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
            
            
            
        }.opacity(triggerFade ? 0 : 1)
            .onAppear() {
                withAnimation {
                    self.triggerFade = false
                }
        }
    }
    
    func checkIfEmailVerified() {
        session.checkIfEmailVerified() { (error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                self.emailVerified = Auth.auth().currentUser?.isEmailVerified ?? false
            }
        }
    }
}
