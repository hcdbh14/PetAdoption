import Foundation

struct Dog {
    
    let name: String
    let type: String
    let age: String
    let city: String
    let gender: String
    let number: String
    let images: [String]
    let desc: String
    let race: String
    let suitables: String
    
    init?(data: [String: Any]) {
        
        guard let name = data["name"] as? String,
            let age = data["age"] as? String,
            let images = data["images"] as? [String],
            let type = data["type"] as? String,
            let city = data["city"] as? String,
            let number = data["number"] as? String,
            let race = data["race"] as? String,
            let gender = data["gender"] as? String,
            let suitables = data["suitables"] as? String,
            let desc = data["desc"] as? String else {
                return nil
        }
        
        self.age = age
        self.images = images
        self.name = name
        self.desc = desc
        self.type = type
        self.city = city
        self.gender = gender
        self.number = number
        self.race = race
        self.suitables = suitables
    }
}
