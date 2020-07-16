import SwiftUI

struct CheckboxField: View {
    let id: Int
    let label: String
    let size: CGFloat
    let color: Color
    let textSize: Int
    let callback: (Int, Bool)->()
    let marked: Bool
    @State var isMarked: Bool = false
    
    init(
        id: Int,
        label: String,
        size: CGFloat = 10,
        color: Color = Color.orange,
        textSize: Int = 14,
        marked: Bool,
        callback: @escaping (Int, Bool)->()
    ) {
        self.id = id
        self.label = label
        self.size = size
        self.color = color
        self.textSize = textSize
        self.callback = callback
        self.marked = marked
    }
    
    
    var body: some View {
        Button(action:{
            print(isMarked)
            self.isMarked.toggle()
            self.callback(self.id, self.isMarked)
        }) {
            HStack(alignment: .center, spacing: 10) {
                Image(systemName: self.isMarked ? "checkmark.square" : "square")
                    .resizable()
                    .foregroundColor(Color.orange)
                    .frame(width: self.size, height: self.size)
                
                Text(label)
                    .font(Font.system(size: size))
                Spacer()
            }.foregroundColor(self.color)
        }
        .foregroundColor(Color.white)
        .onAppear() {
            if marked {
                isMarked = true
            }
        }
    }
}
