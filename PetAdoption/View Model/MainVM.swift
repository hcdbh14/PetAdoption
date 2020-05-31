import SwiftUI
import FirebaseDatabase
import FirebaseStorage


class MainVM: ObservableObject {
    private var firstLaunch = false
    var dogsList: [Dog] = []
    let ref = Database.database().reference()
    @Published var count = 1
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
                        
                        self.dogsImages[index] = ["\(url!)"]
                    } else {
                        if self.dogsList[0].images.count ==  self.dogsImages[0]?.count &&  self.firstLaunch == false {
                            //                            self.frontImage[index].append("\(url!)")
                            self.frontImage = self.dogsImages.removeValue(forKey: 0) ?? []
                            self.firstLaunch = true
                        }
                        self.dogsImages[index]?.append("\(url!)")
                    }
                    print(self.dogsImages)
                }
            }
        }
    }
}


