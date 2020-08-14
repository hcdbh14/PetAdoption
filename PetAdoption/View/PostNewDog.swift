import SwiftUI
import Combine

struct PostNewDog: View {
    
    private enum ActiveSheet {
        case images, cities
    }
    
    private enum Suitablefor: String {
        
        case kids = "ילדים"
        case houseYard = "בית עם חצר"
        case apartment = "דירה"
        case adults = "מבוגרים"
        case houseWithCat = "בית עם חתול"
        case allergic = "אלרגיים"
    }
    
    private enum TextFieldCorrection {
        
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
    @State private var poopTrained = 0
    @State private var vaccinated = 0
    @State private var showAlert = false
    @State private var size = 0
    @State private var gender = 0
    @State private var petType = 0
    @State private var petAge = ""
    @State private var petRace = ""
    @State private var petName = ""
    @State private var error = false
    @State private var goodWords = ""
    @State private var petAgeError = ""
    @State private var phoneNumber = ""
    @State private var description = ""
    @State private var petRaceError = ""
    @State private var petNameError = ""
    @State private var goodWordsError = ""
    @State private var showSheet = false
    @State private var value : CGFloat = 0
    @State private var triggerFade = true
    @Binding private var showPostPet: Bool
    @State private var image: UIImage?
    @State private var secondImage: UIImage?
    @State private var thirdImage: UIImage?
    @State private var fourthImage: UIImage?
    @State private var inputImage: UIImage?
    @State private var phoneNumberError = ""
    @State private var city = "בחרו עיר מגורים"
    @Binding private var showAuthScreen: Bool
    @State private var suiteableArray: [Int] = []
    @State private var chosenImage = ChosenImage.first
    @EnvironmentObject private var session: SessionStore
    @State private var activeSheet: ActiveSheet = .images
    @State private var correctTextField = TextFieldCorrection.empty
    @Environment (\.colorScheme) private var colorScheme: ColorScheme
    private let allowedChars = Set("-’',abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLKMNOPQRSTUVWXYZ ׳אבגדהוזחטיכךלמםנןסעפףצץקרשת")
    
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
                    if self.image == nil {
                        self.activeSheet = .images
                        self.showSheet = true
                    } else {
                        self.showAlert = true
                    }
                }
                Spacer()
            }
            
            HStack {
                Spacer()
                imagePlacerHolder(image: $secondImage).onTapGesture {
                    self.chosenImage = .second
                    if self.secondImage == nil {
                        self.activeSheet = .images
                        self.showSheet = true
                    } else {
                        self.showAlert = true
                    }
                    
                }
                imagePlacerHolder(image: $thirdImage).onTapGesture {
                    self.chosenImage = .third
                    
                    if self.thirdImage == nil {
                        self.activeSheet = .images
                        self.showSheet = true
                    } else {
                        self.showAlert = true
                    }
                    
                }
                imagePlacerHolder(image: $fourthImage).onTapGesture {
                    
                    self.chosenImage = .fourth
                    if self.fourthImage == nil {
                        self.activeSheet = .images
                        self.showSheet = true
                    } else {
                        self.showAlert = true
                    }
                    
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
                            let filtered = self.petAge.filter { ".0123456789".contains($0) }
                            if filtered != self.petAge {
                                self.petAge = filtered
                            }
                        }
                        .onReceive(petAge.publisher.collect()) {
                            
                            let numOnly = self.petAge.replacingOccurrences(of: ".", with: "")
                            if numOnly.count > 2 || self.petAge.filter({ $0 == "." }).count > 1 {
                                self.petAgeError =  "רק 2 ספרות"
                                self.petAge = String($0.prefix(2))
                            }
                        }
                        
                        .frame(width: UIScreen.main.bounds.width  / 3.8, height: 0.5)
                        .keyboardType(.decimalPad)
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
                    Text(" מילים טובות על ה\(returnPetType())")
                        .font(.system(size: 20, weight: .regular))
                        .foregroundColor(Color("offBlack"))
                        .padding(.leading, 25)
                        .padding(.bottom, 5)
                    
                    Spacer()
                }.padding(.top, 20)
                
                ZStack {
                    HStack {
                        TextField("אופי ותכונות טובות של ה\(returnPetType())", text: $goodWords, onEditingChanged: { (editingChanged) in
                            if editingChanged {
                                print("TextField focused")
                            } else {
                                if self.goodWords.isEmpty == false {
                                    self.correctTextField = .correct
                                    
                                } else {
                                    self.correctTextField = .empty
                                }
                            }
                        })
                        .onReceive(Just(goodWords)) { newValue in
                            let filtered = self.goodWords.filter { self.allowedChars.contains($0) }
                            if filtered != self.goodWords {
                                self.goodWords = filtered
                            }
                        }
                        .onReceive(goodWords.publisher.collect()) {
                            if self.goodWords.count > 30 {
                                self.goodWordsError = "ניתן לרשום רק 30 תווים"
                            }
                            self.goodWords = String($0.prefix(30))
                        }
                        .padding(.leading, 30)
                        .padding(.bottom, 25)
                        .frame(width: UIScreen.main.bounds.width - 70 , height: 50)
                        Spacer()
                    }
                    
                    Divider().background(Color.black).frame(width: UIScreen.main.bounds.width  / 1.2, height: 2)
                        .padding(.leading, 25)
                        .padding(.trailing, 40)
                    
                    Text(goodWordsError)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.red)
                        .frame(width: UIScreen.main.bounds.width, height: 16, alignment: .center)
                        .padding(.top, 20)
                    
                    
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
                        CheckboxField(id: 0, label: Suitablefor.kids.rawValue, size: 16, color: .gray, textSize: 20, onLightBackground: true ,callback: checkboxSelected, array: $suiteableArray)
                        CheckboxField(id: 1, label: Suitablefor.adults.rawValue, size: 16, color: .gray, textSize: 20,onLightBackground: true , callback: checkboxSelected, array: $suiteableArray)
                        CheckboxField(id: 2, label: Suitablefor.allergic.rawValue, size: 16, color: .gray, textSize: 20, onLightBackground: true , callback: checkboxSelected, array: $suiteableArray)
                    }.padding(.leading, 15)
                    
                    HStack {
                        CheckboxField(id: 3, label: Suitablefor.apartment.rawValue, size: 16, color: .gray, textSize: 20, onLightBackground: true , callback: checkboxSelected, array: $suiteableArray)
                        CheckboxField(id: 4, label: Suitablefor.houseYard.rawValue, size: 16, color: .gray, textSize: 20, onLightBackground: true , callback: checkboxSelected, array: $suiteableArray)
                        CheckboxField(id: 5, label: Suitablefor.houseWithCat.rawValue, size: 16, color: .gray, textSize: 20, onLightBackground: true , callback: checkboxSelected, array: $suiteableArray)
                    }.padding(.leading, 15)
                }
                
                VStack {
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
                        Text("מחוסן")
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundColor(Color("offBlack"))
                            .padding(.leading, 25)
                            .padding(.top, 30)
                        Spacer()
                    }
                    
                    HStack {
                        Spacer()
                        SegmentedPicker(items: ["לא", "כן"], selection: $vaccinated)
                        Spacer()
                    }.padding(.bottom, 25)
                    
                    HStack {
                        Text((gender == 0 ?  "מחונכת" : "מחונך") + " לצרכים" )
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundColor(Color("offBlack"))
                            .padding(.leading, 25)
                            .padding(.top, 30)
                        Spacer()
                    }
                    
                    HStack {
                        Spacer()
                        SegmentedPicker(items: ["לא", "כן"], selection: $poopTrained)
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
                            // bug work around for iOS 14
                            .padding(.top,activeSheet == .cities ? -10 : -10)
                    }
                }
            }.padding(.bottom, 25)
            
            HStack {
                Spacer()
                Text(session.informText)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(error ? .red : .green)
                Spacer()
            }.padding(.top, 15)
            
            Button(action: postPetDetails) {
                if session.waitingForResponse {
                    
                    ActivityIndicator(isAnimating: true)
                        .configure { $0.color = .white }
                } else {
                    Text(session.actionText)
                        .frame(width: UIScreen.main.bounds.width - 100, height: 50)
                        .foregroundColor(.white)
                        .background(Color("orange"))
                        .cornerRadius(30)
                        .shadow(radius: 5)
                }
            }.frame(width: UIScreen.main.bounds.width - 100, height: 50)
            .foregroundColor(.white)
            .background(Color("orange"))
            .cornerRadius(30)
            .disabled(session.waitingForResponse)
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
            DispatchQueue.global().async {
                DispatchQueue.global().async {
                    self.session.getExistingPost()
                }
            }
            
        }
        .onReceive(session.existingPost.dataArivved, perform:  { answer in
            let petDetails = self.session.existingPost.dog
            self.petName = petDetails?.name ?? ""
            self.petRace = petDetails?.race ?? ""
            self.petAge = petDetails?.age ?? ""
            self.description = petDetails?.desc ?? ""
            self.phoneNumber = petDetails?.number ?? ""
            self.city = petDetails?.city ?? ""
            self.goodWords = petDetails?.goodWords ?? ""
            self.translateTypeIntoCode(petDetails?.type ?? "")
            self.translateGenderIntoCode(petDetails?.gender ?? "")
            self.translateSizeIntoCode(petDetails?.size ?? "")
            self.translateVaccinatedIntoCode(petDetails?.vaccinated ?? "")
            self.translatePoopTrainedntoCode(petDetails?.poopTrained ?? "")
            self.translateSuiteablesIntoCodes(petDetails?.suitables ?? "")
            self.session.actionText = "עדכון"
        })
        .onReceive(session.existingPost.loadImage, perform:  { imageIndex in
            switch imageIndex {
            case 0:
                self.image = UIImage(data: self.session.existingPost.imageData[0])
            case 1:
                self.secondImage = UIImage(data: self.session.existingPost.imageData[1])
            case 2:
                self.thirdImage = UIImage(data: self.session.existingPost.imageData[2])
            case 3:
                self.fourthImage = UIImage(data: self.session.existingPost.imageData[3])
            default:
                return
            }
            
        })
        .alert(isPresented:$showAlert) {
            Alert(title: Text("האם להסיר את תמונה זו?"), primaryButton: .destructive(Text("מחיקה")) {
                self.removeImage()
            }, secondaryButton: .cancel(Text("ביטול")))
        }
    }
    
    
    private func postPetDetails() {
        
        session.informText = ""
        error = false
        
        if image != nil && petName != "" && petRace != "" && petAge != "" && phoneNumber != "" && city != "" && goodWords != "" {
            self.session.localDB.existingPostID = ""
            let images = [image, secondImage, thirdImage, fourthImage]
            var imagesData: [Data] = []
            for i in images {
                if i != nil {
                    var data = Data()
                    data = (i ?? UIImage()).jpeg(.lowest) ?? Data()
                    imagesData.append(data)
                    
                }
            }
            session.postPetImages(imagesData: imagesData, petType: String(petType), petName: petName, petRace: petRace, petAge: petAge, petSize: String(size), suitables: groupSuiteables(), petGender: String(gender), description: description.trim(), phoneNumber: phoneNumber, city: city, goodWords: goodWords, vaccinated: String(vaccinated), poopTrained: String(poopTrained))
        } else {
            error = true
            session.informText = "לא ניתן להשלים, קיימים שדות חסרים"
        }
    }
    
    
    private func translateSuiteablesIntoCodes(_ suiteables: String) {
        var tempArray: [Int] = []
        
        if suiteables.contains(Suitablefor.kids.rawValue) {
            tempArray.append(0)
        }
        if suiteables.contains(Suitablefor.adults.rawValue) {
            tempArray.append(1)
        }
        if suiteables.contains(Suitablefor.allergic.rawValue) {
            tempArray.append(2)
        }
        if suiteables.contains(Suitablefor.apartment.rawValue) {
            tempArray.append(3)
        }
        if suiteables.contains(Suitablefor.houseYard.rawValue) {
            tempArray.append(4)
        }
        if suiteables.contains(Suitablefor.houseWithCat.rawValue) {
            tempArray.append(5)
        }
        suiteableArray = tempArray
    }
    
    
    private func groupSuiteables() -> String {
        var suiteablesString = ""
        
        if suiteableArray.isEmpty == false {
            
            for i in suiteableArray {
                switch i {
                case 0:
                    suiteablesString += ", " + Suitablefor.kids.rawValue
                case 1:
                    suiteablesString += ", " + Suitablefor.adults.rawValue
                case 2:
                    suiteablesString += ", " + Suitablefor.allergic.rawValue
                case 3:
                    suiteablesString += ", " + Suitablefor.apartment.rawValue
                case 4:
                    suiteablesString += ", " + Suitablefor.houseYard.rawValue
                case 5:
                    suiteablesString += ", " + Suitablefor.houseWithCat.rawValue
                default:
                    return ""
                }
            }
            suiteablesString.remove(at: suiteablesString.startIndex)
        }
        return suiteablesString
    }
    
    private func translateVaccinatedIntoCode(_ id: String) {
        switch id {
        case "0":
            vaccinated = 0
        case "1":
            vaccinated = 1
        default:
            vaccinated = 0
        }
    }
    
    private func translatePoopTrainedntoCode(_ id: String) {
        switch id {
        case "0":
            poopTrained = 0
        case "1":
            poopTrained = 1
        default:
            poopTrained = 0
        }
    }
    
    private func translateSizeIntoCode(_ id: String) {
        switch id {
        case "0":
            size = 0
        case "1":
            size = 1
        case "2":
            size = 2
        default:
            size = 0
        }
    }
    
    
    private func translateGenderIntoCode(_ id: String) {
        switch id {
        case "0":
            gender = 0
        case "1":
            gender = 1
        default:
            gender = 0
        }
    }
    
    
    private func translateTypeIntoCode(_ id: String) {
        
        switch id {
        case "0":
            petType = 0
        case "1":
            petType = 1
        case "2":
            petType = 2
        default:
            petType = 0
        }
    }
    
    
    private func openCitiesSheet() {
        self.activeSheet = .cities
        showSheet = true
    }
    
    
    private func checkboxSelected(id: Int) {
        if suiteableArray.contains(id) == false {
            suiteableArray.append(id)
        } else {
            if let itemToRemove = suiteableArray.firstIndex(of: id) {
                suiteableArray.remove(at: itemToRemove)
            }
        }
    }
    
    
    private func closeLoginScreen() {
        
        UIApplication.shared.endEditing()
        
        withAnimation {
            showAuthScreen = false
        }
    }
    
    private func signOut() {
        session.signOut()
        showPostPet = false
    }
    
    private func loadImage() {
        
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
    
    private func returnPetType()  -> String {
        
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
    
    private func removeImage() {
        switch chosenImage {
        case .first:
            image = nil
        case .second:
            secondImage = nil
        case .third:
            thirdImage = nil
        case .fourth:
            fourthImage = nil
        }
    }
}


