import SwiftUI
import FirebaseStorage

enum barItem {
    case first
    case second
    case third
    case forth
}

struct MainScreen: View {
    
    @State var imageIndex = 0
    @EnvironmentObject var mainVM: MainVM
    
    @State var selected = barItem.first
    
    var body: some View {
        
        NavigationView {
            
            VStack {
                Spacer()
                ZStack {
                    if mainVM.dogsImages.isEmpty == false && mainVM.frontImage.isEmpty == false {
                        
                        Card(imageURL: self.mainVM.dogsImages[self.mainVM.count]?[0] ?? "" , displayed: self.$imageIndex, imageCount: self.mainVM.dogsImages[self.mainVM.count]?.count ?? 1).animation(.default)
                        
                        Card(imageURL: self.mainVM.frontImage[self.imageIndex], displayed: self.$imageIndex, imageCount: self.mainVM.frontImage.count )
                            .animation(.default)
                        
                    }
                }
                Spacer()
                ZStack(alignment: .top) {
                    BarButtons(selected: self.$selected)
                        .padding()
                        .padding(.horizontal, 22)
                        .background(ButtomBar())
                }
                
                
                
            }.background(Color.white).edgesIgnoringSafeArea(.top)
            
            //                    .onAppear() {
            ////                        self.mainVM.loadDataFromFirebase()
            ////                        self.mainVM.ref.childByAutoId().setValue(["name": "Tom", "age": 5, "images": ["pug.jpg", "doggie2.jpg"]])
            //                }
        }.background(Color.white)
            .navigationBarTitle("Doggo app", displayMode: .inline)
            .navigationBarItems(leading: Image(systemName: "person"), trailing: Image("dog").resizable().frame(width: 30, height: 30))
            .onAppear(perform: mainVM.loadDataFromFirebase)
    }
}


struct ButtomBar: View {
    
    var body : some View {
        Path{ path in
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: UIScreen.main.bounds.width, y: 0))
            path.addLine(to: CGPoint(x: UIScreen.main.bounds.width, y: 55))
            path.addLine(to: CGPoint(x: 0, y: 55))
            
        }.fill(Color.white)
            .rotationEffect(.init(degrees: 180))
    }
}

struct BarButtons : View {
    
    @Binding var selected: barItem
    
    var body : some View {
        HStack {
            Button(action: {
                self.selected = .first
                
            }) {
                Image(systemName: "info.circle")
            }.foregroundColor(self.selected == .first ? .black : .gray)
            
            Spacer(minLength: 12)
            
            Button(action: {
                self.selected = .second
                
            }) {
                Image(systemName: "xmark")
            }.foregroundColor(self.selected == .second ? .black : .gray)
            
            Spacer(minLength: 12)
            
            Button(action: {
                self.selected = .third
            }) {
                Image(systemName: "suit.heart.fill")
            }.foregroundColor(self.selected == .third ? .black : .gray)
            
            Spacer(minLength: 12)
            
            Button(action: {
                self.selected = .forth
            }) {
                Image(systemName: "square.and.arrow.up")
            }.foregroundColor(self.selected == .forth ? .black : .gray)
            
            
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainScreen()
    }
}
