import SwiftUI
import Combine
import FirebaseStorage
import FirebaseFirestore

enum Decision {
    case picked
    case rejected
    case notDecided
}

class CardVM: ObservableObject {
    
    @Published var count = 1
    var petsList: [Pet] = []
    @Published var reload = false
    @Published  var imageIndex = 0
    private var sub: AnyCancellable?
    @Published var noMorePets = false
    @Published var localDB = LocalDB()
    private var backSub: AnyCancellable?
    private var imageLoader: ImageLoader?
    private let db = Firestore.firestore()
    @Published var backImages: [Data] = []
    @Published var frontImages: [Data] = []
    @Published var frontImage: [String] = []
    private var backImageLoader: ImageLoader?
    @Published var reloadBackImage = PassthroughSubject<Bool, Never>()
    @Published var userDecided = PassthroughSubject<Decision, Never>()
    @Published var reloadFrontImage = PassthroughSubject<Bool, Never>()
    @Published var decision: Decision = Decision.notDecided { didSet {
        userDecided.send(decision)
        }
    }
    
    init() {
        getPetsFromDB()
        print("initalized")
    }
    
    
    func pushNewImage() {
        withAnimation(.none) {
            if petsList.hasValueAt(index: count) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.count += 1
                    if self.frontImages.hasValueAt(index: 0) && self.backImages.hasValueAt(index: 0) {
                        if self.frontImages[0] != self.backImages[0] {
                            self.frontImages = self.backImages
                        } else {
                            self.frontImages = []
                            self.reloadFrontImage.send(false)
                        }
                    } else {
                        self.frontImages = []
                        self.reloadFrontImage.send(false)
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                        self.reloadBackImage.send(false)
                    }
                    self.loadImages()
                }
            } else {
                frontImages = []
                backImages = []
                noMorePets = true
            }
        }
    }
    
    
    func getPetsFromDB() {
        
        var tempArray: [Pet] = []
        
        dbQuery().getDocuments( completion: { (snapshot, error) in
            
            if error == nil {
                for document in snapshot!.documents {
                    
                    if let pet = Pet(data: document.data()) {
                        if self.reload {
                            tempArray.append(pet)
                        } else {
                            self.petsList.append(pet)
                        }
                    }
                }
                
                if self.reload {
                    self.count = 1
                    self.imageIndex = 0
                    self.frontImage = []
                    self.backImages = []
                    self.frontImages = []
                    self.petsList = tempArray
                    self.reloadBackImage.send(false)
                    self.reloadFrontImage.send(false)
                    self.noMorePets = false
                    self.reload = false
                }
                
                self.localFilter()
                
                self.loadImages()
            }
        })
    }
    
    
    func loadImages() {
        if petsList.hasValueAt(index: count - 1) {
            let allImages = petsList[count - 1].images.count
            if frontImages.isEmpty  || frontImages.count != allImages || frontImages.hasValueAt(index: 0) {
                
                imageLoader = ImageLoader(urlString: petsList[count - 1].images)
                sub = imageLoader?.didChange.sink(receiveValue: { value in
                    
                    self.frontImages = value
                    self.reloadFrontImage.send(true)
                })
            }
        }
        
        
            if petsList.hasValueAt(index: count) {
                backImageLoader = ImageLoader(urlString: petsList[count].images)
                backSub = backImageLoader?.didChange.sink(receiveValue: { value in
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                        self.backImages = value
                        self.reloadBackImage.send(true)
                        
                    }
                })
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    print("wrok")
                    self.reloadBackImage.send(false)
                }
            }
    }
    
    
    private func dbQuery() -> Query {
        
        var petsRef: Query = db.collection("Cards_Data")
        let searchBy = UserDefaults.standard.integer(forKey: "searchBy")
        if let regions: [Int] = UserDefaults.standard.array(forKey: "areas") as? [Int] {
            
            if (regions.contains(0) && regions.contains(1) && regions.contains(2)) == false {
                if regions.contains(0) {
                    petsRef = petsRef.whereField("region", isEqualTo: "0")
                } else if regions.contains(1) {
                    petsRef = petsRef.whereField("region", isEqualTo: "1")
                } else if regions.contains(2) {
                    petsRef = petsRef.whereField("region", isEqualTo: "2")
                }
            }
        }
        
        if searchBy == SearchBy.dog.rawValue {
            petsRef = petsRef.whereField("type", isEqualTo: "0")
        } else if searchBy == SearchBy.cat.rawValue {
            petsRef = petsRef.whereField("type", isEqualTo: "1")
        }
        
        return petsRef
    }
    
    
    private func localFilter() {
        let agesLocalDB: [Int]? = UserDefaults.standard.array(forKey: "ages") as? [Int]
        
        if let ages = agesLocalDB {
            if (ages.contains(3) && ages.contains(4) && ages.contains(5)) == false  {
                
                if ages.contains(3) && ages.contains(5) {
                    self.petsList = self.petsList.filter { $0.age <= 1 || $0.age >= 8 }
                } else if ages.contains(3) && ages.contains(4) {
                    self.petsList = self.petsList.filter { $0.age < 8 }
                } else if ages.contains(3) {
                    self.petsList = self.petsList.filter { $0.age <= 1 }
                }
                    
                else if ages.contains(4) && ages.contains(5) {
                    self.petsList = self.petsList.filter { $0.age > 1 }
                } else if ages.contains(4) {
                    self.petsList = self.petsList.filter { $0.age > 1 && $0.age < 8 }
                } else if ages.contains(5) {
                    self.petsList = self.petsList.filter { $0.age >= 8 }
                } else {
                    return
                }
            }
        }
    }
}


