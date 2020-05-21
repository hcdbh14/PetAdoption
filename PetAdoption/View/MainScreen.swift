import SwiftUI
import Firebase
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
    @State var x: [CGFloat] = [0,0,0,0,0,0,0]
    @State var degree: [Double] = [0,0,0,0,0,0,0]
    @State var selected = barItem.first
    let ref = Database.database().reference()
    
    var body: some View {
        
        NavigationView {
                       
            VStack {
                ZStack {
                    ForEach(0...mainVM.dogArray.count - 1,id: \.self) { i in
                        Card(imageURL: self.mainVM.dogArray[i])
                            .offset(x: self.x[i])
                            .rotationEffect(.init(degrees: self.degree[i]))
                            .gesture(DragGesture()
                                .onChanged({ (value) in
                                    if value.translation.width > 0 {
                                        self.x[i] = value.translation.width
                                        self.degree[i] = 8
                                    } else {
                                        self.x[i] = value.translation.width
                                        self.degree[i] = -8
                                    }
                                })
                                .onEnded({ (value) in
                                    if value.translation.width > 0 {
                                        if value.translation.width > 100 {
                                            self.x[i] = 500
                                            self.degree[i] = 15
                                        } else {
                                            self.x[i] = 0
                                            self.degree[i] = 0
                                        }
                                    } else {
                                        if value.translation.width < -100 {
                                            self.x[i] = -500
                                            self.degree[i] = -15
                                        } else {
                                            self.x[i] = 0
                                            self.degree[i] = 0
                                        }
                                    }
                                }))
                    }.animation(.default)
                }
                
                Spacer()
                ZStack(alignment: .top) {
                    BarButtons(selected: self.$selected)
                        .padding()
                        .padding(.horizontal, 22)
                        .background(ButtomBar())
                    
                }.background(Color.white).edgesIgnoringSafeArea(.top)
                    
                    .onAppear() {
                        //                    self.ref.child("test/name").setValue("Kenny")
                        //                    self.ref.childByAutoId().setValue(["name":"Tom", "role":"Admin", "age": 30])
                }
            }.background(Color.white)
                .navigationBarTitle("Doggo app", displayMode: .inline)
                .navigationBarItems(leading: Image(systemName: "person"), trailing: Image("dog").resizable().frame(width: 30, height: 30))
                .onAppear(perform: mainVM.loadImageFromFirebase)
        }
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
