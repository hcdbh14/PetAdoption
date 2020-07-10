import SwiftUI

struct MenuView: View {
    @Binding var showMenu: Bool
    
    init(showMenu: Binding<Bool>) {
        self._showMenu = showMenu
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Button(action: {
                    withAnimation {
                        self.showMenu = false
                    }
                    
                }) {
                    Image(systemName: "person")
                        .foregroundColor(.white)
                        .imageScale(.large)
                }
                Text("Profile")
                    .foregroundColor(.white)
                    .font(.headline)
            }
            .padding(.top, 100)
            
            HStack {
                Image(systemName: "envelope")
                    .foregroundColor(.white)
                    .imageScale(.large)
                Text("Messages")
                    .foregroundColor(.white)
                    .font(.headline)
            }
            Spacer()
        }
        .frame(width: UIScreen.main.bounds.width / 1.2, alignment: .leading)
        .background(Color("test"))
        .edgesIgnoringSafeArea(.all)
        .gesture(DragGesture().onEnded {
            if $0.translation.width < -100 {
                withAnimation {
                    self.showMenu = false
                }
            }
        })
       
    }
}
