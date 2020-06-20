import SwiftUI

struct Card: View {
    private let age: Int
    private var imageCount: Int
    private let dogName: String
    @State private var speed = 1.0
    @State private var x: CGFloat = 0
    @State private var y: CGFloat = 0
    @Binding private var displyed: Int
    @State private var showInfo = false
    @State private var inAnimation = false
    @State private var data: [Data] = []
    @State private var degree: Double = 0
    @State private var switchingImage = false
    @Binding private var scaleAnimation: Bool
    @State private var image: UIImage = UIImage()
    @ObservedObject private var imageLoader: ImageLoader
    @EnvironmentObject private var mainVM: MainVM
    
    init(imageURL: [String], displayed: Binding<Int>, imageCount: Int, dogName: String, age: Int, scaleTrigger: Binding<Bool>) {
        imageLoader = ImageLoader(urlString: imageURL)
        self.imageCount = imageCount
        self._displyed = displayed
        self._scaleAnimation = scaleTrigger
        self.dogName = dogName
        self.age = age
        UIScrollView.appearance().bounces = false
    }
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            if showInfo == false {
                VStack {
                    Image(uiImage: image)
                        .resizable()
                        .background(Color.gray)
                        .aspectRatio(contentMode: .fill)
                        .frame(width: UIScreen.main.bounds.width - 10, height: UIScreen.main.bounds.height / 1.4)
                        .cornerRadius(20)
                        .animation(.none)
                        .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .global)
                            .onChanged({ (value) in
                                
                                if value.startLocation != value.location {
                                    self.speed = 5.0
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
                                self.dragAnimation(x: value.translation.width, y: value.translation.height, direction: value.location.x, start: value.startLocation, end: value.location)
                            }))
                        .onReceive(imageLoader.didChange) { data in
                            self.data = data
                            if self.data.hasValueAt(index: self.displyed) {
                                self.image = UIImage(data: data[self.displyed]) ?? UIImage()
                            }
                    }
                }
                HStack {
                    Spacer()
                    ForEach (0...imageCount - 1,id: \.self) { i in
                        Rectangle()
                            .fill(Color.clear)
                            .background((self.displyed == i ? Color.orange : Color.gray).cornerRadius(20))
                            .frame(width: (UIScreen.main.bounds.width / CGFloat(self.imageCount)) - 30, height: 10)
                            .opacity(self.imageCount == 1 ? 0 : 0.7)
                        
                    }
                    Spacer()
                }.padding(.bottom, UIScreen.main.bounds.height / 1.45)
                VStack(alignment: .trailing, spacing: 12) {
                    
                    HStack (alignment: .center) {
                        Image(systemName: "info.circle.fill")
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(.leading, 20)
                        
                        Spacer()
                        
                        Text("\(age)")
                            .font(.system(size: 24))
                            .foregroundColor(.white)
                            .fontWeight(.regular)
                        
                        Text(dogName)
                            .font(.system(size: 35))
                            .foregroundColor(.white)
                            .fontWeight(.heavy)
                            .padding(.trailing, 10)
                    }
                }
                .frame(height: 100)
                .contentShape(Rectangle())
                .rotationEffect(.init(degrees: self.degree))
                .onTapGesture {
                    self.timedInfoAnimation()
                }
            }
            
            if showInfo {
                ScrollView {
                    Image(uiImage: image)
                        .resizable()
                        .background(Color.gray)
                        .aspectRatio(contentMode: .fill)
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 1.4)
                        .animation(.none)
                        .transition(.move(edge: .bottom))
                        .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .global)
                            .onEnded({ (value) in
                                self.moveToImage(direction: value.location.x)
                            }))
                        .onReceive(imageLoader.didChange) { data in
                            self.data = data
                            if self.data.hasValueAt(index: self.displyed) {
                                self.image = UIImage(data: data[self.displyed]) ?? UIImage()
                            }}
                    
                    HStack (alignment: .bottom) {
                        Image(systemName: "info.circle.fill")
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(.leading, 20)
                        
                        Spacer()
                        
                        Text("\(age)")
                            .font(.system(size: 24))
                            .foregroundColor(.black)
                            .fontWeight(.regular)
                        
                        Text(dogName)
                            .font(.system(size: 30))
                            .foregroundColor(.black)
                            .fontWeight(.heavy)
                    }.onTapGesture {
                        self.timedInfoAnimation()
                    }
                    
                    Text("test").onAppear() { print("test") }
                    Text("test").frame(width: 100, height: 100)
                    Text("test").frame(width: 100, height: 100)
                    Text("test").frame(width: 100, height: 100)
                    Text("test").frame(width: 100, height: 100)
                    Text("test").frame(width: 100, height: 100)
                    Text("test").frame(width: 100, height: 100)
                    Text("test").frame(width: 100, height: 100)
                    
                    
                }.frame(width: UIScreen.main.bounds.width , height: UIScreen.main.bounds.height )
                    .background(Color.offWhite)
                    .padding(.top, 40)
            }
        }
        .offset(x: self.x, y: self.y)
        .rotationEffect(.init(degrees: self.degree))
        .frame(width: UIScreen.main.bounds.width - 10, height: UIScreen.main.bounds.height / 1.4)
        .animation(inAnimation ? Animation.linear.speed(speed) : .none)
        .transition(.move(edge: .bottom))
    }
    
    
    private func moveToImage(direction: CGFloat) {
        if direction > 180 {
            
            if self.displyed == self.imageCount - 1 || self.switchingImage {
                return
            } else {
                if self.data.hasValueAt(index: self.displyed + 1) {
                    self.inAnimation = false
                    self.displyed += 1
                    self.image = UIImage(data: self.data[self.displyed]) ?? UIImage()
                } else {
                    self.displyed += 1
                    self.image = UIImage()
                }
            }
        } else {
            if self.displyed == 0 || self.switchingImage  {
                return
            } else {
                if self.data.hasValueAt(index: self.displyed - 1) {
                    self.inAnimation = false
                    self.displyed -= 1
                    self.image = UIImage(data: self.data[self.displyed]) ?? UIImage()
                } else {
                    self.displyed -= 1
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
    
    
    private func dragAnimation(x: CGFloat, y: CGFloat, direction: CGFloat, start: CGPoint, end: CGPoint) {
        speed = 1.0
        
        if x > 0 {
            if x > 50 {
                self.x = 500
                decideHeightDirection(y: y)
                self.degree = -15
                self.switchingImage = true
                withAnimation(.easeIn(duration : 0.6)) {
                    self.scaleAnimation = true
                }
                self.mainVM.pushNewImage()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                    withAnimation (.none) {
                        self.displyed = 0
                        self.switchingImage = false
                        self.inAnimation = false
                        self.image = UIImage(data: self.data[self.displyed]) ?? UIImage()
                        self.x = 0
                        self.y = 0
                        self.degree = 0
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                        self.scaleAnimation = false
                    }
                }
            } else {
                self.x = 0
                self.y = 0
                self.degree = 0
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
                self.mainVM.pushNewImage()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                    withAnimation (.none) {
                        self.displyed = 0
                        self.switchingImage = false
                        self.inAnimation = false
                        self.image = UIImage(data: self.data[self.displyed]) ?? UIImage()
                        self.x = 0
                        self.y = 0
                        self.degree = 0
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                        self.scaleAnimation = false
                    }
                }
            } else {
                self.x = 0
                self.y = 0
                self.degree = 0
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
}
