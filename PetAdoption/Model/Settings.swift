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
    @Published var ages: [Int]? = UserDefaults.standard.array(forKey: "ages") as? [Int]
    @Published var areas: [Int]? = UserDefaults.standard.array(forKey: "areas") as? [Int]
    
    func updateSettings(_ choice: Int) {
        UserDefaults.standard.set(choice, forKey: "searchBy")
        searchBy = choice
    }
    
    
    func updateArea(_ choice: [Int]) {

        UserDefaults.standard.set(choice, forKey: "areas")
        areas = choice
    }
    
    func updateAge(_ choice: [Int]) {

        UserDefaults.standard.set(choice, forKey: "ages")
        ages = choice
    }
}
