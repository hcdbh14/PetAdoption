import SwiftUI
import Combine

enum TextFieldCorrection {
    
    case correct
    case needFixing
    case empty
}

enum ChosenImage {
    case first
    case second
    case third
    case fourth
}

struct PostNewDog: View {
    
    @State var description = ""
    @State var chosenImage = ChosenImage.first
    private let allowedChars = Set("abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLKMNOPQRSTUVWXYZ אבגדהוזחטיכךלמםנןסעפףצץקרשת")
    @State var value : CGFloat = 0
    @State private var petType = "כלב"
    @State private var correctTextField = TextFieldCorrection.empty
    @State private var petAge = ""
    @State private var petAgeError = ""
    @State private var petRace = ""
    @State private var petRaceError = ""
    @State private var petName = ""
    @State private var petNameError = ""
    @State private var image: Image?
    @State private var secondImage: Image?
    @State private var thirdImage: Image?
    @State private var fourthImage: Image?
    @State var triggerFade = true
    @Binding var showPostPet: Bool
    @Binding var showAuthScreen: Bool
    @State private var inputImage: UIImage?
    @State private var showingImagePicker = false
    @EnvironmentObject var session: SessionStore
    @Environment (\.colorScheme) var colorScheme: ColorScheme
    
    init(showAuthScreen: Binding<Bool>, showPostPet: Binding<Bool>) {
        self._showPostPet = showPostPet
        self._showAuthScreen = showAuthScreen
    }
    
