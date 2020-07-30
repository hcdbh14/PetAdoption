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
            }.padding(.top, 30)
            

            
            HStack {
                Text("תמונות")
                    .font(.system(size: 30, weight: .heavy))
                    .foregroundColor(.black)
                    .padding(.leading, 25)
                Spacer()
            }.onAppear() {
                    withAnimation {
                        self.triggerFade = false
                    }
            }
            HStack {
               imagePlacerHolder()
            }
            
            HStack {
                 imagePlacerHolder()
                 imagePlacerHolder()
                 imagePlacerHolder()
            }
            
        }.frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height, alignment: .topLeading)
            .background(Color("offWhite").frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height + 20, alignment: .bottom).edgesIgnoringSafeArea(.bottom))
        
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


struct imagePlacerHolder: View {
    
     var body: some View {
        
            Image(uiImage: UIImage())
            .frame(width: 100, height: 150)
                .background(Color("offGray"))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .strokeBorder(
                        style: StrokeStyle(
                            lineWidth: 2,
                            dash: [15]
                        )
                    )
                    .foregroundColor(.gray)
            )
    }
}
