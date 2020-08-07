import Foundation
import FirebaseStorage
import FirebaseFirestore

class ExistingPost: ObservableObject {
    
    private let db = Firestore.firestore()
    @Published var age = ""
    @Published var city = ""
    @Published var desc = ""
    @Published var gender = ""
    @Published var images: [Data] = []
    @Published var name = ""
    @Published var number = ""
    @Published var race = ""
    @Published var suiteables = ""
    @Published var type = ""
    
    
    func downloadPost(id: String) {
        db.collection("Cards_Data").document(id).getDocument(completion: {  (snapshot, error) in
            
            guard let post = snapshot?.data() else { return }
            if let dog = Dog(data: post) {
                print(dog)
            }
        })
    }
}
