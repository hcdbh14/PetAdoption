import SwiftUI

struct Card: View {
 
    @ObservedObject var imageLoader: DataLoader
    @State var image:UIImage = UIImage()
    
    
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
                    .padding(.top, 100)
                    .onReceive(imageLoader.didChange) { data in
                    self.image = UIImage(data: data) ?? UIImage()
                }
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
        }
    }
}
