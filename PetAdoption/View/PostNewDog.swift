import SwiftUI

struct PostNewDog: View {
    
    @State var triggerFade = true
    @Binding var showPostPet: Bool
    @Binding var showAuthScreen: Bool
    @EnvironmentObject var session: SessionStore
    
    init(showAuthScreen: Binding<Bool>, showPostPet: Binding<Bool>) {
        self._showPostPet = showPostPet
        self._showAuthScreen = showAuthScreen
    }
    
    var body: some View {
        VStack {
            HStack {
                Button(action: closeLoginScreen) {
                    HStack {
                        Image(systemName: "chevron.right")
                        Text("חזור")
                    }
                }
                .foregroundColor(Color("orange"))
                .padding(.leading, 25)
                Spacer()
                
                if session.session != nil {
                    Button(action: signOut) {
                        Text("התנתקות")
                            .foregroundColor(Color("orange"))
                            .padding(.trailing, 15)
                    }
                }
            }.padding(.top, 10)
            

            
            Text("וואלה ברכות, הצלחת להיכנס לחשבון כמו מלכה")
                .font(.system(size: 30, weight: .heavy))
                .foregroundColor(.black)
                .padding(.leading, 25)
                .padding(.top, 25)
                .opacity(triggerFade ? 0 : 1)
                .onAppear() {
                    withAnimation {
                        self.triggerFade = false
                    }
            }
        }.frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height, alignment: .topLeading)
            .background(Color("offWhite"))
        
    }
    
    func closeLoginScreen() {
        
        UIApplication.shared.endEditing()
        
        withAnimation {
            showAuthScreen = false
        }
    }
    
    func signOut() {
        session.signOut()
        showPostPet = false
    }
}
