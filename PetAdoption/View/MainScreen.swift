import SwiftUI
import FirebaseStorage

enum barItem {
    case first
    case second
    case third
    case forth
}

struct MainScreen: View {
    @State private var staticIndex = 0
    @State private var imageIndex = 0
    @State private var scaleAnimation = false
    @State private var selected = barItem.first
    @EnvironmentObject var mainVM: MainVM
    
    var body: some View {
        
        VStack {
            HStack {
                Image(systemName: "person").padding(.leading, 10)
                Spacer()
                Image(systemName: "person").padding(.trailing, 10)
            }.padding(.top, 5)
            Spacer()
            ZStack(alignment: .top) {
                BarButtons()
                    .padding()
                    .padding(.horizontal, 22)
                    .background(ButtomBar())
            }
            ZStack {
                if  mainVM.frontImage.isEmpty == false {
                    if mainVM.imageURLS.isEmpty == false {
                        BackCard(imageURL: mainVM.imageURLS[mainVM.count] ?? [], scaleTrigger: $scaleAnimation)
                    }
                    
                    Card(imageURL: mainVM.frontImage, displayed: $imageIndex, imageCount: mainVM.frontImage.count, dogName: mainVM.dogsList[mainVM.count - 1].name, age: mainVM.dogsList[mainVM.count - 1].age, scaleTrigger: $scaleAnimation)
                        .animation(.default)
                }
            }.padding(.top, (UIScreen.main.bounds.height / 1.16) * -1)
                .onAppear() {
                    print((UIScreen.main.bounds.height / 1.16) * -1)
            }

        }.background(Color.white)
            .onAppear(perform: mainVM.getDogsFromDB)
        
        //                    .onAppear() {
        ////                        self.mainVM.getDogsFromDB()
        ////                        self.mainVM.ref.childByAutoId().setValue(["name": "Tom", "age": 5, "images": ["pug.jpg", "doggie2.jpg"]])
        //                }
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
    

    var body : some View {
        HStack {
            Button(action: {
               print("pressed")
                
            }) {
                Image(systemName: "info.circle")
            }.foregroundColor(.gray)
            
            Spacer(minLength: 12)
            
            Button(action: {
                print("pressed")
                
            }) {
                Image(systemName: "xmark")
            }.foregroundColor(.gray)
            
            Spacer(minLength: 12)
            
            Button(action: {
              print("pressed")
            }) {
                Image(systemName: "suit.heart.fill")
            }.foregroundColor(.gray)
                .buttonStyle(CircleButtonStyle())
            Spacer(minLength: 12)
            
            Button(action: {
               print("pressed")
            }) {
                Image(systemName: "square.and.arrow.up")
            }.foregroundColor(.gray)
        }
    }
}


struct CircleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
        .padding(30)
        .contentShape(Circle())
        .background(
       Circle()
        .fill(Color.offWhite)
        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
        .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
        )
    }
}

extension Color {
    static let offWhite = Color(red: 225 / 255, green: 225 / 255, blue: 235 / 255)
}
