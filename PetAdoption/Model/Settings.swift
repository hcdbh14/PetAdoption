import Foundation

enum SearchBy: Int {
    case all = 0
    case dog = 1
    case cat = 2
}

class Settings: ObservableObject {
    
    @Published var searchBy = UserDefaults.standard.integer(forKey: "searchBy")
    
    func updateSettings(_ choice: Int) {
        UserDefaults.standard.set(choice, forKey: "searchBy")
        searchBy = choice
    }
}
