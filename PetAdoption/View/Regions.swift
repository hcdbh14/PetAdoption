import SwiftUI

struct Cities: View {
    
    @State private var searchText = ""
    @Binding private var showCities: Bool
    @Binding private var chosenCity: String
    private let cityList = ["ראשון לצין","נתניה"]
    
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
    
    
    private func close() {
       showCities = false
    }
    
    private func closeAndPassCity(_ region: String) {
        self.chosenCity = region
        showCities = false
    }
}
