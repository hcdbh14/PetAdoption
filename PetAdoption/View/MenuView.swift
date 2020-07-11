import SwiftUI

struct MenuView: View {
    @Binding var showMenu: Bool
    
    init(showMenu: Binding<Bool>) {
        self._showMenu = showMenu
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("איזה חיה אתם מחפשים?").foregroundColor(.white)
            }

        }
        .frame(width: UIScreen.main.bounds.width / 1.2, height: UIScreen.main.bounds.height - 100, alignment: .leading)
        .background(Color("test"))
        .edgesIgnoringSafeArea(.all)
        .gesture(DragGesture().onEnded {
            if $0.translation.width > -100 {
                withAnimation {
                    self.showMenu = false
                }
            }
        })
    }
}
