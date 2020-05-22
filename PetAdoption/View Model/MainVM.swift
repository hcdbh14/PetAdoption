import SwiftUI
import FirebaseDatabase
import FirebaseStorage


class MainVM: ObservableObject {
    let ref = Database.database().reference()
    let FILE_LIST = ["doggie.jpg", "pug.jpg", "puppy.jpg", "doggie2.jpg", "doggie3.jpg"]
    @Published var dogArray: [String] = ["", ""]
    
    
    
    func loadDataFromFirebase() {
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if let json = snapshot.value as? [String: Any]  {
                do {
                    for i in json.values {
                        let data = try JSONSerialization.data(withJSONObject: i, options: [])
                        let decoder = JSONDecoder()
                        let dogs  = try decoder.decode(Dog.self, from: data)
                        print(dogs)
                    }
                } catch {
                    print("error: \(error)")
                }
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    
    func loadImageFromFirebase() {
        for i in FILE_LIST {
            let storage = Storage.storage().reference(withPath: i)
            storage.downloadURL { (url, error) in
                if error != nil {
                    print((error?.localizedDescription)!)
                    return
                }
                print("Download success")
                self.dogArray.append("\(url!)")
            }
        }
    }
}


