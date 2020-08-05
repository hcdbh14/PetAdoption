import SwiftUI
import Combine

enum ActiveSheet {
    case images, cities
}

enum Suitablefor {
    
    case kids
    case houseYard
    case apartment
    case adults
    case houseWithCat
    case allergic
}

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
    @State var gender = 0
    @State var size = 0
    @State private var activeSheet: ActiveSheet = .images
    @State var city = "בחרו עיר מגורים"
    @State var showSheet = false
    @State var phoneNumber = ""
    @State var phoneNumberError = ""
    @State var SuiteableArray: [Int] = []
    @State var description = ""
    @State var chosenImage = ChosenImage.first
    private let allowedChars = Set("abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLKMNOPQRSTUVWXYZ אבגדהוזחטיכךלמםנןסעפףצץקרשת")
    @State var value : CGFloat = 0
    @State private var petType = 0
    @State private var correctTextField = TextFieldCorrection.empty
    @State private var petAge = ""
    @State private var petAgeError = ""
    @State private var petRace = ""
    @State private var petRaceError = ""
    @State private var petName = ""
    @State private var petNameError = ""
    @State private var image: UIImage?
    @State private var secondImage: UIImage?
    @State private var thirdImage: UIImage?
    @State private var fourthImage: UIImage?
    @State var triggerFade = true
    @Binding var showPostPet: Bool
    @Binding var showAuthScreen: Bool
    @State private var inputImage: UIImage?
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
                    self.activeSheet = .images
                    self.showSheet = true
                }
                Spacer()
            }
            
            HStack {
                Spacer()
                imagePlacerHolder(image: $secondImage).onTapGesture {
                    self.chosenImage = .second
                    self.activeSheet = .images
                    self.showSheet = true
                }
                imagePlacerHolder(image: $thirdImage).onTapGesture {
                    self.chosenImage = .third
                    self.activeSheet = .images
                    self.showSheet = true
                }
                imagePlacerHolder(image: $fourthImage).onTapGesture {
                    self.chosenImage = .fourth
                    self.activeSheet = .images
                    self.showSheet = true
                }
                Spacer()
            }.padding(.bottom, 25)
            
            VStack {
                HStack {
                    
                    Text("איזה חיית מחמד?")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(Color("offBlack"))
                        .padding(.leading, 25)
                        .padding(.bottom, 5)
                    Spacer()
                }.padding(.top, 25)
            }
            
            VStack {
                HStack {
                    Spacer()
                    SegmentedPicker(items: ["כלב", "חתול", "אחר"], selection: $petType)
                    Spacer()
                }.padding(.bottom, 25)
                
                
                
                HStack {
                    Text("פרטי ה\(returnPetType())")
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
                                self.petNameError =  "שם ה\(self.returnPetType()) ארוך מדיי "
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
                                self.petRaceError =  "גזע ה\(self.returnPetType()) ארוך מדיי "
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
            }
            HStack {
                Text("מתאים ל-")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(Color("offBlack"))
                    .padding(.leading, 25)
                    .padding(.top, 30)
                Spacer()
            }
            
            VStack {
                VStack {
                    HStack {
                        CheckboxField(id: 0, label: "ילדים", size: 16, color: .gray, textSize: 20, marked: SuiteableArray.contains(0),onLightBackground: true ,callback: checkboxSelected)
                        CheckboxField(id: 1, label: "מבוגרים", size: 16, color: .gray, textSize: 20, marked: SuiteableArray.contains(1),onLightBackground: true , callback: checkboxSelected)
                        CheckboxField(id: 2, label: "אלרגיים", size: 16, color: .gray, textSize: 20, marked: SuiteableArray.contains(2),onLightBackground: true , callback: checkboxSelected)
                    }.padding(.leading, 15)
                    
                    HStack {
                        CheckboxField(id: 3, label: "לדירה", size: 16, color: .gray, textSize: 20, marked: SuiteableArray.contains(3),onLightBackground: true , callback: checkboxSelected)
                        CheckboxField(id: 4, label: "בית עם חצר", size: 16, color: .gray, textSize: 20, marked: SuiteableArray.contains(4),onLightBackground: true , callback: checkboxSelected)
                        CheckboxField(id: 5, label: "בית עם חתול", size: 16, color: .gray, textSize: 20, marked: SuiteableArray.contains(5),onLightBackground: true , callback: checkboxSelected)
                    }.padding(.leading, 15)
                }
                
                
                HStack {
                    Text("מין")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(Color("offBlack"))
                        .padding(.leading, 25)
                        .padding(.top, 30)
                    Spacer()
                }
                
                HStack {
                    Spacer()
                    SegmentedPicker(items: ["זכר", "נקבה"], selection: $gender)
                    Spacer()
                }.padding(.bottom, 25)
                
                
                HStack {
                    Text("גודל")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(Color("offBlack"))
                        .padding(.leading, 25)
                        .padding(.top, 30)
                    Spacer()
                }
                
                HStack {
                    Spacer()
                    SegmentedPicker(items: ["קטן", "בינוני", "גדול"], selection: $size)
                    Spacer()
                }.padding(.bottom, 25)
                
                HStack {
                    Text("מלל חופשי")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(Color("offBlack"))
                        .padding(.leading, 25)
                        .padding(.top, 30)
                    Spacer()
                }
                
                HStack {
                    
                    MultiLineTF(txt: $description)
                        .frame(width: UIScreen.main.bounds.width - 40, height: 200, alignment: .topLeading)
                        .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.gray))
                        .environment(\.layoutDirection, .rightToLeft)
                    
                }.padding(20)
                
                VStack {
                    HStack {
                        Text("פרטים ליצירת קשר")
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundColor(Color("offBlack"))
                            .padding(.leading, 25)
                            .padding(.top, 30)
                            .padding(.bottom, 30)
                        Spacer()
                    }
                    
                    HStack {
                        Text("מספר טלפון")
                            .font(.system(size: 20, weight: .regular))
                            .foregroundColor(Color("offBlack"))
                            .padding(.leading, 25)
                            .padding(.bottom, 5)
                        Spacer()
                    }
                    
                    ZStack {
                        HStack {
                            TextField("הקלידו מספר טלפון", text: $phoneNumber, onEditingChanged: { (editingChanged) in
                                if editingChanged {
                                    print("TextField focused")
                                } else {
                                    if self.phoneNumber.isEmpty == false {
                                        self.correctTextField = .correct
                                        if self.phoneNumber.count <= 10 {
                                            self.phoneNumberError =  ""
                                        }
                                    } else {
                                        self.correctTextField = .empty
                                    }
                                }
                            })
                                .onReceive(Just(phoneNumber)) { newValue in
                                    let filtered = self.phoneNumber.filter { "0123456789".contains($0) }
                                    if filtered != self.phoneNumber {
                                        self.phoneNumber = filtered
                                    }
                            }
                            .onReceive(phoneNumber.publisher.collect()) {
                                if self.phoneNumber.count > 10 {
                                    self.phoneNumberError = "מספר טלפון ארוך מדיי"
                                }
                                self.phoneNumber = String($0.prefix(10))
                            }
                                
                            .frame(width: UIScreen.main.bounds.width - 70 , height: 50)
                            .keyboardType(.numberPad)
                            .padding(.bottom, 25)
                            .padding(.leading, 25)
                            Spacer()
                        }
                        
                        Divider().background(Color.black).frame(width: UIScreen.main.bounds.width  / 1.2, height: 2)
                            .padding(.leading, 25)
                            .padding(.trailing, 40)
                        
                        HStack {
                            Text(phoneNumberError)
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.red)
                                .frame(width: UIScreen.main.bounds.width  / 2, height: 0.5)
                                .padding(.leading, 25)
                                .padding(.top, 15)
                            Spacer()
                        }
                    }.padding(.bottom, 20)
                }
                
                HStack {
                    Text("עיר מגורים")
                        .font(.system(size: 20, weight: .regular))
                        .foregroundColor(Color("offBlack"))
                        .padding(.leading, 25)
                        .padding(.bottom, 25)
                    Spacer()
                }
                
                Button(action: openCitiesSheet) {
                    VStack {
                        HStack {
                            Text(city)
                                .foregroundColor(city == "בחרו עיר מגורים" ? .gray : .black)
                                .padding(.leading, 25)
                            Spacer()
                        }
                        Divider().background(Color.black).frame(width: UIScreen.main.bounds.width  / 1.2, height: 2)
                            .padding(.leading, 25)
                            .padding(.trailing, 40)
                            .padding(.top, -10)
                    }
                }
            }.padding(.bottom, 25)
            
            Button(action: postImage) {
                //                if waitingForResponse {
                //
                //                    ActivityIndicator(isAnimating: true)
                //                        .configure { $0.color = .white }
                //                } else {
                Text("פרסום מודעה")
                    .frame(width: UIScreen.main.bounds.width - 100, height: 50)
                    .foregroundColor(.white)
                    .background(Color("orange"))
                    .cornerRadius(30)
                    .shadow(radius: 5)
                //                }
            }.frame(width: UIScreen.main.bounds.width - 100, height: 50)
                .foregroundColor(.white)
                .background(Color("orange"))
                .cornerRadius(30)
                .shadow(radius: 5)
                .padding(15)
            
        }.frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height, alignment: .topLeading).edgesIgnoringSafeArea(.bottom)
            .background(Color("offWhite").frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height + (UIDevice.current.systemVersion != "14.0" ? 20 : 0), alignment: .top).edgesIgnoringSafeArea(.bottom))
            .sheet(isPresented: $showSheet, onDismiss: loadImage) {
                if self.activeSheet == .images {
                    ImagePicker(image: self.$inputImage)
                } else {
                    Cities(showCities: self.$showSheet, city: self.$city)
                }
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
    
    func postImage() {
        let images = [image, secondImage, thirdImage, fourthImage]
        
        for i in images {
            if i != nil {
                var data = Data()
                data = (i ?? UIImage()).jpeg(.lowest) ?? Data()
                session.postPetImages(imageData: data)
            }
        }
    }
    
    func openCitiesSheet() {
        self.activeSheet = .cities
        showSheet = true
    }
    
    func checkboxSelected(id: Int) {
        if SuiteableArray.contains(id) == false {
            SuiteableArray.append(id)
        } else {
            if let itemToRemove = SuiteableArray.firstIndex(of: id) {
                SuiteableArray.remove(at: itemToRemove)
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
        if activeSheet == .cities { return }
        guard let inputImage = inputImage else { return }
        
        switch chosenImage {
        case .first:
            image = inputImage
            
        case .second:
            secondImage = inputImage
            
        case .third:
            thirdImage = inputImage
            
        case .fourth:
            fourthImage = inputImage
        }
    }
    
    func returnPetType()  -> String {
        
        switch petType {
        case 0:
            return "כלב"
        case 1:
            return "חתול"
        case 2:
            return "חיית מחמד"
        default:
            return "חיית מחמד"
        }
    }
}



