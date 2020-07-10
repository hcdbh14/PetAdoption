import SwiftUI

struct MenuView: View {
    @Binding var showMenu: Bool
    
    init(showMenu: Binding<Bool>) {
        self._showMenu = showMenu
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "person")
                    .foregroundColor(.gray)
                    .imageScale(.large)
                    .onTapGesture {
                        withAnimation {
                            self.showMenu = false
                        }
                        
                    }
                Text("Profile")
                    .foregroundColor(.gray)
                    .font(.headline)
            }
            .padding(.top, 100)
            
            HStack {
                Image(systemName: "envelope")
                    .foregroundColor(.gray)
                    .imageScale(.large)
                Text("Messages")
                    .foregroundColor(.gray)
                    .font(.headline)
            }
            Spacer()
        }
        .frame(width: UIScreen.main.bounds.width / 2, alignment: .leading)
        .background(Color.black
        .edgesIgnoringSafeArea(.all)
        )
    }
}
