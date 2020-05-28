import SwiftUI


struct BackCard: View {
    @ObservedObject var imageLoader: DataLoader
    @State var image: UIImage = UIImage()
    @State var inAnimation = false
    
    
    init(imageURL: [String]) {
        imageLoader = DataLoader(urlString: imageURL)
    }
    
    
    var body: some View {
        
        ZStack(alignment: .bottomLeading) {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: UIScreen.main.bounds.width - 10, height: UIScreen.main.bounds.height / 1.9)
                .cornerRadius(20)
                .onReceive(imageLoader.didChange) { data in
                      DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.image = UIImage(data: data[0]) ?? UIImage()
                    }
            }
        }.padding(.top, 100)
    }
}
