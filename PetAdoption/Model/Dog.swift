import Foundation

struct Dog {
    
    let age: Int
    let images: [String]
    let name: String
    let desc: String
    
    init?(data: [String: Any]) {
        
        guard let age = data["age"] as? Int,
            let images = data["images"] as? [String],
            let name = data["name"] as? String,
            let desc = data["desc"] as? String else {
                return nil
        }
        
        self.age = age
        self.images = images
        self.name = name
        self.desc = desc
    }
}
