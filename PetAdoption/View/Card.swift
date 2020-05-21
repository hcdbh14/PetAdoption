import SwiftUI

struct Card: View {
    var dogName: String
    
    init(dogName: String) {
        self.dogName = dogName
    }
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            VStack {
                Image(dogName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: UIScreen.main.bounds.width - 10, height: UIScreen.main.bounds.height / 1.8)
                    .cornerRadius(20)
                    .padding(.top, 100)
                
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
