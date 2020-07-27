import SwiftUI

struct BackCard: View {
    
    @State private var image: UIImage = UIImage()
    @Binding private var scaleAnimation: Bool
    @ObservedObject private var mainVM: MainVM
    
    init(scaleTrigger: Binding<Bool>, mainVM: MainVM) {
        self.mainVM = mainVM
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
                .onReceive(mainVM.isBackImageReady, perform:  { answer in
                    self.populateImage()
                })
        }.animation(scaleAnimation ? .spring() : .none)
        .scaleEffect(scaleAnimation ? 1 : 0.9)
    }
    
    private func populateImage() {
        
        if self.mainVM.backImages.hasValueAt(index: 0)   {
            image = UIImage(data: self.mainVM.backImages[0]) ?? UIImage()
        } else {
            image = UIImage()
        }
    }
}
