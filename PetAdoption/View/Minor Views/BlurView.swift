import SwiftUI

struct BlurView: UIViewRepresentable {
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .systemMaterial))
        return view
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        
    }
    struct CustomAlertView: View {
        
        @Binding var show: Bool
        
        var body: some View {
            
            ZStack(alignment: Alignment(horizontal: .trailing, vertical: .top)) {
                Text("hey")
                
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(
                    Color.primary.opacity(0.35)
                        .onTapGesture {
                            withAnimation {
                                self.show.toggle()
                            }
                })
        }
    }
}
