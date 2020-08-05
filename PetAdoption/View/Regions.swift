import SwiftUI

struct Regions: View {
    
    let regionsList = ["ראשון לצין","נתניה"]
    @State var searchText = ""
    @Binding var showRegions: Bool
    
    init(showRegions: Binding<Bool>) {
        self._showRegions = showRegions
    }
    
    var body: some View {
        VStack {
            HStack {
                Button(action: close) {
                    HStack {
                        Image(systemName: "chevron.right")
                        Text("חזור")
                    }
                }
                .foregroundColor(Color("orange"))
                .padding(.top, 15)
                .padding(.leading, 25)
                Spacer()
            }
            
            HStack {
                Image(systemName: "magnifyingglass")
                TextField("חיפוש עיר", text: $searchText)
                Button(action: {
                    self.searchText = ""
                }) {
                    Image(systemName: "xmark.circle.fill").opacity(searchText == "" ? 0 : 1)
                }
            }.padding(15)
                .foregroundColor(Color.gray)
                .background(Color.white)
                .cornerRadius(10.0)
 
            List(self.regionsList.filter{$0.contains(self.searchText.lowercased()) || self.searchText == ""}, id: \.self) { region in
                Text(region)
            }
            
        }.environment(\.layoutDirection, .rightToLeft)
    }
    
    func close() {
        showRegions = false
    }
}
