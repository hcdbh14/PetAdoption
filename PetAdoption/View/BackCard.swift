import SwiftUI

struct BackCard: View {
    
    @Binding private var scaleAnimation: Bool
    @ObservedObject private var mainVM: MainVM
    
    init(scaleTrigger: Binding<Bool>, mainVM: MainVM) {
        self.mainVM = mainVM
        self._scaleAnimation = scaleTrigger
    }
    
    
    var body: some View {
        
        ZStack(alignment: .bottomLeading) {
            Image(uiImage: self.mainVM.backImageLoaded ?  populateImage() : UIImage())
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: UIScreen.main.bounds.width - 10, height: UIScreen.main.bounds.height / 1.4)
                .cornerRadius(20)
                .animation(.none)
        }.animation(scaleAnimation ? .spring() : .none)
        .scaleEffect(scaleAnimation ? 1 : 0.9)
    }
    
    private func populateImage()  -> UIImage {
        if self.mainVM.dogsList.hasValueAt(index: self.mainVM.count) {
            if mainVM.backImageLoaded {
                return UIImage(data: self.mainVM.backImages[0]) ?? UIImage()
            } else {
                 return UIImage()
            }
        } else {
            return UIImage()
        }
    }
}
