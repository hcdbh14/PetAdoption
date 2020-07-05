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
    private let db = Firestore.firestore()
    private var sub: AnyCancellable?
    private var backSub: AnyCancellable?
    @Published var frontImages: [Data] = []
    @Published var backImages: [Data] = []
    private var imageLoader: ImageLoader?
    private var backImageLoader: ImageLoader?
    @Published var localDB = LocalDB()
    @Published var count = 1
    @Published var frontImage: [String] = []
    @Published var imageURLS: [Int: [String]] = [:]
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
                self.loadImages()
            }
        } else {
            print(backImages)
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
                //                self.getImageURLS()
                self.loadImages()
            }
        })
    }
    
    
    func getImageURLS() {
        
        for (index, dog) in dogsList.enumerated() {
            
            for path in dog.images {
                
                let storage = Storage.storage().reference(withPath: path)
                storage.downloadURL { (url, error) in
                    if error != nil {
                        print((error?.localizedDescription)!)
                        return
                    }
                    
                    if self.imageURLS[index] == nil {
                        self.imageURLS[index] = ["\(url!)"]
                    } else {
                        if self.dogsList[0].images.count ==  self.imageURLS[0]?.count &&  self.firstLaunch == false {
                            self.frontImage = self.imageURLS.removeValue(forKey: 0) ?? []
                            self.firstLaunch = true
                        }
                        print(url!)
                        self.imageURLS[index]?.append("\(url!)")
                    }
                }
            }
        }
        
    }
    
    func loadImages() {
        
        if frontImages.isEmpty {
            imageLoader = ImageLoader(urlString: dogsList[count - 1].images)
            sub = imageLoader?.didChange.sink(receiveValue: { value in
                self.frontImages = value
                print(value)
            })
        }
        
        if dogsList.hasValueAt(index: count) {
            backImageLoader = ImageLoader(urlString: dogsList[count].images)
            backSub = backImageLoader?.didChange.sink(receiveValue: { value in
                if self.frontImages.isEmpty == false {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                        self.backImages = value
                    }
                } else {
                    self.backImages = value
                }
            })
        }
    }
}


