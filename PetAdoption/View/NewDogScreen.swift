import SwiftUI

struct NewDogScreen: View {
    @Binding var isBarHidden: Bool
    var body: some View {
        Text("hello")
            .onAppear() {
                self.isBarHidden = true
        }
            .onDisappear() {
                self.isBarHidden = false
        }
    }
}
