import SwiftUI


enum TextFieldCorrection {
    
    case correct
    case needFixing
    case empty
}

struct PostNewDog: View {
    
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
            }.padding(.top, 40)
            
            
            
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
                    self.showingImagePicker = true
                }
                Spacer()
            }
            
            HStack {
                Spacer()
                imagePlacerHolder(image: $secondImage)
                imagePlacerHolder(image: $thirdImage)
                imagePlacerHolder(image: $fourthImage)
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
                                if petName.isEmpty == false {
                                    correctTextField = .correct
                                    if self.petName.count <= 24 {
                                        self.petNameError =  ""
                                    }
                                } else {
                                    correctTextField = .empty
                                }
                            }
                        })
                        .onReceive(petName.publisher.collect()) {
                            if self.petName.count > 24 {
                                self.petNameError =  "שם ה\(petType) ארוך מדיי "
                            }
                            self.petName = String($0.prefix(24))
                    }
                        .padding(.leading, 30)
                        .padding(.bottom, 25)
                        .frame(width: UIScreen.main.bounds.width - 70 , height: 50)
                        Spacer()
                    }
                    //                        .overlay(
                    //                            RoundedRectangle(cornerRadius: 5)
                    //                                .strokeBorder(
                    //                                    style: StrokeStyle(
                    //                                        lineWidth: 1
                    //                                    )
                    //                                )
                    //                                .foregroundColor(correctTextField == .correct ? .green : .gray))
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
                                if petRace.isEmpty == false {
                                    correctTextField = .correct
                                    if self.petRace.count <= 20 {
                                        self.petRaceError =  ""
                                    }
                                } else {
                                    correctTextField = .empty
                                }
                            }
                        })
                        .onReceive(petRace.publisher.collect()) {
                            if self.petRace.count > 20 {
                                self.petRaceError =  "גזע ה\(petType) ארוך מדיי "
                            }
                            self.petRace = String($0.prefix(20))
                    }
                            .padding(.leading, 25)
                            .padding(.bottom, 25)
                            .frame(width: UIScreen.main.bounds.width  / 2 , height: 50)
                        Spacer()
                        TextField("הקלידו גיל משוערך", text: $petAge).frame(width: UIScreen.main.bounds.width  / 3.8, height: 0.5)
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
            }
            
            
            
        }.frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height, alignment: .topLeading).edgesIgnoringSafeArea(.bottom)
        .background(Color("offWhite").frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height, alignment: .bottom).edgesIgnoringSafeArea(.bottom))
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
        image = Image(uiImage: inputImage)
    }
}



struct imagePlacerHolder: View {
    
    @Binding var image: Image?
    
    init(image: Binding<Image?>) {
        self._image = image
    }
    
    var body: some View {
        
        ZStack {
            if image == nil {
                Image(uiImage: UIImage())
                    .frame(width: UIScreen.main.bounds.width / 3.5 , height: 150)
                    .background(Color("offGray"))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .strokeBorder(
                                style: StrokeStyle(
                                    lineWidth: 2,
                                    dash: [15]
                                )
                            )
                            .foregroundColor(.gray)
                    )
                Image(systemName: "plus.circle").resizable()
                    .frame(width: 25, height: 25)
                    .foregroundColor(.gray)
            } else {
                image?.resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width / 3.5 , height: 150)
                    .background(Color.black)
                    .cornerRadius(10)
                    .fixedSize()
            }
        }
        
    }
}







struct ImagePicker: UIViewControllerRepresentable {
    
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as?
                UIImage {
                
                parent.image = UIImage(data: uiImage.jpeg(.lowest) ?? Data())
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
    
    @Environment(\.presentationMode) var presentationMode
    @Binding var image: UIImage?
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}





