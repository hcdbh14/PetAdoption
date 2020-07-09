import SwiftUI
import FirebaseStorage

enum barItem {
    case first
    case second
    case third
    case forth
}

struct MainScreen: View {
    
    @State private var showMenu = false
    @State private var showNewDogScreen = false
    @State private var isBarHidden = false
    @State private var staticIndex = 0
    @State private var scaleAnimation = false
    @State private var selected = barItem.first
    @EnvironmentObject var mainVM: MainVM
    
    var body: some View {
        ZStack (alignment: .leading) {
            NavigationView {
                
                VStack {
                    HStack {
                        Button(action: {
                            withAnimation {
                                self.showMenu = true
                            }
                        }) {
                            Image("settings").resizable()
                                .frame(width: 25, height: 25)
                                .padding(.leading, 10).foregroundColor(.gray)
                                .animation(.default)
                        }
                        
                        
                        Spacer()
                        Text(self.mainVM.localDB.savedDogsCount)
                            .foregroundColor(.black)
                            .animation(.default)
                        NavigationLink (destination: NewDogScreen(isBarHidden: $isBarHidden), isActive: $showNewDogScreen) {
                            Image("dog").resizable()
                                .frame(width: 25, height: 25)
                                .padding(.trailing, 10)
                                .animation(.default)
                        }
                    }.padding(.top, 50)
                    Spacer()
                    
                    
                    ZStack {
                        if  mainVM.frontImages.isEmpty == false {
                            if mainVM.backImages.isEmpty == false {
                                BackCard(scaleTrigger: $scaleAnimation, mainVM: mainVM)
                            }
                            
                            Card(imageCount: mainVM.dogsList[mainVM.count - 1].images.count, dogName: mainVM.dogsList[mainVM.count - 1].name, age: mainVM.dogsList[mainVM.count - 1].age, dogDesc: mainVM.dogsList[mainVM.count - 1].desc, scaleTrigger: $scaleAnimation, showMenu: $showMenu, mainVM: mainVM)
                        }
                    }.zIndex(2)
                    
                    Spacer()
                    ZStack(alignment: .top) {
                        BarButtons()
                            .padding(.bottom, UIScreen.main.bounds.height / 10)
                            .padding(.horizontal, 22)
                            .background(ButtomBar())
                    }.zIndex(1)
                    .animation(.default)
                }
                .navigationBarTitle("")
                .navigationBarHidden(isBarHidden ? false : true)
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height + 20)
                .background(Color.offWhite)
                .edgesIgnoringSafeArea(.bottom)
                .offset(x: self.showMenu ?UIScreen.main.bounds.width / 2 : 0)
                .disabled(showMenu ? true : false)
            }
            
            if showMenu {
                MenuView(showMenu: $showMenu)
                    .transition(.move(edge: .leading))
                    .zIndex(3)
            }
        }

        //                    .onAppear() {
        ////                        self.mainVM.getDogsFromDB()
        ////                        self.mainVM.ref.childByAutoId().setValue(["name": "Tom", "age": 5, "images": ["pug.jpg", "doggie2.jpg"]])
        //                }
    }
}





