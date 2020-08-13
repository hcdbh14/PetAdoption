import SwiftUI

struct Card: View {
    
    @State private var isImageReady = false
    @State private var speed = 0.5
    @State private var x: CGFloat = 0
    @State private var y: CGFloat = 0
    @State private var showInfo = false
    @Binding private var showMenu: Bool
    @State private var inAnimation = false
    @State private var degree: Double = 0
    @State private var switchingImage = false
    @Binding private var scaleAnimation: Bool
    @State private var image: UIImage = UIImage()
    @ObservedObject private var mainVM: MainVM
    
    init(scaleTrigger: Binding<Bool>, showMenu: Binding<Bool>, mainVM: MainVM) {
        self.mainVM = mainVM
        self._scaleAnimation = scaleTrigger
        self._showMenu = showMenu
        UIScrollView.appearance().bounces = false
    }
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            if showInfo == false {
                VStack {
                    
                    Image(uiImage: image).resizable()
                        .scaledToFit()
                        .frame(width: UIScreen.main.bounds.width - 10, height: UIScreen.main.bounds.height / 1.4)
                        .background(Color.black)
                        .cornerRadius(5)
                        .fixedSize()
                        .allowsHitTesting(x == 0 ? true : false)
                        .animation(.none)
                        .onReceive(mainVM.reloadFrontImage, perform:  { answer in
                            self.isImageReady = answer
                            self.populateImage()
                        })
                        .onReceive(mainVM.userDecided, perform: { decision in
                            self.inAnimation = true
                            self.speed = 0.5
                            switch decision {
                            case .picked:
                                self.decideHeightDirection(y: -100)
                                self.x = 500
                            case .rejected:
                                self.decideHeightDirection(y: -100)
                                self.x = -500
                            case .notDecided:
                                self.decideHeightDirection(y: 0)
                            }
                            self.degree = -15
                            self.switchingImage = true
                            withAnimation(.easeIn(duration : 0.6)) {
                                self.scaleAnimation = true
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                                self.mainVM.imageIndex = 0
                            }
                            if self.mainVM.frontImages.hasValueAt(index: self.mainVM.imageIndex) {
                                self.image = UIImage(data: self.mainVM.frontImages[self.mainVM.imageIndex]) ?? UIImage()
                            }
                            self.mainVM.pushNewImage()
                            self.moveToNextCard()
                        })
                        .onAppear() {
                            self.populateImage()
                    }
                }
                
                HStack {
                    Spacer()
                    ForEach (0...self.mainVM.dogsList[self.mainVM.count - 1].images.count - 1,id: \.self) { i in
                        Rectangle()
                            .fill(Color.clear)
                            .background((self.mainVM.imageIndex == i ? Color.orange : Color.gray).cornerRadius(20))
                            .frame(width: (UIScreen.main.bounds.width / CGFloat(self.mainVM.dogsList[self.mainVM.count - 1].images.count)) - 30, height: 10)
                            .opacity(self.mainVM.dogsList[self.mainVM.count - 1].images.count == 1 ? 0 : 0.7)
                    }
                    Spacer()
                }.padding(.bottom, UIScreen.main.bounds.height / 1.47)
                
                
                
                VStack(alignment: .trailing, spacing: 3) {
                    
                    HStack (alignment: .center) {
                        Image(systemName: "info.circle.fill")
                            .font(.system(size: 26, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(.leading, 20)
                        
                        Spacer()
                        
                        Text((mainVM.dogsList[mainVM.count - 1].gender == "1" ? "בת" : "בן") + " "
                            + returnAge())
                            .font(.system(size: 24))
                            .foregroundColor(.white)
                            .fontWeight(.heavy)
                        
                        
                        Text(mainVM.dogsList[mainVM.count - 1].name + "," )
                            .font(.system(size: 28))
                            .foregroundColor(.white)
                            .fontWeight(.heavy)
                            .padding(.trailing, 10)
                    }
                    
                    Text(mainVM.dogsList[mainVM.count - 1].goodWords)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.trailing, 10)
                    
                    
                    Text(mainVM.dogsList[mainVM.count - 1].city)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.trailing, 10)
                    
                }
                .frame(height: 100)
                .rotationEffect(.init(degrees: self.degree))
                .background(LinearGradient(gradient: Gradient(colors: [.black, .clear]), startPoint: .bottom, endPoint: .top))
                .cornerRadius(5)
                .onTapGesture {
                    self.timedInfoAnimation()
                }
            }
            ZStack {
                if self.mainVM.frontImages.hasValueAt(index: self.mainVM.imageIndex) == false {
                    ActivityIndicator(isAnimating: true)
                        .configure { $0.color = .orange }
                }
                
            }.frame(width: UIScreen.main.bounds.width - 10, height: UIScreen.main.bounds.height / 1.4, alignment: .center)
            
