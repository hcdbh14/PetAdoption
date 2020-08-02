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
                    
                    MultiLineTF(txt: $description)
                        .frame(width: UIScreen.main.bounds.width - 40, height: 200, alignment: .topLeading)
                        .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.gray))
                        .environment(\.layoutDirection, .rightToLeft)
                    
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
        tview.font = .systemFont(ofSize: 20)
        tview.delegate = context.coordinator
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
