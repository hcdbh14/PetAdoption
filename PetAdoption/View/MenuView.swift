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
            
            HStack (spacing: 40) {
                Spacer()
                Image("dog").resizable()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.white)
                Image("cat").resizable()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.white)
                Image("dogAndCat").resizable()
                    .frame(width: 60, height: 40)
                    .foregroundColor(.white)
                Spacer()
            }.padding(.leading, -30)
        }
        .frame(maxWidth: UIScreen.main.bounds.width / 1.2, maxHeight: .infinity, alignment: .topLeading)
        .background(Color("offBlack"))
        .edgesIgnoringSafeArea(.all)
    }
}

private var line: some View {
    VStack {
        Divider()
            .background(Color.orange)
    }
}
