import SwiftUI
import FirebaseStorage

enum barItem {
    case first
    case second
    case third
    case forth
}

struct MainScreen: View {
    @State private var showNewDogScreen = false
    @State private var isBarHidden = false
    @State private var imageIndex = 0
    @State private var staticIndex = 0
    @State private var scaleAnimation = false
    @State private var selected = barItem.first
    @EnvironmentObject var mainVM: MainVM
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Image(systemName: "person").padding(.leading, 10).foregroundColor(.black)
                    Spacer()
                    NavigationLink (destination: NewDogScreen(isBarHidden: $isBarHidden), isActive: $showNewDogScreen) {
                        Image(systemName: "person").padding(.trailing, 10).foregroundColor(.black)
                    }
                }.padding(.top, 50)
                Spacer()
                
                
                ZStack {
                    if  mainVM.frontImage.isEmpty == false {
                        if mainVM.imageURLS.isEmpty == false {
                            BackCard(imageURL: mainVM.imageURLS[mainVM.count] ?? [], scaleTrigger: $scaleAnimation)
                        }
                        
                        Card(imageURL: mainVM.frontImage, displayed: $imageIndex, imageCount: mainVM.frontImage.count, dogName: mainVM.dogsList[mainVM.count - 1].name, age: mainVM.dogsList[mainVM.count - 1].age, dogDesc: mainVM.dogsList[mainVM.count - 1].desc, scaleTrigger: $scaleAnimation, mainVM: mainVM)
                            .animation(.default)
                    }
                }.zIndex(2)
                
                Spacer()
                ZStack(alignment: .top) {
                    BarButtons()
                        .padding(.bottom, UIScreen.main.bounds.height / 10)
                        .padding(.horizontal, 22)
                        .background(ButtomBar())
                }.zIndex(1)
            }
            .edgesIgnoringSafeArea(.bottom)
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height + 20)
            .background(Color.offWhite)
            .navigationBarTitle("")
            .navigationBarHidden(isBarHidden ? false : true)
        }
        //                    .onAppear() {
        ////                        self.mainVM.getDogsFromDB()
        ////                        self.mainVM.ref.childByAutoId().setValue(["name": "Tom", "age": 5, "images": ["pug.jpg", "doggie2.jpg"]])
        //                }
    }
}





