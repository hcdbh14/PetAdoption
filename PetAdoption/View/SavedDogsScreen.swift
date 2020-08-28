import SwiftUI

struct SavedDogsScreen: View {
    
    let data = Array(1...100).map { "Item \($0)" }
    
    @Binding private var isBarHidden: Bool
    @State private var localDB = LocalDB()
    
    let layout = [
        GridItem(.adaptive(minimum: 80))
    ]
    
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
            ScrollView {
                
                LazyVGrid(columns: layout, spacing: 20) {
                    ForEach(data, id: \.self) { item in
                        VStack {
                            Capsule()
                                .fill(Color.red)
                                .frame(height: 50)
                        }
                    }
                }
                
//                ForEach(localDB.savedDogsURLS ?? [], id: \.self) { Dog in
//                    SavedCard(imageURL: Dog)
//                }
            }.frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height + 180)
                .background(Color.offWhite.edgesIgnoringSafeArea([.all]))
                .navigationBarTitle(Text("פרסום מודעה")
                    .foregroundColor(.black)
                    .font(.title), displayMode: .inline)
                .onDisappear() {
                    self.isBarHidden = false
            }
    }
}
