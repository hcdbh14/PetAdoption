import SwiftUI

struct Card: View {
    let age: Int
    var imageCount: Int
    let dogName: String
    @State var x: CGFloat = 0
    @Binding var displyed: Int
    @State var showInfo = false
    @State var inAnimation = false
    @State var data: [Data] = []
    @State var degree: Double = 0
    @State var switchingImage = false
    @Binding var scaleAnimation: Bool
    @EnvironmentObject var mainVM: MainVM
    @State var image: UIImage = UIImage()
    @ObservedObject var imageLoader: DataLoader
    
    init(imageURL: [String], displayed: Binding<Int>, imageCount: Int, dogName: String, age: Int, scaleTrigger: Binding<Bool>) {
        imageLoader = DataLoader(urlString: imageURL)
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
                        .animation(inAnimation ? .default : .none)
                        .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .global)
                            .onChanged({ (value) in
                                
                                if value.startLocation != value.location {
                                    if self.switchingImage == false {
                                        self.inAnimation = true
                                    }
                                    if value.translation.width > 0 {
                                        self.x = value.translation.width
                                        self.degree = 8
                                    } else {
                                        self.x = value.translation.width
                                        self.degree = -8
                                    }
                                }
                            })
                            .onEnded({ (value) in
                                if value.translation.width > 0 {
                                    if value.translation.width > 100 {
                                        self.x = 500
                                        self.degree = 15
                                        self.switchingImage = true
                                        withAnimation(.easeOut(duration : 0.6)) {
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
                                                self.degree = 0
                                            }
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                                                self.scaleAnimation = false
                                            }
                                        }
                                    } else {
                                        
                                        self.x = 0
                                        self.degree = 0
                                    }
                                } else {
                                    if value.translation.width < -100 {
                                        self.x = -500
                                        self.degree = -15
                                        self.switchingImage = true
                                        withAnimation(.easeOut(duration : 0.6)) {
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
                                                self.degree = 0
                                            }
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                                                self.scaleAnimation = false
                                            }
                                        }
                                    } else {
                                        self.x = 0
                                        self.degree = 0
                                    }
                                }
                                self.moveToImage(direction: value.location.x)
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
                            .background((self.displyed == i ? Color.black : Color.gray).cornerRadius(20))
                            .frame(width: (UIScreen.main.bounds.width / CGFloat(self.imageCount)) - 30, height: 10)
                        
                    }
                    Spacer()
                }.padding(.bottom, UIScreen.main.bounds.height / 1.45)
                VStack(alignment: .trailing, spacing: 12) {
                    
                    
                    HStack (alignment: .bottom) {
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
                            .font(.system(size: 30))
                            .foregroundColor(.white)
                            .fontWeight(.heavy)
                    }.onTapGesture {
                        self.showInfo.toggle()
                    }
                }.padding(.bottom, 50)
                    .padding(.trailing, 10)
                    .rotationEffect(.init(degrees: self.degree))
            }
            
            if showInfo {
                ScrollView {
                    Image(uiImage: image)
                        .resizable()
                        .background(Color.gray)
                        .aspectRatio(contentMode: .fill)
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 1.4)
                        .animation(inAnimation ? .default : .none)
                        .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .global)
                            .onEnded({ (value) in
                                
                                self.moveToImage(direction: value.location.x)
                                
                            }))
                        .onReceive(imageLoader.didChange) { data in
                            self.data = data
                            if self.data.hasValueAt(index: self.displyed) {
                                self.image = UIImage(data: data[self.displyed]) ?? UIImage()
                            }}
                    Text("test").onAppear() { print("test") }
                    Text("test").frame(width: 100, height: 100)
                    Text("test").frame(width: 100, height: 100)
                    Text("test").frame(width: 100, height: 100)
                    Text("test").frame(width: 100, height: 100)
                    Text("test").frame(width: 100, height: 100)
                    Text("test").frame(width: 100, height: 100)
                    Text("test").frame(width: 100, height: 100)
                    
                    
                }.frame(width: UIScreen.main.bounds.width , height: UIScreen.main.bounds.height )
                    .background(Color.white)
                    .padding(.top, 40)
            }
        }.padding(.top, 10)
            .offset(x: self.x)
            .rotationEffect(.init(degrees: self.degree))
            .frame(width: UIScreen.main.bounds.width - 10, height: UIScreen.main.bounds.height / 1.8)
            .animation(inAnimation ? .default : .none)
    }
    
    func moveToImage(direction: CGFloat) {
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
}