    var body: some View {
        ScrollView {
            HStack {
                Button(action: closeLoginScreen) {
                    HStack {
                        Image(systemName: "chevron.right")
                        Text("חזור")
                    }
                }
                .foregroundColor(Color("orange"))
                .padding(.leading, 25)
                Spacer()
                
                if session.session != nil {
                    Button(action: signOut) {
                        Text("התנתקות")
                            .foregroundColor(Color("orange"))
                            .padding(.trailing, 15)
                    }
                }
            }.padding(.top,  UIDevice.current.systemVersion != "14.0" ?  80 : 40)
            
            
            
            HStack {
                Text("תמונות")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(Color("offBlack"))
                    .padding(.leading, 25)
                Spacer()
            }.onAppear() {
                withAnimation {
                    self.triggerFade = false
                }
            }
            HStack {
                Spacer()
                Text("צריך לפחות תמונה אחת. התמונה שפה תהיה הראשונה שאנשים יראו")
                    .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
                    .foregroundColor(.black)
                
                ZStack {
                    Image(systemName: "arrow.left").resizable()
                        .frame(width: 60,height: 40)
                        .foregroundColor(.gray)
                }.frame(width: UIScreen.main.bounds.width / 3.5)
                
                imagePlacerHolder(image: $image).onTapGesture {
                    self.chosenImage = .first
                    self.showingImagePicker = true
                }
                Spacer()
            }
            
            HStack {
                Spacer()
                imagePlacerHolder(image: $secondImage).onTapGesture {
                    self.chosenImage = .second
                    self.showingImagePicker = true
                }
                imagePlacerHolder(image: $thirdImage).onTapGesture {
                    self.chosenImage = .third
                    self.showingImagePicker = true
                }
                imagePlacerHolder(image: $fourthImage).onTapGesture {
                    self.chosenImage = .fourth
                    self.showingImagePicker = true
                }
                Spacer()
            }.padding(.bottom, 25)
            
            VStack {
                HStack {
                    
                    Text("איזה חיית מחמד?")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(Color("offBlack"))
                        .padding(.leading, 25)
                        .padding(.bottom, 25)
                    Spacer()
                }.padding(.top, 25)
            }
            
            VStack {
                HStack {
                    Spacer()
                    Picker(selection: $petType, label: Text("בחרו סוג החייה")) {
                        Text("כלב").tag("כלב")
                        Text("חתול").tag("חתול")
                        Text("אחר").tag("חיית מחמד")
                    }.pickerStyle(SegmentedPickerStyle())
                        .padding(.bottom, 25)
                    Spacer()
                }
                
                
                
                HStack {
                    Text("פרטי ה\(petType)")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(Color("offBlack"))
                        .padding(.leading, 25)
                        .padding(.bottom, 30)
                    Spacer()
                }
                
                
                HStack {
                    Text("שם")
                        .font(.system(size: 20, weight: .regular))
                        .foregroundColor(Color("offBlack"))
                        .padding(.leading, 25)
                        .padding(.bottom, 5)
                    Spacer()
                }
                
                ZStack {
                    HStack {
                        TextField("הקלידו את השם כאן", text: $petName, onEditingChanged: { (editingChanged) in
                            if editingChanged {
                                print("TextField focused")
                            } else {
                                if self.petName.isEmpty == false {
                                    self.correctTextField = .correct
                                    if self.petName.count <= 24 {
                                        self.petNameError =  ""
                                    }
                                } else {
                                    self.correctTextField = .empty
                                }
                            }
                        })
                            .onReceive(Just(petName)) { newValue in
                                let filtered = self.petName.filter { self.allowedChars.contains($0) }
                                if filtered != self.petName {
                                    self.petName = filtered
                                }
                        }
                        .onReceive(petName.publisher.collect()) {
                            if self.petName.count > 24 {
                                self.petNameError =  "שם ה\(self.petType) ארוך מדיי "
                            }
                            self.petName = String($0.prefix(24))
                        }
                        .padding(.leading, 30)
                        .padding(.bottom, 25)
                        .frame(width: UIScreen.main.bounds.width - 70 , height: 50)
                        Spacer()
                    }
                    
                    Divider().background(Color.black).frame(width: UIScreen.main.bounds.width  / 1.2, height: 2)
                        .padding(.leading, 25)
                        .padding(.trailing, 40)
                    
                    Text(petNameError)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.red)
                        .frame(width: UIScreen.main.bounds.width, height: 16, alignment: .center)
                        .padding(.top, 10)
                    
                    
                }.padding(.bottom, 20)
                
                HStack {
                    Text("גזע")
                        .font(.system(size: 20, weight: .regular))
                        .foregroundColor(Color("offBlack"))
                        .padding(.leading, 25)
                        .padding(.bottom, 5)
                    
                    Spacer()
                    
                    Text("גיל")
                        .font(.system(size: 20, weight: .regular))
                        .foregroundColor(Color("offBlack"))
                        .padding(.trailing, UIScreen.main.bounds.width  / 3.8)
                        .padding(.bottom, 5)
                    
                }
                
                ZStack {
                    
                    HStack {
                        TextField("הקלידו את הגזע כאן", text: $petRace, onEditingChanged: { (editingChanged) in
                            if editingChanged {
                                print("TextField focused")
                            } else {
                                if self.petRace.isEmpty == false {
                                    self.correctTextField = .correct
                                    if self.petRace.count <= 20 {
                                        self.petRaceError =  ""
                                    }
                                } else {
                                    self.correctTextField = .empty
                                }
                            }
                        })
                            .onReceive(Just(petRace)) { newValue in
                                let filtered = self.petRace.filter { self.allowedChars.contains($0) }
                                if filtered != self.petRace {
                                    self.petRace = filtered
                                }
                        }
                        .onReceive(petRace.publisher.collect()) {
                            if self.petRace.count > 20 {
                                self.petRaceError =  "גזע ה\(self.petType) ארוך מדיי "
                            }
                            self.petRace = String($0.prefix(20))
                        }
                        .padding(.leading, 25)
                        .padding(.bottom, 25)
                        .frame(width: UIScreen.main.bounds.width  / 2 , height: 50)
                        Spacer()
                        TextField("הקלידו גיל", text: $petAge, onEditingChanged: { (editingChanged) in
                            if editingChanged {
                                print("TextField focused")
                            } else {
                                if self.petAge.isEmpty == false {
                                    self.correctTextField = .correct
                                    if self.petAge.count <= 2 {
                                        self.petAgeError =  ""
                                    }
                                } else {
                                    self.correctTextField = .empty
                                }
                            }
                        })
                            .onReceive(Just(petAge)) { newValue in
                                let filtered = self.petAge.filter { "0123456789".contains($0) }
                                if filtered != self.petAge {
                                    self.petAge = filtered
                                }
                        }
                        .onReceive(petAge.publisher.collect()) {
                            if self.petAge.count > 2 {
                                self.petAgeError =  "רק 2 ספרות"
                            }
                            self.petAge = String($0.prefix(2))
                        }
                            
                        .frame(width: UIScreen.main.bounds.width  / 3.8, height: 0.5)
                        .keyboardType(.numberPad)
                        .padding(.bottom, 25)
                        .padding(.trailing, 20)
                    }
                    
                    HStack {
                        Rectangle().background(Color.black).frame(width: UIScreen.main.bounds.width  / 2, height: 0.5).padding(.leading, 25)
                        Spacer()
                        Rectangle().background(Color.black).frame(width: UIScreen.main.bounds.width  / 3.8, height: 0.5).padding(.trailing, 30)
                    }
                    
                    HStack {
                        Text(petRaceError)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.red)
                            .frame(width: UIScreen.main.bounds.width  / 2, height: 0.5)
                            .padding(.leading, 25)
                            .padding(.top, 15)
                        
                        
                        Spacer()
                        
                        Text(petAgeError)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.red)
                            .frame(width: UIScreen.main.bounds.width  / 3.8, height: 0.5)
                            .padding(.trailing, 30)
                            .padding(.top, 15)
                    }
                }
                
                HStack {
                    Text("מלל חופשי")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(Color("offBlack"))
                        .padding(.leading, 25)
                        .padding(.bottom, 30)
                    Spacer()
                }
                
