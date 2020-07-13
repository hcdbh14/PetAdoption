import SwiftUI

struct MenuView: View {
    @Binding var showMenu: Bool
    
    init(showMenu: Binding<Bool>) {
        self._showMenu = showMenu
    }
    
    var body: some View {
        VStack(alignment: .leading) {
                Text("הגדרות")
                    .foregroundColor(.white)
                    .padding(.top, 30)
                    .padding(.leading, 15)
                    .font(.system(size: 34))
            
            line.frame(width: UIScreen.main.bounds.width  / 1.2, height: 1)
            
            Text("איזה חיות להציג?")
                .foregroundColor(.white)
                .padding(.top, 20)
                .padding(.leading, 15)
                .font(.system(size: 24))
            
            line.frame(width: UIScreen.main.bounds.width  / 1.4, height: 1)
                .padding(.leading, 15)

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

private var line: some View {
    VStack {
        Divider()
            .background(Color.orange)
    }
}
