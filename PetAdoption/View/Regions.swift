import SwiftUI

struct Cities: View {
    
    let cityList = ["ראשון לצין","נתניה"]
    @State var searchText = ""
    @Binding var showCities: Bool
    @Binding var chosenCity: String
    
    init(showCities: Binding<Bool>, city: Binding<String>) {
        self._showCities = showCities
        self._chosenCity = city
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
            
            List(self.cityList.filter{$0.contains(self.searchText.lowercased()) || self.searchText == ""}, id: \.self) { city in
                Button(action: {
                    self.closeAndPassCity(city)
                }) {
                    Text(city)
                }
            }
            
        }.environment(\.layoutDirection, .rightToLeft)
    }
    
    
    func close() {
       showCities = false
    }
    
    func closeAndPassCity(_ region: String) {
        self.chosenCity = region
        showCities = false
    }
}
