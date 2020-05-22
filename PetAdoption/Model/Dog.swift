import Foundation


struct DogsList: Decodable {
    var id : [String: Dog]
}


struct Dog: Decodable {
    var age: Int
    var images: [String]
    var name: String
}

private enum CodingKeys : String, CodingKey {
    case street, zip = "zip_code", city, state
}
