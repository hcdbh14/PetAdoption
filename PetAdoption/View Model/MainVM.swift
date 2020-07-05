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
        let removed = imageURLS.removeValue(forKey: count)
        frontImage = removed ?? []
        count += 1
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
//                        print(url)
                        self.imageURLS[index]?.append("\(url!)")
                    }
                }
            }
        }
        
    }
    
    func loadImages() {
        print(dogsList[count - 1].name)
       imageLoader = ImageLoader(urlString: dogsList[count - 1].images)
//       backImageLoader = ImageLoader(urlString: dogsList[count].images)
        
        sub = imageLoader?.didChange.sink(receiveValue: { value in
            self.frontImages = value
            print(value)
        })
        
        backSub = backImageLoader?.didChange.sink(receiveValue: { value in
            self.backImages.append(contentsOf: value)
        })
    }
}


