import SwiftUI
import FirebaseStorage

enum barItem {
    case first
    case second
    case third
    case forth
}

struct MainScreen: View {
    
    @State var shown = false
    @State var imageURL = ""
    
    @ObservedObject var mainVM = MainVM()
    
    @State var selected = barItem.first
    
    var body: some View {
        
        NavigationView {
            
            VStack {
                ZStack {
                    if mainVM.dogsImages.isEmpty == false {
                        ForEach(0...mainVM.dogsImages.count - 1,id: \.self) { i in
                            Card(imageURL: self.mainVM.dogsImages[i][0])
                                .offset(x: self.mainVM.x[i])
                                .rotationEffect(.init(degrees: self.mainVM.degree[i]))
                                .gesture(DragGesture()
                                    .onChanged({ (value) in
                                        if value.translation.width > 0 {
                                            self.mainVM.x[i] = value.translation.width
                                            self.mainVM.degree[i] = 8
                                        } else {
                                            self.mainVM.x[i] = value.translation.width
                                            self.mainVM.degree[i] = -8
                                        }
                                    })
                                    .onEnded({ (value) in
                                        if value.translation.width > 0 {
                                            if value.translation.width > 100 {
                                                self.mainVM.x[i] = 500
                                                self.mainVM.degree[i] = 15
                                            } else {
                                                self.mainVM.x[i] = 0
                                                self.mainVM.degree[i] = 0
                                            }
                                        } else {
                                            if value.translation.width < -100 {
                                                self.mainVM.x[i] = -500
                                                self.mainVM.degree[i] = -15
                                            } else {
                                                self.mainVM.x[i] = 0
                                                self.mainVM.degree[i] = 0
                                            }
                                        }
                                    }))
                        }.animation(.default)
                    }
                }
                
                Spacer()
                ZStack(alignment: .top) {
                    BarButtons(selected: self.$selected)
                        .padding()
                        .padding(.horizontal, 22)
                        .background(ButtomBar())
                    
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
    func test() {
        
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
