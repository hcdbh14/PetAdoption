import SwiftUI
import FirebaseStorage
import Lottie

enum barItem {
    case first
    case second
    case third
    case forth
}

struct MainScreen: View {
    
    @State private var showAuth = false
    @State private var reload = false
    @State private var showMenu = false
    @State var showPostPetScreen = false
    @State private var staticIndex = 0
    @State private var isBarHidden = true
    @State private var scaleAnimation = false
    @State private var showNewDogScreen = false
    @State private var selected = barItem.first
    @EnvironmentObject private var cardVM: CardVM
    @EnvironmentObject private var settings: Settings
    
    var body: some View {
        ZStack (alignment: .leading) {
            NavigationView {
                
                VStack {
                    HStack {
                        Button(action: {
                            self.showMenu.toggle()
                            self.reloadPets()
                        }) {
                            Image("settings").resizable()
                                .frame(width: 25, height: 25)
                                .padding(.leading, 10).foregroundColor(.gray)
                                .animation(.spring())
                        }
                        
                        
                        Spacer()
                        Text(self.cardVM.localDB.savedDogsCount)
                            .foregroundColor(.black)
                            .animation(.default)
                        NavigationLink (destination: SavedDogsScreen(isBarHidden: $isBarHidden), isActive: $showNewDogScreen) {
                            Image("dogy").resizable()
                                .frame(width: 25, height: 25)
                                .padding(.trailing, 10)
                                .animation(.spring())
                        }
                        .navigationBarBackButtonHidden(false)
                        .navigationBarTitle("")
               

                        
                    }.padding(.top, 50)
                    Spacer()
                    
                    
                    ZStack {
                        if  cardVM.petsList.isEmpty == false && cardVM.noMorePets == false {
                            BackCard(scaleTrigger: $scaleAnimation, mainVM: cardVM)
                            
                            Card(scaleTrigger: $scaleAnimation, showMenu: $showMenu, mainVM: cardVM, reload: $reload)
                        } else if cardVM.noMorePets {
                            Text("אין יותר חיות להצגה :(")
                        } else {
                            LottieView()
                                .frame(width: 300, height: 300)
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
                .navigationBarHidden(true)
                .animation(.spring())
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height + 20)
                .background(Color.offWhite)
                .edgesIgnoringSafeArea(.bottom)
                .offset(x: self.showMenu ?UIScreen.main.bounds.width / 1.2 : 0)
                
            }.background(Color.offWhite)
            .animation(.spring())
            .navigationViewStyle(StackNavigationViewStyle())
            
            if showMenu {
                SettingsView(showMenu: $showMenu, showPostPetScreen: $showPostPetScreen)
                    .animation(.spring())
                    .transition(.move(edge: .leading))
                    .offset(x: self.showMenu ? 0 : UIScreen.main.bounds.width / 1.2)
                    .zIndex(3)
            }
            
            if showAuth {
            ZStack {
                AuthViewManager(showPostPetScreen: $showPostPetScreen)
            }
            .zIndex(4)
            .frame(maxWidth: UIScreen.main.bounds.width, maxHeight: UIScreen.main.bounds.height, alignment: .topLeading)
            .background(Color("offBlack"))
            .edgesIgnoringSafeArea(.all)
            .offset(x: 0, y: self.showPostPetScreen ? 0 : UIScreen.main.bounds.height)
            .onTapGesture {
                UIApplication.shared.endEditing()
            }
            }
        }.environment(\.layoutDirection, .rightToLeft)
        .gesture(showPostPetScreen ? nil : DragGesture().onEnded {
            if $0.translation.width > -100 {
                withAnimation {
                    self.showMenu = false
                    self.reloadPets()
                }
            }
        })
        .onAppear() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                showAuth = true
            }
        }
    }
    
    private func reloadPets() {
        
        if settings.settingsChanged {
            reload = true
            cardVM.noMorePets = true
            cardVM.reload = true
            cardVM.getPetsFromDB()
            settings.settingsChanged = false
        }
    }
}
