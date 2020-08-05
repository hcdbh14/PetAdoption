import SwiftUI

struct Regions: View {
    
    let regionsList = ["ראשון לצין","נתניה"]
    @State var searchText = ""
    @Binding var showRegions: Bool
    @Binding var chosenRegion: String
    
    init(showRegions: Binding<Bool>, region: Binding<String>) {
        self._showRegions = showRegions
        self._chosenRegion = region
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
            }.padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
                .foregroundColor(Color.gray)
                .background(Color("offWhite"))
                .cornerRadius(10.0)
            
            List(self.regionsList.filter{$0.contains(self.searchText.lowercased()) || self.searchText == ""}, id: \.self) { region in
                Button(action: {
                    self.closeAndPassRegion(region)
                }) {
                    Text(region)
                }
            }
            
        }.environment(\.layoutDirection, .rightToLeft)
    }
    
    
    func close() {
       showRegions = false
    }
    
    func closeAndPassRegion(_ region: String) {
        self.chosenRegion = region
        showRegions = false
    }
}
