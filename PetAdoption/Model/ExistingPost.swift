import Foundation
import Combine
import FirebaseStorage
import FirebaseFirestore

class ExistingPost: ObservableObject {
    
    var imageCounter = 0
    @Published var dog: Pet?
    var imageData: [Data] = []
    private var sub: AnyCancellable?
    private var imageLoader: ImageLoader?
    private let db = Firestore.firestore()
    private var finishedDownloading = false
    @Published var loadImage = PassthroughSubject<Int, Never>()
    @Published var dataArivved = PassthroughSubject<Bool, Never>()
    
    func downloadPost(id: String) {
        if finishedDownloading == false {
            db.collection("Cards_Data").document(id).getDocument(completion: {  (snapshot, error) in
                
                guard let post = snapshot?.data() else { return }
                if let dog = Pet(data: post) {
                    self.dog = dog
                    self.dataArivved.send(true)
                    print(snapshot as Any)
                    self.finishedDownloading = true
                    self.imageLoader = ImageLoader(urlString: dog.images)
                    self.sub = self.imageLoader?.didChange.sink(receiveValue: { value in
                        
                        self.imageData.append(value[self.imageCounter])
                        self.loadImage.send(self.imageCounter)
                        self.imageCounter += 1
                        print(self.imageData)
                    })
                }
            })
        }
    }
}
