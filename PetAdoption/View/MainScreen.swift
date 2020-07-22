import SwiftUI
import FirebaseStorage

enum barItem {
    case first
    case second
    case third
    case forth
}

struct MainScreen: View {
    
    @State var showPostPetScreen = false
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
                                    self.showMenu.toggle()
                        }) {
                            Image("settings").resizable()
                                .frame(width: 25, height: 25)
                                .padding(.leading, 10).foregroundColor(.gray)
                                .animation(.spring())
                        }
                        
                        
                        Spacer()
                        Text(self.mainVM.localDB.savedDogsCount)
                            .foregroundColor(.black)
                            .animation(.default)
                        NavigationLink (destination: SavedDogsScreen(isBarHidden: $isBarHidden), isActive: $showNewDogScreen) {
                            Image("dogy").resizable()
                                .frame(width: 25, height: 25)
                                .padding(.trailing, 10)
                                .animation(.spring())
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
                    .background(Color.offWhite)
                    .disabled(showMenu ? true : false)
                    .animation(.spring())
                    
                    Spacer()
                    ZStack(alignment: .top) {
                        BarButtons()
                            .padding(.bottom, UIScreen.main.bounds.height / 10)
                            .padding(.horizontal, 22)
                            .background(ButtomBar())
                            .environment(\.layoutDirection, .leftToRight)
                    }.zIndex(1)
                    .background(Color.offWhite)
                    .disabled(showMenu ? true : false)
                    .animation(.spring())
                }
                .navigationBarTitle("")
                .navigationBarHidden(isBarHidden ? false : true)
                .animation(.spring())
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height + 20)
                .background(Color.offWhite)
                .edgesIgnoringSafeArea(.bottom)
                .offset(x: self.showMenu ?UIScreen.main.bounds.width / 1.2 : 0)
                
            }.background(Color.offWhite)
            .animation(.spring())
            
            if showMenu {
                SettingsView(showMenu: $showMenu, showPostPetScreen: $showPostPetScreen)
                    .animation(.spring())
                    .transition(.move(edge: .leading))
                    .zIndex(3)
            }
            
            ZStack {
                LoginScreen(showPostPetScreen: $showPostPetScreen)
            }
            .zIndex(4)
            .frame(maxWidth: UIScreen.main.bounds.width, maxHeight: .infinity, alignment: .topLeading)
            .background(Color("offBlack"))
            .edgesIgnoringSafeArea(.all)
            .offset(x: 0, y: self.showPostPetScreen ? 0 : UIScreen.main.bounds.height)
            .onTapGesture {
                UIApplication.shared.endEditing()
            }
        }.environment(\.layoutDirection, .rightToLeft)
        .gesture(showPostPetScreen ? nil : DragGesture().onEnded {
            if $0.translation.width > -100 {
                withAnimation {
                    self.showMenu = false
                }
            }
        })
        
        //                    .onAppear() {
        ////                        self.mainVM.getDogsFromDB()
        ////                        self.mainVM.ref.childByAutoId().setValue(["name": "Tom", "age": 5, "images": ["pug.jpg", "doggie2.jpg"]])
        //                }
    }
}





