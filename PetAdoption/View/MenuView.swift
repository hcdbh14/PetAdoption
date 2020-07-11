import SwiftUI

struct MenuView: View {
    @Binding var showMenu: Bool
    
    init(showMenu: Binding<Bool>) {
        self._showMenu = showMenu
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("הגדרות")
                    .foregroundColor(.white)
                    .padding(.top, 20)
                    .padding(.leading, 10)
                    .font(.system(size: 34))
            }

        }
        .frame(maxWidth: UIScreen.main.bounds.width / 1.2, maxHeight: .infinity, alignment: .topLeading)
        .background(Color("offBlack"))
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
