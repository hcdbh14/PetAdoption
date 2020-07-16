import SwiftUI

struct MenuView: View {
    
    @Binding var showMenu: Bool
    @ObservedObject var settings = Settings()
    private var line: some View {
        VStack {
            Divider().background(Color.orange)
        }
    }
    
    init(showMenu: Binding<Bool>) {
        self._showMenu = showMenu
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            
            VStack(alignment: .leading) {
                Text("הגדרות")
                    .foregroundColor(.white)
                    .padding(.top, 30)
                    .padding(.leading, 15)
                    .font(.system(size: 34))
                
                line.frame(width: UIScreen.main.bounds.width  / 1.2, height: 1)
            }
            
            VStack(alignment: .leading) {
                Text("איזה חיות להציג?")
                    .foregroundColor(.white)
                    .padding(.top, 20)
                    .padding(.leading, 15)
                    .font(.system(size: 24))
                
                line.frame(width: UIScreen.main.bounds.width  / 1.4, height: 1)
                    .padding(.leading, 15)
            }
            
            HStack (spacing: 40) {
                Spacer()
                Button(action: {
                    self.settings.updateSettings(SearchBy.dog.rawValue)
                }) {
                    VStack(alignment: .center) {
                        Image("dog").resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(settings.searchBy == SearchBy.dog.rawValue ?.orange : .gray)
                        Text("כלבים")
                            .foregroundColor(settings.searchBy == SearchBy.dog.rawValue ? .orange : .white)
                        
                    }
                }
                
                Button(action: {
                    self.settings.updateSettings(SearchBy.cat.rawValue)
                }) {
                    VStack(alignment: .center) {
                        Image("cat").resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(settings.searchBy == SearchBy.cat.rawValue ? .orange : .gray)
                        Text("חתולים")
                            .foregroundColor(settings.searchBy == SearchBy.cat.rawValue ? .orange : .white)
                    }
                }
                
                Button(action: {
                    self.settings.updateSettings(SearchBy.all.rawValue)
                }) {
                    VStack(alignment: .center) {
                        Image("dogAndCat").resizable()
                            .frame(width: 60, height: 40)
                            .foregroundColor(settings.searchBy == SearchBy.all.rawValue ? .orange : .gray)
                        Text("הכל")
                            .foregroundColor(settings.searchBy == SearchBy.all.rawValue ? .orange : .white)
                    }
                }
                Spacer()
            }.padding(.leading, -30)
            
            VStack(alignment: .leading) {
                Text("באיזה אזור לחפש?")
                    .foregroundColor(.white)
                    .padding(.top, 30)
                    .padding(.leading, 15)
                    .font(.system(size: 24))
                line.frame(width: UIScreen.main.bounds.width  / 1.4, height: 1)
                    .padding(.leading, 15)
            }
            
            HStack {
                CheckboxField(id: 0, label: "צפון", size: 20, color: .white, textSize: 20, marked: settings.areas?.contains(0) ?? false, callback: checkboxSelected)
                CheckboxField(id: 1, label: "מרכז", size: 20, color: .white, textSize: 20, marked: settings.areas?.contains(1) ?? false, callback: checkboxSelected)
                CheckboxField(id: 2, label: "דרום", size: 20, color: .white, textSize: 20, marked: settings.areas?.contains(2) ?? false, callback: checkboxSelected)
            }.padding(.leading, 15)
            
            VStack(alignment: .leading) {
                Text("איזה גיל?")
                    .foregroundColor(.white)
                    .padding(.top, 30)
                    .font(.system(size: 24))
                line.frame(width: UIScreen.main.bounds.width  / 1.4, height: 1)
            }.padding(.leading, 15)
            
            HStack {
                CheckboxField(id: 3, label: "גור", size: 20, color: .white, textSize: 20, marked: settings.areas?.contains(3) ?? false, callback: checkboxSelected)
                CheckboxField(id: 4, label: "צעיר", size: 20, color: .white, textSize: 20, marked: settings.areas?.contains(4) ?? false, callback: checkboxSelected)
                CheckboxField(id: 5, label: "בוגר", size: 20, color: .white, textSize: 20, marked: settings.areas?.contains(5) ?? false, callback: checkboxSelected)
            }.padding(.leading, 15)
                .padding(.bottom, 50)
            
            line.frame(width: UIScreen.main.bounds.width  / 1.2, height: 1)
            
            
            Button(action: {
                print("pressed")
                
            })
            {
                HStack {
                    Text("פרסמו כלב לאימוץ").foregroundColor(.orange)
                        .font(.system(size: 18))
                    Image(systemName: "arrow.left").resizable()
                        .frame(width: 25, height: 25)
                        .foregroundColor(.orange)
                }.padding(.leading, 15)
                    .padding(.top, 25)
            }
        }
        .frame(maxWidth: UIScreen.main.bounds.width / 1.2, maxHeight: .infinity, alignment: .topLeading)
        .background(Color("offBlack"))
        .edgesIgnoringSafeArea(.all)
    }
    
    func checkboxSelected(id: Int) {
        settings.updateArea(id)
    }
}




