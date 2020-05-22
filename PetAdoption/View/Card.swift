import SwiftUI

struct Card: View {
    @State var displyed = 1
    @State var imageCount = 5
    @ObservedObject var imageLoader: DataLoader
    @State var image: UIImage = UIImage()
    
    
    init(imageURL: String) {
        imageLoader = DataLoader(urlString:imageURL)
    }
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            VStack {

                
                 Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: UIScreen.main.bounds.width - 10, height: UIScreen.main.bounds.height / 1.8)
                    .cornerRadius(20)
                    .onReceive(imageLoader.didChange) { data in
                    self.image = UIImage(data: data) ?? UIImage()
                }
                HStack {
                    ForEach (1...imageCount,id: \.self) { i in
                        Rectangle()
                            
                            .fill(Color.clear)
                            .background((self.displyed == i ? Color.black : Color.gray).cornerRadius(20))
                            
                            .frame(width: (UIScreen.main.bounds.width / CGFloat(self.imageCount)) - 30, height: 10)
                    }
     
                    
                        
                }.padding(.top, -UIScreen.main.bounds.height / 1.8)
            }
            VStack(alignment: .leading, spacing: 12) {
                Text("Doggie")
                    .font(.title)
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                
                Text("good oby")
                    .font(.body)
                    .foregroundColor(.white)
                    .fontWeight(.bold)
            }.padding(.bottom, 50)
                .padding(.leading, 10)
        }.padding(.top, 100)
    }
}
