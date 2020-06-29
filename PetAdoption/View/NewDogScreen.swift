import SwiftUI

struct NewDogScreen: View {
    @Binding var isBarHidden: Bool
    
    init(isBarHidden: Binding<Bool>) {
        self._isBarHidden = isBarHidden
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.titleTextAttributes = [.font : UIFont.systemFont(ofSize: 20), NSAttributedString.Key.foregroundColor : UIColor.black]
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().tintColor = .black
    }
    
    var body: some View {
        VStack {
            Text("hello")
                .onAppear() {
                    self.isBarHidden = true
            }
            .onDisappear() {
                self.isBarHidden = false
            }
        }.frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height + 180)
            .background(Color.offWhite.edgesIgnoringSafeArea([.all]))
               .navigationBarTitle(Text("פרסום מודעה")
                  .foregroundColor(.black)
                  .font(.title), displayMode: .inline)
    }
}
