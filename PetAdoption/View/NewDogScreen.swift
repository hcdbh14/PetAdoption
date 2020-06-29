import SwiftUI

struct NewDogScreen: View {
    @Binding var isBarHidden: Bool
    
    init(isBarHidden: Binding<Bool>) {
        self._isBarHidden = isBarHidden
        UINavigationBar.appearance().backgroundColor =  UIColor.clear
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
            .background(Color.offWhite)
            .edgesIgnoringSafeArea(.top)
            .edgesIgnoringSafeArea(.bottom)
    }
}
