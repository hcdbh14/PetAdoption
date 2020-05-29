import SwiftUI

struct BackCard: View {
    @ObservedObject var imageLoader: DataLoader
    @State var image: UIImage = UIImage()
    @Binding var scaleAnimation: Bool
    
    init(imageURL: [String], scaleTrigger: Binding<Bool>) {
        imageLoader = DataLoader(urlString: imageURL)
        self._scaleAnimation = scaleTrigger
    }
    
    
    var body: some View {
        
        ZStack(alignment: .bottomLeading) {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: UIScreen.main.bounds.width - 10, height: UIScreen.main.bounds.height / 1.4)
                .cornerRadius(20)
                .scaleEffect(scaleAnimation ? 1 : 0.9)
                .onReceive(imageLoader.didChange) { data in
                      DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.image = UIImage(data: data[0]) ?? UIImage()
                    }
            }
        }.padding(.top, 10)
    }
}
