import SwiftUI
import Firebase

enum barItem {
    case first
    case second
    case third
    case forth
}

struct ContentView: View {
    
    @State var selected = barItem.first
    let ref = Database.database().reference()
    
    var body: some View {
        VStack {
            Spacer()
            ZStack(alignment: .top) {
                BottomBar(selected: self.$selected)
                    .padding()
                    .padding(.horizontal, 22)
                    .background(CurvedShape())
                
                Button(action: {
                    print("main image")
                })  {
                    Image(systemName: "hare").renderingMode(.original).padding(24)
                }.background(Color.yellow)
                    .clipShape(Circle())
                    .offset(y: -35)
                    .shadow(radius: 5)
                
            }.background(Color.white).edgesIgnoringSafeArea(.top)
                
                .onAppear() {
                    self.ref.child("test/name").setValue("Kenny")
                    self.ref.childByAutoId().setValue(["name":"Tom", "role":"Admin", "age": 30])
            }
        }.background(Color.black)
    }
}
    
    struct CurvedShape: View {
        
        var body : some View {
            Path{ path in
                path.move(to: CGPoint(x: 0, y: 0))
                path.addLine(to: CGPoint(x: UIScreen.main.bounds.width, y: 0))
                path.addLine(to: CGPoint(x: UIScreen.main.bounds.width, y: 55))
                
                path.addArc(center: CGPoint(x: UIScreen.main.bounds.width / 2, y: 55), radius: 30, startAngle: .zero, endAngle: Angle.init(degrees: 180), clockwise: true)
                path.addLine(to: CGPoint(x: 0, y: 55))
                
            }.fill(Color.white)
                .rotationEffect(.init(degrees: 180))
        }
    }
    
    struct BottomBar : View {
        
        @Binding var selected: barItem
        
        var body : some View {
            HStack {
                Button(action: {
                    self.selected = .first
                   
                }) {
                    Image(systemName: "desktopcomputer")
                }.foregroundColor(self.selected == .first ? .black : .gray)
                
                Spacer(minLength: 12)
                
                Button(action: {
                    self.selected = .second
                  
                }) {
                    Image(systemName: "keyboard")
                }.foregroundColor(self.selected == .second ? .black : .gray)
                
                Spacer().frame(width: 120)
                
                Button(action: {
                    self.selected = .third
                }) {
                    Image(systemName: "person")
                }.foregroundColor(self.selected == .third ? .black : .gray)
                
                Spacer(minLength: 12)
                
                Button(action: {
                    self.selected = .forth
                }) {
                    Image(systemName: "person")
                }.foregroundColor(self.selected == .forth ? .black : .gray)
                
               
            }
        }
    }
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
}
