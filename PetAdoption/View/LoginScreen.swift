import SwiftUI

struct LoginScreen: View {
    
    @Binding var showPostPetScreen: Bool
    
    init(showPostPetScreen: Binding<Bool>) {
        self._showPostPetScreen = showPostPetScreen
    }
    
    var body: some View {
        HStack {
       
            VStack {
              Spacer()
                Button(action: {
                    withAnimation {
                        self.showPostPetScreen.toggle()
                    }
                }, label:  { Text("dismiss")})
               Spacer()
            }
           
}
}
}
