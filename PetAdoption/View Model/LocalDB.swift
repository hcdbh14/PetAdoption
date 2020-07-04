import Foundation

class LocalDB {
    @Published var savedDogsURLS: [[String]]? = UserDefaults.standard.array(forKey: "savedDogsURLS") as? [[String]]
    
    func saveDogURL(_ dogImageURLS: [String]) {
        var tempArray = savedDogsURLS ?? []
        tempArray.append(dogImageURLS)
        
        UserDefaults.standard.set(tempArray, forKey: "savedDogsURLS")
        savedDogsURLS = tempArray
    }
}
