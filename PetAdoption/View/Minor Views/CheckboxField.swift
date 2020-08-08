import SwiftUI

struct CheckboxField: View {
    let id: Int
    let label: String
    let size: CGFloat
    let color: Color
    let textSize: Int
    let callback: (Int)->()
    let marked: Bool
    var onLightBackground: Bool
    @Binding var suiteables: [Int]
    @State var isMarked: Bool = false
 
    init(
        id: Int,
        label: String,
        size: CGFloat = 10,
        color: Color = Color.orange,
        textSize: Int = 14,
        marked: Bool,
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
        self.marked = marked
        self._suiteables = suiteables
    }
    
    
    var body: some View {
        Button(action:{
            self.isMarked.toggle()
            self.callback(self.id)
        }) {
            HStack(alignment: .center, spacing: 10) {
                if onLightBackground {
                    ZStack {
                        if isMarked || suiteables.contains(id)  {
                            
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
                Image(systemName: self.isMarked ? "checkmark.square" : "square")
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
        .onAppear() {
            if self.marked {
                self.isMarked = true
            }
        }
    }
}
