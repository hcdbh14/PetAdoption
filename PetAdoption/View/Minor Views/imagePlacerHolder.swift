import SwiftUI

struct imagePlacerHolder: View {
    
    @Binding var image: Image?
    
    init(image: Binding<Image?>) {
        self._image = image
    }
    
    var body: some View {
        
        ZStack {
            if image == nil {
                Image(uiImage: UIImage())
                    .frame(width: UIScreen.main.bounds.width / 3.5 , height: 150)
                    .background(Color("offGray"))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .strokeBorder(
                                style: StrokeStyle(
                                    lineWidth: 2,
                                    dash: [15]
                                )
                            )
                            .foregroundColor(.gray)
                    )
                Image(systemName: "plus.circle").resizable()
                    .frame(width: 25, height: 25)
                    .foregroundColor(.gray)
            } else {
                image?.resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width / 3.5 , height: 150)
                    .background(Color.black)
                    .cornerRadius(10)
                    .fixedSize()
            }
        }
        
    }
}
