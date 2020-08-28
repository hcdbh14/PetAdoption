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
        appearance.configureWithOpaqueBackground()
        appearance.titleTextAttributes = [.font : UIFont.systemFont(ofSize: 20), NSAttributedString.Key.foregroundColor : UIColor.orange]
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().tintColor = .orange
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                
                LazyVGrid(columns: layout, spacing: 20) {
                    ForEach(data, id: \.self) { item in
                        VStack {
                            Capsule()
                                .fill(Color.red)
                                .frame(height: 50)
                        }
                    }
                }.edgesIgnoringSafeArea(.top)
                
//                ForEach(localDB.savedDogsURLS ?? [], id: \.self) { Dog in
//                    SavedCard(imageURL: Dog)
//                }
            }   .background(Color.offWhite.edgesIgnoringSafeArea([.all]))
        }

            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .navigationBarBackButtonHidden(false)
                    .navigationBarTitle(Text("חיות ששמרתם")
                    .foregroundColor(.black)
                    .font(.title), displayMode: .inline)
    }
}
