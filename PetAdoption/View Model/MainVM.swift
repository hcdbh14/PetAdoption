import SwiftUI
import FirebaseDatabase
import FirebaseStorage


class MainVM: ObservableObject {
    let ref = Database.database().reference()
    var dogsList: [Dog] = []
    @Published var x: [CGFloat] = []
    @Published var degree: [Double] = []
    @Published var dogArray: [String] = []
    
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
    
    
    func loadImageFromFirebase() {
        for i in dogsList {
            let storage = Storage.storage().reference(withPath: i.images[0])
            storage.downloadURL { (url, error) in
                if error != nil {
                    print((error?.localizedDescription)!)
                    return
                }
                self.x.append(0)
                self.degree.append(0)
                print("Download success")
                self.dogArray.append("\(url!)")
            }
        }
    }
}


