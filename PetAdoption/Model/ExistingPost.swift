import Foundation
import Combine
import FirebaseStorage
import FirebaseFirestore

class ExistingPost: ObservableObject {
    
    var petID = ""
    private var count = 0
    var imageCounter = 0
    var didDownload = false
    @Published var pet: Pet?
    var imageData: [Data] = []
    private var sub: AnyCancellable?
    private var imageLoader: ImageLoader?
    private let db = Firestore.firestore()
    private var petLists: [Pet] = []
    @Published var loadImage = PassthroughSubject<Int, Never>()
    @Published var dataArivved = PassthroughSubject<Bool, Never>()
    
    func downloadPost(id: String) {
        if didDownload == false {
            
            let query: Query = db.collection("Cards_Data").whereField("userID", isEqualTo: id)
            query.getDocuments(completion: {  (snapshot, error) in
                
                
                for document in snapshot!.documents {
                    if let pet = Pet(data: document.data()) {
                        self.petLists.append(pet)
                        
                        if self.count == 0 {
                            self.pet = pet
                            self.petID = document.documentID
                            self.dataArivved.send(true)
                            print(snapshot as Any)
                            self.didDownload = true
                            self.imageLoader = ImageLoader(urlString: pet.images)
                            self.sub = self.imageLoader?.didChange.sink(receiveValue: { value in
                                
                                self.imageData.append(value[self.imageCounter])
                                self.loadImage.send(self.imageCounter)
                                self.imageCounter += 1
                                print(self.imageData)
                            })
                        }
                    }
                    self.count = self.count + 1
                }
            })
        }
    }
}
