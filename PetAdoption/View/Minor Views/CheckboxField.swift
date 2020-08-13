import SwiftUI

struct CheckboxField: View {
    let id: Int
    let label: String
    let size: CGFloat
    let color: Color
    let textSize: Int
    let callback: (Int)->()
    var onLightBackground: Bool
    @Binding var suiteables: [Int]
    @State var isMarked: Bool = false
 
    init(
        id: Int,
        label: String,
        size: CGFloat = 10,
        color: Color = Color.orange,
        textSize: Int = 14,
        onLightBackground: Bool? = nil,
        callback: @escaping (Int)->(),
        suiteables: Binding< [Int]>
    ) {
        self.id = id
        self.label = label
        self.size = size
        self.color = color
        self.textSize = textSize
        self.callback = callback
        self.onLightBackground = onLightBackground ?? false
        self._suiteables = suiteables
    }
    
    
    var body: some View {
        Button(action:{
            self.callback(self.id)
        }) {
            HStack(alignment: .center, spacing: 10) {
                if onLightBackground {
                    ZStack {
                        if suiteables.contains(id)  {
                            
                        Image(systemName: "checkmark" )
                            .resizable()
                            .foregroundColor(Color.black)
                            .frame(width: self.size - 5, height: self.size - 5)
                        }
                        
                        Image(systemName: "square")
                            .resizable()
                            .foregroundColor(Color.orange)
                            .frame(width: self.size + 5, height: self.size + 5)
                    }
                    
                } else {
                Image(systemName: suiteables.contains(id)  ? "checkmark.square" : "square")
                    .resizable()
                    .foregroundColor(Color.orange)
                    .frame(width: self.size, height: self.size)
                }
                
                Text(label)
                    .font(Font.system(size: size,weight: onLightBackground ? .semibold : .regular))
                Spacer()
            }.foregroundColor(self.color)
        }
        .foregroundColor(Color.white)
    }
}
