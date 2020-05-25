import SwiftUI
import FirebaseDatabase
import FirebaseStorage


class MainVM: ObservableObject {
    
    let ref = Database.database().reference()
    var dogsList: [Dog] = []
    @Published var count = 0
    @Published var frontImage: [String] = []
    @Published var dogsImages: [Int: [String]] = [:]
    
    func loadDataFromFirebase() {
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if let json = snapshot.value as? [String: Any]  {
                do {
                    for i in json.values {
                        let data = try JSONSerialization.data(withJSONObject: i, options: [])
                        let decoder = JSONDecoder()
                        let dogObject = try decoder.decode(Dog.self, from: data)
                        self.dogsList.append(dogObject)
                    }
                    self.loadImageFromFirebase()
                } catch {
                    print("error: \(error)")
                }
            }
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
    func pushNewImage() {
        let removed = dogsImages.removeValue(forKey: count)
        frontImage = removed ?? []
        print(frontImage)
        count += 1
    }
    
    
    func loadImageFromFirebase() {
        
        for (index, dog) in dogsList.enumerated() {
            if index > 10 {
                break
            }

            
            for path in dog.images {
                
                let storage = Storage.storage().reference(withPath: path)
                storage.downloadURL { (url, error) in
                    if error != nil {
                        print((error?.localizedDescription)!)
                        return
                    }
                    
                    print("Download success")

                    
                    if self.dogsImages[index] == nil {
                        if index < 1 {
                            self.frontImage = ["\(url!)"]
                        }
                        self.dogsImages[index] = ["\(url!)"]
                    } else {
                        if index < 1 {
                            self.frontImage[index].append("\(url!)")
                        }
                        self.dogsImages[index]?.append("\(url!)")
                    }
                }
            }
        }
    }
}


