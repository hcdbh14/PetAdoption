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
            }.padding(.top, 50)
            Spacer()
            
            ZStack {
                if  mainVM.frontImage.isEmpty == false {
                    if mainVM.imageURLS.isEmpty == false {
                        BackCard(imageURL: mainVM.imageURLS[mainVM.count] ?? [], scaleTrigger: $scaleAnimation)
                    }
                    
                    Card(imageURL: mainVM.frontImage, displayed: $imageIndex, imageCount: mainVM.frontImage.count, dogName: mainVM.dogsList[mainVM.count - 1].name, age: mainVM.dogsList[mainVM.count - 1].age, scaleTrigger: $scaleAnimation)
                        .animation(.default)
                }
            }.zIndex(2)
            
            ZStack(alignment: .top) {
                BarButtons()
                    .padding(.bottom, 50)
                    .padding(.horizontal, 22)
                    .background(ButtomBar())
            }.zIndex(1)
            
        }.background(Color.offWhite)
            
            .onAppear(perform: mainVM.getDogsFromDB)
            .edgesIgnoringSafeArea(.top)
            .edgesIgnoringSafeArea(.bottom)
        
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
            
        }.fill(Color.offWhite)
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
                    .foregroundColor(.blue)
            }
            .buttonStyle(CircleButtonStyle(isBig: false))
            Spacer(minLength: 12)
            
            Button(action: {
                print("pressed")
                
            }) {
                Image(systemName: "xmark").resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.orange)
            }
            .buttonStyle(CircleButtonStyle(isBig: true))
            
            
            Spacer(minLength: 12)
            
            Button(action: {
                print("pressed")
            }) {
                Image(systemName: "suit.heart.fill").resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.pink)
            }
            .buttonStyle(CircleButtonStyle(isBig: true))
            Spacer(minLength: 12)
            
            Button(action: {
                print("pressed")
            }) {
                Image(systemName: "square.and.arrow.up")
                    .foregroundColor(.purple)
            }
            .buttonStyle(CircleButtonStyle(isBig: false))
        }
    }
}





