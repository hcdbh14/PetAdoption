import SwiftUI
import FirebaseStorage

class MainVM: ObservableObject {
    let FILE_LIST = ["doggie.jpg", "pug.jpg", "puppy.jpg", "doggie2.jpg", "doggie3.jpg"]
    @Published var dogArray: [String] = ["", ""]
    
    
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
