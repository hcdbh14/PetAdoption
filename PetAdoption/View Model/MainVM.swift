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
    
    var dogsList: [Dog] = []
    private var firstLaunch = false
    private var sub: AnyCancellable?
    private var backSub: AnyCancellable?
    private var imageLoader: ImageLoader?
    private let db = Firestore.firestore()
    private var backImageLoader: ImageLoader?
    @Published var count = 1
    @Published var localDB = LocalDB()
    @Published var backImageLoaded = false
    @Published var frontImages: [Data] = []
    @Published var backImages: [Data] = []
    @Published var frontImage: [String] = []
    @Published var userDecided = PassthroughSubject<Decision, Never>()
    @Published var decision: Decision = Decision.notDecided { didSet {
        userDecided.send(decision)
        }
    }
    
    init() {
        getDogsFromDB()
        print("initalized")
    }
    
    
    func pushNewImage() {
        
        if dogsList.hasValueAt(index: count) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.count += 1
                self.frontImages = self.backImages
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                    self.backImageLoaded = false
                }
                self.loadImages()
            }
            
        } else {
            frontImages = []
            backImages = []
        }
    }
    
    
    func getDogsFromDB() {
        
        db.collection("Cards_Data").getDocuments( completion: { (snapshot, error) in
            
            if error == nil {
                for document in snapshot!.documents {
                    for i in document.data() {
                        
                        if let dog = Dog(data: i.value as! [String : Any]) {
                            self.dogsList.append(dog)
                        }
                    }
                }
                self.loadImages()
            }
        })
    }
    
    
    func loadImages() {
        
        let allImages = dogsList[count - 1].images.count
        if frontImages.isEmpty  || frontImages.count != allImages {
            
            imageLoader = ImageLoader(urlString: dogsList[count - 1].images)
            sub = imageLoader?.didChange.sink(receiveValue: { value in
                self.frontImages = value
            })
        }
        
        if dogsList.hasValueAt(index: count) {
            backImageLoader = ImageLoader(urlString: dogsList[count].images)
            backSub = backImageLoader?.didChange.sink(receiveValue: { value in
                if self.frontImages.isEmpty == false {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                        self.backImages = value
                        self.backImageLoaded = true
                    }
                } else {
                    self.backImages = value
                }
            })
        }
    }
}


