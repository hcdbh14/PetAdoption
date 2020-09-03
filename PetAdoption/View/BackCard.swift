import SwiftUI

struct BackCard: View {
    
    @State private var image: UIImage = UIImage()
    @Binding private var scaleAnimation: Bool
    @ObservedObject private var cardVM: CardVM
    
    init(scaleTrigger: Binding<Bool>, mainVM: CardVM) {
        self.cardVM = mainVM
        self._scaleAnimation = scaleTrigger
    }
    
    
    var body: some View {
        
        ZStack(alignment: .bottomLeading) {
            Image(uiImage: image).resizable()
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.width - 10, height: UIScreen.main.bounds.height / 1.4)
                .background(Color.black)
                .fixedSize()
                .cornerRadius(20)
                .animation(.none)
                .onReceive(cardVM.reloadBackImage, perform:  { answer in
                    self.populateImage(answer)
                })
        }.animation(scaleAnimation ? .spring() : .none)
        .scaleEffect(scaleAnimation ? 1 : 0.9)
    }
    
    private func populateImage(_ isImageReady: Bool) {
        if isImageReady == false {
            image = UIImage()
            return
        }
        
        if self.cardVM.backImages.hasValueAt(index: 0)   {
            image = UIImage(data: self.cardVM.backImages[0]) ?? UIImage()
        } else {
            image = UIImage()
        }
    }
}