                HStack {
                    
//                    TextField("הקלידו פה הערות/תאור/פרטים נוספים", text: $description)
                       
                       MultilineTextField(text: $description)
                         .frame(width: UIScreen.main.bounds.width - 40, height: 200, alignment: .topLeading)
                                      .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.gray))
                    
                }.padding(20)
            }
            
            
            
        }.frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height, alignment: .topLeading).edgesIgnoringSafeArea(.bottom)
            .background(Color("offWhite").frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height + (UIDevice.current.systemVersion != "14.0" ? 20 : 0), alignment: .top).edgesIgnoringSafeArea(.bottom))
            .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                ImagePicker(image: self.$inputImage)
        }
        .offset(y: -self.value)
        .animation(.spring())
        .onAppear {
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { (noti) in
                let value = noti.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
                let height = value.height
                
                self.value = height
            }
            
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { (noti) in
                
                self.value = 0
            }
        }
    }
    
    func closeLoginScreen() {
        
        UIApplication.shared.endEditing()
        
        withAnimation {
            showAuthScreen = false
        }
    }
    
    func signOut() {
        session.signOut()
        showPostPet = false
    }
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        
        switch chosenImage {
        case .first:
            image = Image(uiImage: inputImage)
            
        case .second:
            secondImage = Image(uiImage: inputImage)
            
        case .third:
            thirdImage = Image(uiImage: inputImage)
            
        case .fourth:
            fourthImage = Image(uiImage: inputImage)
        }
    }
}


struct MultilineTextField: View {

    private var placeholder: String
    private var onCommit: (() -> Void)?
    @State private var viewHeight: CGFloat = 40 //start with one line
    @State private var shouldShowPlaceholder = false
    @Binding private var text: String
    
    private var internalText: Binding<String> {
        Binding<String>(get: { self.text } ) {
            self.text = $0
            self.shouldShowPlaceholder = $0.isEmpty
        }
    }

    var body: some View {
        UITextViewWrapper(text: self.internalText, calculatedHeight: $viewHeight, onDone: onCommit)
            .frame(minHeight: viewHeight, maxHeight: viewHeight)
            .background(placeholderView, alignment: .topLeading)
    }

    var placeholderView: some View {
        Group {
            if shouldShowPlaceholder {
                Text(placeholder).foregroundColor(.gray)
                    .padding(.leading, 4)
                    .padding(.top, 8)
            }
        }
    }
    
    init (_ placeholder: String = "", text: Binding<String>, onCommit: (() -> Void)? = nil) {
        self.placeholder = placeholder
        self.onCommit = onCommit
        self._text = text
        self._shouldShowPlaceholder = State<Bool>(initialValue: self.text.isEmpty)
    }

}


private struct UITextViewWrapper: UIViewRepresentable {
    typealias UIViewType = UITextView

    @Binding var text: String
    @Binding var calculatedHeight: CGFloat
    var onDone: (() -> Void)?

    func makeUIView(context: UIViewRepresentableContext<UITextViewWrapper>) -> UITextView {
        let textField = UITextView()
        textField.delegate = context.coordinator

        textField.isEditable = true
        textField.font = UIFont.preferredFont(forTextStyle: .body)
        textField.isSelectable = true
        textField.isUserInteractionEnabled = true
        textField.isScrollEnabled = false
        textField.backgroundColor = UIColor.clear
        if nil != onDone {
            textField.returnKeyType = .done
        }

        textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return textField
    }

    func updateUIView(_ uiView: UITextView, context: UIViewRepresentableContext<UITextViewWrapper>) {
        if uiView.text != self.text {
            uiView.text = self.text
        }
        if uiView.window != nil, !uiView.isFirstResponder {
            uiView.becomeFirstResponder()
        }
        UITextViewWrapper.recalculateHeight(view: uiView, result: $calculatedHeight)
    }

    private static func recalculateHeight(view: UIView, result: Binding<CGFloat>) {
        let newSize = view.sizeThatFits(CGSize(width: view.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
        if result.wrappedValue != newSize.height {
            DispatchQueue.main.async {
                result.wrappedValue = newSize.height // call in next render cycle.
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text, height: $calculatedHeight, onDone: onDone)
    }

    final class Coordinator: NSObject, UITextViewDelegate {
        var text: Binding<String>
        var calculatedHeight: Binding<CGFloat>
        var onDone: (() -> Void)?

        init(text: Binding<String>, height: Binding<CGFloat>, onDone: (() -> Void)? = nil) {
            self.text = text
            self.calculatedHeight = height
            self.onDone = onDone
        }

        func textViewDidChange(_ uiView: UITextView) {
            text.wrappedValue = uiView.text
            UITextViewWrapper.recalculateHeight(view: uiView, result: calculatedHeight)
        }

        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            if let onDone = self.onDone, text == "\n" {
                textView.resignFirstResponder()
                onDone()
                return false
            }
            return true
        }
    }

}
