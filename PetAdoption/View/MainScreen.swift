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
            }.padding(.top, 30)
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
            
        }.background(Color.offWhite)
            .onAppear(perform: mainVM.getDogsFromDB)
            .edgesIgnoringSafeArea(.top)
        
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
            }.foregroundColor(.gray)
                .buttonStyle(CircleButtonStyle(isBig: false))
            Spacer(minLength: 12)
            
            Button(action: {
                print("pressed")
                
            }) {
                Image(systemName: "xmark")
            }.foregroundColor(.gray)
                .buttonStyle(CircleButtonStyle(isBig: true))

                
            Spacer(minLength: 12)
            
            Button(action: {
                print("pressed")
            }) {
                Image(systemName: "suit.heart.fill")
            }.foregroundColor(.gray)
                .buttonStyle(CircleButtonStyle(isBig: true))
            Spacer(minLength: 12)
            
            Button(action: {
                print("pressed")
            }) {
                Image(systemName: "square.and.arrow.up")
            }.foregroundColor(.gray)
                .buttonStyle(CircleButtonStyle(isBig: false))
        }
    }
}





