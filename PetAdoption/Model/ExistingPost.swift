import Foundation

class ExistingPost: ObservableObject {
    @Published var age = ""
    @Published var city = ""
    @Published var desc = ""
    @Published var gender = ""
    @Published var images: [Data] = []
    @Published var name = ""
    @Published var number = ""
    @Published var race = ""
    @Published var suiteables = ""
    @Published var type = ""
}
