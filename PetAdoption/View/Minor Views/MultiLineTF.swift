import SwiftUI

struct MultiLineTF : UIViewRepresentable {
    
    @Binding var txt : String
    
    func makeCoordinator() -> Coordinator {
        return MultiLineTF.Coordinator(parent: self)
    }
    
    func makeUIView(context: UIViewRepresentableContext<MultiLineTF>) -> UITextView {
        
        let tview = UITextView()
        tview.isEditable = true
        tview.isUserInteractionEnabled = true
        tview.isScrollEnabled = false
        tview.text = "הקלידו פה הערות/תאור/פרטים נוספים"
        tview.textColor = .gray
        tview.backgroundColor = UIColor(named: "offPureWhite")
        tview.font = .systemFont(ofSize: 18)
        tview.delegate = context.coordinator
        tview.textAlignment = .right
        return tview
    }
    
    func updateUIView(_ uiView: UITextView, context: UIViewRepresentableContext<MultiLineTF>) {
        
    }
    
    
    class Coordinator : NSObject, UITextViewDelegate {
        
        var parent : MultiLineTF
        
        init(parent : MultiLineTF) {
            self.parent = parent
        }
        
        func textViewDidChange(_ textView: UITextView) {
            
        }
        
        func textViewDidBeginEditing(_ textView: UITextView) {
            textView.text = ""
            // for dark mode im using label text
            textView.textColor = .label
        }
        
        func textViewDidEndEditing(_ textView: UITextView) {
            if textView.text == "" {
                textView.text = "הקלידו פה הערות/תאור/פרטים נוספים"
                textView.textColor = .gray
            }
        }
    }
}
