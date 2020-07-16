import SwiftUI

struct MenuView: View {
    
    @Binding var showMenu: Bool
    @ObservedObject var settings = Settings()
    
    init(showMenu: Binding<Bool>) {
        self._showMenu = showMenu
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            
                Text("הגדרות")
                    .foregroundColor(.white)
                    .padding(.top, 30)
                    .padding(.leading, 15)
                    .font(.system(size: 34))
            
            line.frame(width: UIScreen.main.bounds.width  / 1.2, height: 1)
            
            Text("איזה חיות להציג?")
                .foregroundColor(.white)
                .padding(.top, 20)
                .padding(.leading, 15)
                .font(.system(size: 24))
            
            line.frame(width: UIScreen.main.bounds.width  / 1.4, height: 1)
                .padding(.leading, 15)
            
            HStack (spacing: 40) {
                Spacer()
                VStack {
                Image("dog").resizable()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.white)
                    Text("כלבים")
                        .foregroundColor(settings.searchBy == SearchBy.dog.rawValue ? .orange : .white)
                     
                }.onTapGesture {
                    self.settings.updateSettings(SearchBy.dog.rawValue)
                }
                
                VStack {
                Image("cat").resizable()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.white)
                    Text("חתולים")
                        .foregroundColor(settings.searchBy == SearchBy.cat.rawValue ? .orange : .white)
                }.onTapGesture {
                      self.settings.updateSettings(SearchBy.cat.rawValue)
                }
                
                VStack {
                Image("dogAndCat").resizable()
                    .frame(width: 60, height: 40)
                    .foregroundColor(.white)
                    Text("הכל")
                       .foregroundColor(settings.searchBy == SearchBy.all.rawValue ? .orange : .white)
                }.onTapGesture {
                      self.settings.updateSettings(SearchBy.all.rawValue)
                }
                Spacer()
            }.padding(.leading, -30)
            
            Text("באיזה אזור לחפש?")
                .foregroundColor(.white)
                .padding(.top, 30)
                .padding(.leading, 15)
                .font(.system(size: 24))
            line.frame(width: UIScreen.main.bounds.width  / 1.4, height: 1)
                .padding(.leading, 15)
            
            HStack {
            CheckboxField(id: "hey", label: "צפון", size: 20, color: .white, textSize: 20, callback: checkboxSelected)
                     CheckboxField(id: "hey", label: "מרכז", size: 20, color: .white, textSize: 20, callback: checkboxSelected)
                              CheckboxField(id: "hey", label: "דרום", size: 20, color: .white, textSize: 20, callback: checkboxSelected)
            }
        }
        .frame(maxWidth: UIScreen.main.bounds.width / 1.2, maxHeight: .infinity, alignment: .topLeading)
        .background(Color("offBlack"))
        .edgesIgnoringSafeArea(.all)
    }
}

private var line: some View {
    VStack {
        Divider()
            .background(Color.orange)
    }
}

    func checkboxSelected(id: String, isMarked: Bool) {
        print("\(id) is marked: \(isMarked)")
    }


import SwiftUI

//MARK:- Checkbox Field
struct CheckboxField: View {
    let id: String
    let label: String
    let size: CGFloat
    let color: Color
    let textSize: Int
    let callback: (String, Bool)->()
    
    init(
        id: String,
        label:String,
        size: CGFloat = 10,
        color: Color = Color.orange,
        textSize: Int = 14,
        callback: @escaping (String, Bool)->()
        ) {
        self.id = id
        self.label = label
        self.size = size
        self.color = color
        self.textSize = textSize
        self.callback = callback
    }
    
    @State var isMarked: Bool = false
    
    var body: some View {
        Button(action:{
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
    }
}
