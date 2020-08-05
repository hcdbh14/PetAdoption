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
        
        List(regionsList, id: \.self) { region in
            Text(region)
        }
        }.environment(\.layoutDirection, .rightToLeft)
    }
    
    func close() {
        showRegions = false
    }
}
