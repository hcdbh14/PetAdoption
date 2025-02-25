import SwiftUI

struct Card: View {
    
    @Binding var reload: Bool
    @State private var save = false
    @State private var pass = false
    @State private var isImageReady = false
    @State private var speed = 0.5
    @State private var x: CGFloat = 0
    @State private var y: CGFloat = 0
    @State private var showInfo = false
    @Binding private var showMenu: Bool
    @State private var inAnimation = false
    @State private var noAnimation = false
    @State private var degree: Double = 0
    @State private var switchingImage = false
    @Binding private var scaleAnimation: Bool
    @State private var image: UIImage = UIImage()
    @ObservedObject private var cardVM: CardVM
    
    init(scaleTrigger: Binding<Bool>, showMenu: Binding<Bool>, mainVM: CardVM, reload: Binding<Bool>) {
        self._reload = reload
        self.cardVM = mainVM
        self._scaleAnimation = scaleTrigger
        self._showMenu = showMenu
        UIScrollView.appearance().bounces = false
    }
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            if showInfo == false {
                VStack {
                    
                    Image(uiImage: reload ? UIImage() :  image).resizable()
                        .scaledToFit()
                        .frame(width: UIScreen.main.bounds.width - 10, height: UIScreen.main.bounds.height / 1.4)
                        .background(Color.black)
                        .cornerRadius(5)
                        .fixedSize()
                        .allowsHitTesting(x == 0 ? true : false)
                        .animation(cardVM.reload || noAnimation ? .none : decideAnimation())
                        .onReceive(cardVM.reloadFrontImage, perform:  { answer in
                            self.isImageReady = answer
                            if answer == true && self.reload && self.cardVM.reload == false {
                                self.reload = false
                            }
                            self.populateImage()
                        })
                        .onReceive(cardVM.userDecided, perform: { decision in
                            self.inAnimation = true
                            self.speed = 0.25
                            switch decision {
                            case .picked:
                                self.save = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    self.decideHeightDirection(y: -100)
                                    self.x = 500
                                    self.save = false
                                    DispatchQueue.global().async {
                                        self.cardVM.localDB.saveDogURL(self.cardVM.petsList[self.cardVM.count - 1].images)
                                    }
                                }
                            case .rejected:
                                self.pass = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    self.decideHeightDirection(y: -100)
                                    self.x = -500
                                    self.pass = false
                                }
                            case .notDecided:
                                self.decideHeightDirection(y: 0)
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                self.degree = -15
                                self.switchingImage = true
                                withAnimation(.easeIn(duration : 0.6)) {
                                    self.scaleAnimation = true
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                                    self.cardVM.imageIndex = 0
                                }
                                if self.cardVM.frontImages.hasValueAt(index: self.cardVM.imageIndex) {
                                    self.image = UIImage(data: self.cardVM.frontImages[self.cardVM.imageIndex]) ?? UIImage()
                                }
                                self.cardVM.pushNewImage()
                                self.moveToNextCard()
                            }
                        })
                        .onAppear() {
                            self.populateImage()
                        }
                }
                
                
                HStack {
                    Spacer()
                    ForEach (0...self.cardVM.petsList[self.cardVM.count - 1].images.count - 1,id: \.self) { i in
                        Rectangle()
                            .fill(Color.clear)
                            .background((self.cardVM.imageIndex == i ? Color.orange : Color.gray).cornerRadius(20))
                            .frame(width: (UIScreen.main.bounds.width / CGFloat(self.cardVM.petsList[self.cardVM.count - 1].images.count)) - 30, height: 10)
                            .opacity(self.cardVM.petsList[self.cardVM.count - 1].images.count == 1 ? 0 : 0.7)
                    }
                    Spacer()
                }.padding(.bottom, UIScreen.main.bounds.height / 1.47)
                
                
                HStack {
                    Text("  SAVE  ")
                        .frame(width:100)
                        .border(Color("green"), width: 4)
                        .font(.system(size: 32, weight: .semibold))
                        .foregroundColor(Color("green"))
                        .rotationEffect(.degrees(-45))
                        .opacity(Double(self.save ? 1 : self.x/30 - 1))
                        .padding(15)
                    Spacer()
                    Text("  PASS  ")
                        
                        .frame(width:100)
                        .border(Color("red"), width: 4)
                        .foregroundColor(Color("red"))
                        .rotationEffect(.degrees(45))
                        .font(.system(size: 32, weight: .semibold))
                        .opacity(Double(self.pass ? 1 : self.x/30 * -1 - 1))
                        
                        .padding(15)
                }.padding(.bottom, UIScreen.main.bounds.height / 1.8)
                
                
                VStack(alignment: .trailing, spacing: 3) {
                    
                    HStack (alignment: .center) {
                        Image(systemName: "info.circle.fill")
                            .font(.system(size: 26, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(.leading, 20)
                        
                        Spacer()
                        
                        Text((cardVM.petsList[cardVM.count - 1].gender == "1" ? "בת" : "בן") + " "
                                + returnAge())
                            .font(.system(size: 24))
                            .foregroundColor(.white)
                            .fontWeight(.heavy)
                        
                        
                        Text(cardVM.petsList[cardVM.count - 1].name + "," )
                            .font(.system(size: 28))
                            .foregroundColor(.white)
                            .fontWeight(.heavy)
                            .padding(.trailing, 10)
                    }
                    
                    Text(cardVM.petsList[cardVM.count - 1].goodWords)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.trailing, 10)
                    
                    
                    Text(decideRegion(code: cardVM.petsList[cardVM.count - 1].region))
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
                if self.cardVM.frontImages.hasValueAt(index: self.cardVM.imageIndex) == false  || isImageReady == false || reload {
                    ActivityIndicator(isAnimating: true)
                        .configure { $0.color = .orange }
                }
                
            }.frame(width: UIScreen.main.bounds.width - 10, height: UIScreen.main.bounds.height / 1.4, alignment: .center)
            
            if showInfo {
                ScrollView {
                    
                    ZStack {
                        Image(uiImage: reload ? UIImage() :  image).resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 1.4)
                            .background(Color.black)
                            .cornerRadius(1)
                            .animation(.none)
                            .padding(.top, -42)
                            .transition(.move(edge: .bottom))
                        
                        HStack(spacing: -10) {
                            
                            Button(action: {
                                self.moveToImage(direction: -100)
                            }) {
                                Rectangle()
                                    .contentShape(Rectangle())
                                    .foregroundColor(.clear)
                            }
                            .padding(.trailing , 5)
                            Spacer()
                            
                            if self.cardVM.frontImages.hasValueAt(index: self.cardVM.imageIndex) == false  || isImageReady == false || reload {
                                ActivityIndicator(isAnimating: true)
                                    .configure { $0.color = .orange }
                            }
                            
                            Button(action: {
                                self.moveToImage(direction: 400)
                            }) {
                                Rectangle()
                                    .contentShape(Rectangle())
                                    .foregroundColor(.clear)
                            }
                            .padding(.leading , 5)
                        }
                        
                        HStack {
                            Spacer()
                            ForEach (0...self.cardVM.petsList[self.cardVM.count - 1].images.count - 1,id: \.self) { i in
                                Rectangle()
                                    .fill(Color.clear)
                                    .background((self.cardVM.imageIndex == i ? Color.orange : Color.gray).cornerRadius(20))
                                    .frame(width: (UIScreen.main.bounds.width / CGFloat(self.cardVM.petsList[self.cardVM.count - 1].images.count)) - 30, height: 10)
                                    .opacity(self.cardVM.petsList[self.cardVM.count - 1].images.count == 1 ? 0 : 0.7)
                            }
                            Spacer()
                        }.padding(.bottom, UIScreen.main.bounds.height / 1.47)
                    }.frame(width: UIScreen.main.bounds.width - 10, height: UIScreen.main.bounds.height / 1.4)
                    .onReceive(cardVM.reloadFrontImage, perform:  { answer in
                        self.isImageReady = answer
                        if answer == true && self.reload && self.cardVM.reload == false {
                            self.reload = false
                        }
                        self.populateImage()
                    })
                    
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
                                Text(cardVM.petsList[cardVM.count - 1].name)
                                    .font(.system(size: 28))
                                    .foregroundColor(.black)
                                    .fontWeight(.heavy)
                                    .padding(.bottom, 10)
                                    .padding(.trailing, -10)
                                
                                Text(cardVM.petsList[cardVM.count - 1].goodWords)
                                    .font(.system(size: 18))
                                    .foregroundColor(.gray)
                                    .fontWeight(.medium)
                                    .padding(.bottom, 20)
                                    .padding(.trailing, 20)
                            }
                        }
                        
                        VStack(alignment: .trailing, spacing: 10) {
                            HStack {
                                Text(cardVM.petsList[cardVM.count - 1].race)
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.black)
                                
                                Image("paw").resizable()
                                    .frame(width: 20 , height : 20)
                                    .padding(.trailing, 10)
                            }
                            
                            HStack {
                                Text((cardVM.petsList[cardVM.count - 1].gender == "1" ? "בת" : "בן") + " " + self.returnAge() + " ")
                                    
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.black)
                                Image("cake").resizable()
                                    .frame(width: 20 , height : 20)
                                    .padding(.trailing, 10)
                            }
                            
                            HStack {
                                
                                Text( "אזור: " + decideRegion(code: cardVM.petsList[cardVM.count - 1].region))
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.black)
                                
                                Image(systemName: "mappin.and.ellipse").resizable()
                                    .frame(width: 20 , height : 20)
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 10)
                                
                            }
                            
                            HStack {
                                Text("טלפון: " + cardVM.petsList[cardVM.count - 1].number)
                                    
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.black)
                                Image(systemName: "phone.circle").resizable()
                                    .frame(width: 20 , height : 20)
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 10)
                            }
                            
                        }
                        
                        if cardVM.petsList[cardVM.count - 1].desc != "" {
                            HStack {
                                Text("קצת עלי:")
                                    .font(.system(size: 20, weight: .semibold))
                                    .underline()
                                    .foregroundColor(.black)
                                    .padding(.trailing, 20)
                                    .padding(.top, 20)
                                
                            }
                            Text(cardVM.petsList[cardVM.count - 1].desc).frame(width: UIScreen.main.bounds.width - 50, alignment: .leading)
                                .fixedSize(horizontal: false, vertical: true)
                                .foregroundColor(.black)
                                .environment(\.layoutDirection, .rightToLeft)
                                .padding(.top, 20)
                                .padding(.trailing, 20)
                        }
                        
                        if cardVM.petsList[cardVM.count - 1].suitables != "" {
                            HStack {
                                Text("מתאים ל:")
                                    .font(.system(size: 20, weight: .semibold))
                                    .underline()
                                    .foregroundColor(.black)
                                    .padding(.trailing, 20)
                                    .padding(.top, 20)
                                
                            }
                            
                            HStack() {
                                Text(cardVM.petsList[cardVM.count - 1].suitables)
                                    .foregroundColor(.black)
                                    .padding(.trailing, 20)
                                    .frame(width: UIScreen.main.bounds.width - 100, height: 50, alignment: .trailing)
                            }
                        }
                        
                        HStack {
                            
                            
                            
                            ZStack {
                                if cardVM.petsList[cardVM.count - 1].vaccinated == "1"  {
                                    Image(systemName: "checkmark" )
                                        .resizable()
                                        .foregroundColor(Color.black)
                                        .frame(width: 11, height: 11)
                                }
                                
                                Image(systemName: "square")
                                    .resizable()
                                    .foregroundColor(Color.orange)
                                    .frame(width: 21, height: 21)
                            }.padding(.top, 20)
                            .padding(.trailing, 10)
                            
                            
                            Text("אני " + (cardVM.petsList[cardVM.count - 1].gender == "1" ? "מחוסנת" : "מחוסן"))
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.black)
                                .padding(.trailing, 20)
                                .padding(.top, 20)
                        }
                        
                        HStack {
                            
                            
                            
                            ZStack {
                                if cardVM.petsList[cardVM.count - 1].poopTrained == "1"  {
                                    Image(systemName: "checkmark" )
                                        .resizable()
                                        .foregroundColor(Color.black)
                                        .frame(width: 11, height: 11)
                                }
                                
                                Image(systemName: "square")
                                    .resizable()
                                    .foregroundColor(Color.orange)
                                    .frame(width: 21, height: 21)
                            }.padding(.top, 20)
                            .padding(.trailing, 10)
                            
                            
                            Text("אני " + (cardVM.petsList[cardVM.count - 1].gender == "1" ? "מחונכת" : "מחונך") + " לצרכים")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.black)
                                .padding(.trailing, 20)
                                .padding(.top, 20)
                        } .padding(.bottom, 20)
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
        .animation(cardVM.reload ? .none : decideAnimation())
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
            
            if self.cardVM.imageIndex == self.self.cardVM.petsList[self.cardVM.count - 1].images.count - 1 || self.switchingImage {
                return
            } else {
                if self.cardVM.frontImages.hasValueAt(index: self.cardVM.imageIndex + 1) {
                    self.inAnimation = false
                    self.cardVM.imageIndex += 1
                    self.image = UIImage(data: self.cardVM.frontImages[self.cardVM.imageIndex]) ?? UIImage()
                } else {
                    self.cardVM.imageIndex += 1
                    self.image = UIImage()
                }
            }
        } else {
            if self.cardVM.imageIndex == 0 || self.switchingImage  {
                return
            } else {
                if self.cardVM.frontImages.hasValueAt(index: self.cardVM.imageIndex - 1) {
                    self.inAnimation = false
                    self.cardVM.imageIndex -= 1
                    self.image = UIImage(data: self.cardVM.frontImages[self.cardVM.imageIndex]) ?? UIImage()
                } else {
                    self.cardVM.imageIndex -= 1
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
        
        self.noAnimation = false
        
        if x > 0 {
            if x > 130 {
                self.x = 500
                decideHeightDirection(y: y)
                self.degree = -15
                self.switchingImage = true
                withAnimation(.easeIn(duration : 0.6)) {
                    self.scaleAnimation = true
                }
                DispatchQueue.global().async {
                    self.cardVM.localDB.saveDogURL(self.cardVM.petsList[self.cardVM.count - 1].images)
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                    self.cardVM.imageIndex = 0
                }
                self.cardVM.pushNewImage()
                moveToNextCard()
                
            } else {
                self.x = 0
                self.y = 0
                self.degree = 0
                self.inAnimation = false
            }
        } else {
            if x < -150 {
                self.x = -500
                decideHeightDirection(y: y)
                self.degree = 15
                self.switchingImage = true
                withAnimation(.easeIn(duration : 0.6)) {
                    self.scaleAnimation = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                    self.cardVM.imageIndex = 0
                }
                self.cardVM.pushNewImage()
                moveToNextCard()
            } else {
                self.x = 0
                self.y = 0
                self.degree = 0
                self.inAnimation = false
            }
        }
        
        if start == end {
            self.noAnimation = true
            self.moveToImage(direction: direction)
        }
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
            if self.cardVM.frontImages.hasValueAt(index: self.cardVM.imageIndex) {
                self.image = UIImage(data: self.cardVM.frontImages[self.cardVM.imageIndex]) ?? UIImage()
            }
        }
    }
    
    private func returnAge() -> String {
        let ageFloat = cardVM.petsList[cardVM.count - 1].age
        let ageString = String(cardVM.petsList[cardVM.count - 1].age)
        if ageFloat < 1 {
            
            if let range = ageString.range(of: ".") {
                return ageString[range.upperBound...] + " חודשים"
            }
            return ""
        } else {
            let ageInt = Int(ageFloat)
            return String(ageInt) + " שנים"
        }
    }
    
    private func populateImage()  {
        
        if self.cardVM.frontImages.hasValueAt(index: self.cardVM.imageIndex) {
            image = UIImage(data: self.cardVM.frontImages[cardVM.imageIndex]) ?? UIImage()
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
    
    private func decideRegion(code: String) -> String {
        switch code {
        case "0":
            return "דרום"
        case "1":
            return "מרכז"
        default:
            return "צפון"
        }
    }
}

