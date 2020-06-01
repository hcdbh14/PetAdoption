import SwiftUI
import FirebaseStorage
import FirebaseDatabase

class MainVM: ObservableObject {
    var dogsList: [Dog] = []
    private var firstLaunch = false
    private let ref = Database.database().reference()
    @Published var count = 1
    @Published var frontImage: [String] = []
    @Published var imageURLS: [Int: [String]] = [:]
    
    func pushNewImage() {
        let removed = imageURLS.removeValue(forKey: count)
        frontImage = removed ?? []
        count += 1
    }
    
    func getDogsFromDB() {
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if let json = snapshot.value as? [String: Any]  {
                do {
                    for i in json.values {
                        let data = try JSONSerialization.data(withJSONObject: i, options: [])
                        let decoder = JSONDecoder()
                        let dogObject = try decoder.decode(Dog.self, from: data)
                        self.dogsList.append(dogObject)
                    }
                    self.getImageURLS()
                } catch {
                    print("error: \(error)")
                }
            }
        }) { (error) in
            print(error.localizedDescription)
        }
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
                        self.imageURLS[index]?.append("\(url!)")
                    }
                }
            }
        }
    }
}


