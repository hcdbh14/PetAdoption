import SwiftUI

struct Regions: View {
    
    let regionsList = ["ראשון לצין","נתניה"]
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
                .padding(.leading, 25)
                Spacer()
            }
            
            List {
                // 2.
                Section(header:
                Text("צפון")) {
                    ForEach(0 ..< regionsList.count) {
                        Text(self.regionsList[$0])
                    }
                }
                // 3.
                Section(header:
                Text("מרכז")) {
                    ForEach(0 ..< regionsList.count) {
                        Text(self.regionsList[$0])
                    }
                }
                
                Section(header:
                Text("דרום")) {
                    ForEach(0 ..< regionsList.count) {
                        Text(self.regionsList[$0])
                    }
                }
                
            }
        }.environment(\.layoutDirection, .rightToLeft)
    }
    
    func close() {
        showRegions = false
    }
}
