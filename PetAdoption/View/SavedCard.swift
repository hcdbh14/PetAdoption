import SwiftUI

struct SavedCard: View {
    
    @State private var image: UIImage = UIImage()
    @ObservedObject var imageLoader: ImageLoader
    
    init(imageURL: [String]) {
        imageLoader = ImageLoader(urlString: imageURL)
    }
    
    
    var body: some View {
        
        ZStack(alignment: .bottomLeading) {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: (UIScreen.main.bounds.width / 2) - 10, height: UIScreen.main.bounds.height / 4)
                .cornerRadius(20)
                .onReceive(imageLoader.didChange) { data in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.image = UIImage(data: data[0]) ?? UIImage()
                    }
            }
        }
    }
}
