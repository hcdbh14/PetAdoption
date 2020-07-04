import Foundation

class LocalDB: ObservableObject {
    @Published var savedDogsCount = "0"
    @Published var savedDogsURLS: [[String]]? = UserDefaults.standard.array(forKey: "savedDogsURLS") as? [[String]]
    
    init() {
        if let count = savedDogsURLS?.count {
            savedDogsCount = String(count)
        }
    }
    
    func saveDogURL(_ dogImageURLS: [String]) {
        var tempArray = savedDogsURLS ?? []
        tempArray.append(dogImageURLS)
        
        UserDefaults.standard.set(tempArray, forKey: "savedDogsURLS")
        savedDogsURLS = tempArray
        if let count = savedDogsURLS?.count {
            savedDogsCount = String(count)
        }
    }
}
