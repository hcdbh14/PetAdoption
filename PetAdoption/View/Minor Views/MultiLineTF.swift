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
        tview.textContainer.maximumNumberOfLines = 8
        tview.textColor = .gray
        tview.backgroundColor = UIColor(named: "offPureWhite")
        tview.font = .systemFont(ofSize: 18)
        tview.delegate = context.coordinator
        tview.textAlignment = .right
        return tview
    }
    
    func updateUIView(_ uiView: UITextView, context: UIViewRepresentableContext<MultiLineTF>) {
        if txt != "" {
            uiView.text = txt
            uiView.textColor = .label
        }
    }
    
    
    class Coordinator : NSObject, UITextViewDelegate {
        
        var parent : MultiLineTF
        private var lineCounter = 1
        
        init(parent : MultiLineTF) {
            self.parent = parent
        }
        
        
        
        func textViewDidChange(_ textView: UITextView) {
            
            let size = textView.sizeThatFits(textView.frame.size)
            if size.width >= UIScreen.main.bounds.width - 50 {
                let subString = textView.text.suffix(1)
                textView.text.removeLast(1)
                textView.text.append(contentsOf: "\n" +  subString)
            }
            self.parent.txt = textView.text
        }
        
        func textViewDidBeginEditing(_ textView: UITextView) {
            if textView.text == "הקלידו פה הערות/תאור/פרטים נוספים" {
                textView.text = ""
                // for dark mode im using label text
                textView.textColor = .label
            }
        }
        
        func textViewDidEndEditing(_ textView: UITextView) {
            if textView.text == "" {
                textView.text = "הקלידו פה הערות/תאור/פרטים נוספים"
                textView.textColor = .gray
            } else {
                textView.textColor = .label
            }
        }
    }
}
