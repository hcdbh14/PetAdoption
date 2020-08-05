import SwiftUI

struct Regions: View {
    @Binding var showRegions: Bool
    
    init(showRegions: Binding<Bool>) {
        self._showRegions = showRegions
    }
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}
