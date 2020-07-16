import Foundation

enum SearchBy: Int {
    case all = 0
    case dog = 1
    case cat = 2
}

enum AreaInIsrael: Int {
    case north = 0
    case centeral = 1
    case south = 2
}

class Settings: ObservableObject {
    
    @Published var searchBy = UserDefaults.standard.integer(forKey: "searchBy")
    @Published var areas: [Int]? = UserDefaults.standard.array(forKey: "areas") as? [Int]
    
    
    func updateSettings(_ choice: Int) {
        UserDefaults.standard.set(choice, forKey: "searchBy")
        searchBy = choice
    }
    
    
    func updateArea(_ choice: Int) {
        var tempArray: [Int] = areas ?? []
        
        if tempArray.contains(choice) {
            if let index = tempArray.firstIndex(of: choice) {
                tempArray.remove(at: index)
            }
        } else {
            tempArray.append(choice)
        }
        UserDefaults.standard.set(tempArray, forKey: "areas")
        areas = tempArray
    }
}