            if showInfo {
                ScrollView {
                    Image(uiImage: image).resizable()
                        .background(Color.gray)
                        .aspectRatio(contentMode: .fill)
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 1.4)
                        .cornerRadius(1)
                        .animation(.none)
                        .padding(.top, -42)
                        .transition(.move(edge: .bottom))
                    //                        .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .global)
                    //                            .onEnded({ (value) in
                    //                                self.moveToImage(direction: value.location.x)
                    //                            }))
                    
                    VStack(alignment: .trailing, spacing: 5) {
                        
                        HStack (alignment: .bottom) {
                            
                            Button(action: {
                                self.timedInfoAnimation()
                                
                            }) {
                                Image(systemName: "arrowshape.turn.up.left.fill")
                                    .frame(width: 25, height: 25, alignment: .center)
                                    .font(.system(size: 24, weight: .semibold))
                                    .foregroundColor(.orange)
                            }
                            .buttonStyle(SimpleCircleButtonStyle(isBig: true))
                            .padding(.leading, 5)
                            
                            Spacer()
                            
                            VStack {
                                Text(mainVM.dogsList[mainVM.count - 1].name)
                                    .font(.system(size: 28))
                                    .foregroundColor(.black)
                                    .fontWeight(.heavy)
                                    .padding(.bottom, 10)
                                    .padding(.trailing, -10)
                                
                                Text(mainVM.dogsList[mainVM.count - 1].goodWords)
                                    .font(.system(size: 18))
                                    .foregroundColor(.gray)
                                    .fontWeight(.medium)
                                    .padding(.bottom, 20)
                                    .padding(.trailing, 20)
                            }
                        }
                        
                        VStack(alignment: .trailing, spacing: 10) {
                            HStack {
                                Text(mainVM.dogsList[mainVM.count - 1].race)
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.black)
                                
                                Image("paw").resizable()
                                    .frame(width: 20 , height : 20)
                                    .padding(.trailing, 10)
                            }
                            
                            HStack {
                                Text((mainVM.dogsList[mainVM.count - 1].gender == "1" ? "בת" : "בן") + " " + self.returnAge() + " ")
                                    
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.black)
                                Image("cake").resizable()
                                    .frame(width: 20 , height : 20)
                                    .padding(.trailing, 10)
                            }
                            
                            HStack {
                                
                                Text( "אזור: " + mainVM.dogsList[mainVM.count - 1].city)
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.black)
                                
                                Image(systemName: "mappin.and.ellipse").resizable()
                                    .frame(width: 20 , height : 20)
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 10)
                                
                            }
                            
                            HStack {
                                Text("טלפון: " + mainVM.dogsList[mainVM.count - 1].number)
                                    
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.black)
                                Image(systemName: "phone.circle").resizable()
                                    .frame(width: 20 , height : 20)
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 10)
                            }
                            
                        }
                        
                        if mainVM.dogsList[mainVM.count - 1].desc != "" {
                            HStack {
                                Text("קצת עלי:")
                                    .font(.system(size: 20, weight: .semibold))
                                    .underline()
                                    .foregroundColor(.black)
                                    .padding(.trailing, 20)
                                    .padding(.top, 20)
                                
                            }
                            Text(mainVM.dogsList[mainVM.count - 1].desc).frame(width: UIScreen.main.bounds.width - 50, alignment: .leading)
                                .foregroundColor(.black)
                                .environment(\.layoutDirection, .rightToLeft)
                                .padding(.top, 20)
                                .padding(.trailing, 20)
                        }
                        
                        if mainVM.dogsList[mainVM.count - 1].suitables != "" {
                            HStack {
                                Text("מתאים ל:")
                                    .font(.system(size: 20, weight: .semibold))
                                    .underline()
                                    .foregroundColor(.black)
                                    .padding(.trailing, 20)
                                    .padding(.top, 20)
                                
                            }
                            
                            HStack() {
                                Text(mainVM.dogsList[mainVM.count - 1].suitables)
                                    .foregroundColor(.black)
                                    .padding(.trailing, 20)
                                    .frame(width: UIScreen.main.bounds.width - 100, height: 50, alignment: .trailing)
                            }
                        }
                    }
                }.frame(width: UIScreen.main.bounds.width , height: UIScreen.main.bounds.height)
                    .animation(.none)
                    .background(Color.offWhite)
                    .padding(.top, 60)
            }
        }
        .offset(x: self.x, y: self.y)
        .rotationEffect(.init(degrees: self.degree))
        .frame(width: UIScreen.main.bounds.width - 10, height: UIScreen.main.bounds.height / 1.4)
        .animation(decideAnimation())
        .transition(.move(edge: .bottom))
        .allowsHitTesting(isImageReady ? true : false)
        .gesture(showInfo ? nil : DragGesture(minimumDistance: 0, coordinateSpace: .global)
        .onChanged({ (value) in
            self.speed = 5
            if value.startLocation != value.location {
                if self.switchingImage == false {
                    self.inAnimation = true
                }
                if value.translation.width > 50 && value.translation.width > 10 {
                    self.x = value.translation.width
                    self.y = value.translation.height
                    self.degree = -6
                } else if value.translation.width < -50 && value.translation.width < -10 {
                    self.x = value.translation.width
                    self.y = value.translation.height
                    self.degree = 6
                } else {
                    self.x = value.translation.width
                    self.y = value.translation.height
                    self.degree = 0
                }
            }
        })
            .onEnded({ (value) in
                self.speed = 0.5
                self.dragFinished(x: value.translation.width, y: value.translation.height, direction: value.location.x, start: value.startLocation, end: value.location)
            }))
            .environment(\.layoutDirection, .leftToRight)
    }
    
    
    private func moveToImage(direction: CGFloat) {
        if direction > 180 {
            
            if self.mainVM.imageIndex == self.self.mainVM.dogsList[self.mainVM.count - 1].images.count - 1 || self.switchingImage {
                return
            } else {
                if self.mainVM.frontImages.hasValueAt(index: self.mainVM.imageIndex + 1) {
                    self.inAnimation = false
                    self.mainVM.imageIndex += 1
                    self.image = UIImage(data: self.mainVM.frontImages[self.mainVM.imageIndex]) ?? UIImage()
                } else {
                    self.mainVM.imageIndex += 1
                    self.image = UIImage()
                }
            }
        } else {
            if self.mainVM.imageIndex == 0 || self.switchingImage  {
                return
            } else {
                if self.mainVM.frontImages.hasValueAt(index: self.mainVM.imageIndex - 1) {
                    self.inAnimation = false
                    self.mainVM.imageIndex -= 1
                    self.image = UIImage(data: self.mainVM.frontImages[self.mainVM.imageIndex]) ?? UIImage()
                } else {
                    self.mainVM.imageIndex -= 1
                    self.image = UIImage()
                }
            }
        }
    }
    
    
    private func timedInfoAnimation() {
        self.inAnimation = true
        self.showInfo.toggle()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.inAnimation = false
        }
    }
    
    
    private func dragFinished(x: CGFloat, y: CGFloat, direction: CGFloat, start: CGPoint, end: CGPoint) {
        
        if x > 0 {
            if x > 50 {
                self.x = 500
                decideHeightDirection(y: y)
                self.degree = -15
                self.switchingImage = true
                withAnimation(.easeIn(duration : 0.6)) {
                    self.scaleAnimation = true
                }
                DispatchQueue.global().async {
                    self.mainVM.localDB.saveDogURL(self.mainVM.dogsList[self.mainVM.count - 1].images)
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                    self.mainVM.imageIndex = 0
                }
                self.mainVM.pushNewImage()
                moveToNextCard()
                
            } else {
                self.x = 0
                self.y = 0
                self.degree = 0
                self.inAnimation = false
            }
        } else {
            if x < -50 {
                self.x = -500
                decideHeightDirection(y: y)
                self.degree = 15
                self.switchingImage = true
                withAnimation(.easeIn(duration : 0.6)) {
                    self.scaleAnimation = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                    self.mainVM.imageIndex = 0
                }
                self.mainVM.pushNewImage()
                moveToNextCard()
            } else {
                self.x = 0
                self.y = 0
                self.degree = 0
                self.inAnimation = false
            }
        }
        if start == end { self.moveToImage(direction: direction) }
    }
    
    private func decideHeightDirection(y: CGFloat) {
        if y < 0 {
            self.y = y - 100
        } else {
            self.y = y + 100
        }
    }
    
    private func moveToNextCard() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            self.switchingImage = false
            self.scaleAnimation = false
            self.inAnimation = false
            self.x = 0
            self.y = 0
            self.degree = 0
            if self.mainVM.frontImages.hasValueAt(index: self.mainVM.imageIndex) {
                self.image = UIImage(data: self.mainVM.frontImages[self.mainVM.imageIndex]) ?? UIImage()
            }
        }
    }
    
    private func returnAge() -> String {
        let ageNum = Double(mainVM.dogsList[mainVM.count - 1].age) ?? 0
        
        if ageNum < 1 {
            if let range = mainVM.dogsList[mainVM.count - 1].age.range(of: ".") {
                return String(mainVM.dogsList[mainVM.count - 1].age[range.upperBound...]) + " חודשים"
            }
            return ""
        } else {
            return mainVM.dogsList[mainVM.count - 1].age + " שנים"
        }
    }
    
    private func populateImage()  {
        
        if self.isImageReady == false {
            image = UIImage()
            return
        }
        
        if self.mainVM.frontImages.hasValueAt(index: self.mainVM.imageIndex) {
            image = UIImage(data: self.mainVM.frontImages[mainVM.imageIndex]) ?? UIImage()
            self.isImageReady = true
        } else {
            image = UIImage()
        }
    }
    
    private func decideAnimation() -> Animation {
        
        DispatchQueue.global().sync {
            if inAnimation {
                return Animation.interactiveSpring().speed(speed)
            } else if showMenu {
                return .spring()
            } else if scaleAnimation {
                return Animation.linear(duration: 0)
            }
            else {
                return .spring()
            }
        }
    }
}

