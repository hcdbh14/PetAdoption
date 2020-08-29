import Foundation

struct Pet {
    
    let name: String
    let type: String
    let age: Float
    let region: String
    let size: String
    let gender: String
    let number: String
    let images: [String]
    let desc: String
    let race: String
    let suitables: String
    let goodWords: String
    let vaccinated: String
    let poopTrained: String
    
    init?(data: [String: Any]) {
        
        guard let name = data["name"] as? String,
            let age = data["age"] as? Float,
            let size = data["size"] as? String,
            let images = data["images"] as? [String],
            let type = data["type"] as? String,
            let region = data["region"] as? String,
            let number = data["number"] as? String,
            let race = data["race"] as? String,
            let gender = data["gender"] as? String,
            let suitables = data["suitables"] as? String,
            let goodWords = data["goodWords"] as? String,
            let vaccinated = data["vaccinated"] as? String,
            let poopTrained = data["poopTrained"] as? String,
            let desc = data["desc"] as? String else {
                return nil
        }
        
        self.age = age
        self.size = size
        self.images = images
        self.name = name
        self.desc = desc
        self.type = type
        self.region = region
        self.gender = gender
        self.number = number
        self.race = race
        self.goodWords = goodWords
        self.suitables = suitables
        self.vaccinated = vaccinated
        self.poopTrained = poopTrained
    }
}
