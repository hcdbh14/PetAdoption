import SwiftUI

struct Card: View {
    @Binding var displyed: Int
    var imageCount: Int
    @ObservedObject var imageLoader: DataLoader
    @State var image: UIImage = UIImage()
    @EnvironmentObject var mainVM: MainVM
    @State var x: CGFloat = 0
    @State var degree: Double = 0
    @State var data: [Data] = []
    @State var inAnimation = false
    
    
    init(imageURL: [String], displayed: Binding<Int>, imageCount: Int) {
        
        imageLoader = DataLoader(urlString: imageURL)
        self.imageCount = imageCount
        self._displyed = displayed
    }
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            VStack {

                Image(uiImage: image)
                    .resizable()
                    .background(Color.gray)
                    .aspectRatio(contentMode: .fill)
                    .frame(width: UIScreen.main.bounds.width - 10, height: UIScreen.main.bounds.height / 1.8)
                    .cornerRadius(20)
                    .animation(inAnimation ? .none : .default)
                    .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .global)
                        .onChanged({ (value) in
                            
                            if value.startLocation != value.location {
                                print(value)
                                
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
                                    self.displyed = 0
                                    self.inAnimation = true
                                    self.mainVM.pushNewImage()
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                        self.x = 0
                                        self.degree = 0
                                        self.inAnimation = false
                                    }
                                } else {
                                    
                                    self.x = 0
                                    self.degree = 0
                                }
                            } else {
                                if value.translation.width < -100 {
                                    self.x = -500
                                    self.degree = -15
                                    self.mainVM.pushNewImage()
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                        withAnimation (.none) {
                                            self.displyed = 0
                                            self.inAnimation = true
                                            self.x = 0
                                            self.degree = 0
                                        }
                                        
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                                            
                                            
                                            self.inAnimation = false
                                        }
                                    }
                                    
                                } else {
                                    self.x = 0
                                    self.degree = 0
                                }
                            }
                            
                            if value.location.x > 180 {
                                
                                if self.displyed == self.imageCount - 1 || self.inAnimation {
                                    return
                                } else {
                                    if self.data.hasValueAt(index: self.displyed + 1) {
                                        self.displyed += 1
                                        self.image = UIImage(data: self.data[self.displyed]) ?? UIImage()
                                    } else {
                                        self.displyed += 1
                                        self.image = UIImage()
                                    }
                                    
                                }
                            } else {
                                if self.displyed == 0 || self.inAnimation {
                                    return
                                } else {
                                    if self.data.hasValueAt(index: self.displyed - 1) {
                                        self.displyed -= 1
                                        self.image = UIImage(data: self.data[self.displyed]) ?? UIImage()
                                    } else {
                                         self.displyed -= 1
                                        self.image = UIImage()
                                    }
                                    
                                }
                            }
                        }))
                    .onReceive(imageLoader.didChange) { data in
                        if self.data.hasValueAt(index: self.displyed) {
                            self.image = UIImage(data: data[self.displyed]) ?? UIImage()
                        }
                        self.data = data
                }
                
                HStack {
                    ForEach (0...imageCount - 1,id: \.self) { i in
                        Rectangle()
                            .fill(Color.clear)
                            .background((self.displyed == i ? Color.black : Color.gray).cornerRadius(20))
                            .frame(width: (UIScreen.main.bounds.width / CGFloat(self.imageCount)) - 30, height: 10)
                            .animation(.none)       
                    }.animation(.none)
                    
                    
                    
                }.padding(.top, -UIScreen.main.bounds.height / 1.8)
            }
            VStack(alignment: .leading, spacing: 12) {
                Text("Doggie")
                    .font(.title)
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .animation(.none)
                
                Text("good oby")
                    .font(.body)
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .animation(.none)
            }.padding(.bottom, 50)
                .padding(.leading, 10)
                .animation(.none)
        }.padding(.top, 100)
            .offset(x: self.x)
            .rotationEffect(.init(degrees: self.degree))
            .frame(width: UIScreen.main.bounds.width - 10, height: UIScreen.main.bounds.height / 1.8)
            .animation(inAnimation ? .none : .default)
    }
}


extension Array {
    func hasValueAt(index: Int ) -> Bool {
        return index >= startIndex && index < endIndex
    }
}
