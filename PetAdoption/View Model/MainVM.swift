import SwiftUI
import Combine
import FirebaseStorage
import FirebaseFirestore

enum Decision {
    case picked
    case rejected
    case notDecided
}

class MainVM: ObservableObject {
    
    var firstLaunch = false
    @Published var count = 1
    var petsList: [Pet] = []
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
        
        db.collection("Cards_Data").getDocuments( completion: { (snapshot, error) in
            
            if error == nil {
                for document in snapshot!.documents {
                    
                    if let pet = Pet(data: document.data()) {
                        self.petsList.append(pet)
                        
                    }
                }
                self.loadImages()
            }
        })
    }
    
    
    func loadImages() {
        
        let allImages = petsList[count - 1].images.count
        if frontImages.isEmpty  || frontImages.count != allImages {
            
            imageLoader = ImageLoader(urlString: petsList[count - 1].images)
            sub = imageLoader?.didChange.sink(receiveValue: { value in
                
                    self.frontImages = value
                    self.reloadFrontImage.send(true)
            })
        }
        
        if petsList.hasValueAt(index: count) {
            backImageLoader = ImageLoader(urlString: petsList[count].images)
            backSub = backImageLoader?.didChange.sink(receiveValue: { value in
                if self.frontImages.isEmpty == false {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                        self.backImages = value
                        self.reloadBackImage.send(true)
                    }
                } else {
                    self.backImages = value
                }
            })
        }
    }
}


