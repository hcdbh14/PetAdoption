import Foundation
import Combine
import FirebaseStorage
import FirebaseFirestore

class ExistingPost: ObservableObject {
    var finishedDownloading = false
    @Published var dog: Dog?
    private let db = Firestore.firestore()
    @Published var dataArivved = PassthroughSubject<Bool, Never>()
    
    func downloadPost(id: String) {
        if finishedDownloading == false {
            db.collection("Cards_Data").document(id).getDocument(completion: {  (snapshot, error) in
                
                guard let post = snapshot?.data() else { return }
                if let dog = Dog(data: post) {
                    self.dog = dog
                    self.dataArivved.send(true)
                    print(snapshot as Any)
                    self.finishedDownloading = true
                }
            })
        }
    }
}
