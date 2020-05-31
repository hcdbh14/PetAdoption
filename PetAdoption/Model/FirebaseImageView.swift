import Combine
import FirebaseStorage

class DataLoader: ObservableObject {
    @Published var didChange = PassthroughSubject<[Data], Never>()
    @Published var data: [Data] = [] { didSet {
        didChange.send(data)
        }
    }
    
    init(urlString: [String]) {
        getStorageImages(urlString: urlString)
    }
    
    func getStorageImages(urlString: [String]) {
        DispatchQueue.global().async {
            for i in urlString {
                guard let url = URL(string: i) else { return }
                let (data, _, error) = URLSession.shared.synchronousDataTask(urlrequest: url)
                if let error = error { print("Synchronous task ended with error: \(error)") }
                else {
                    guard let data = data else { return }
                    DispatchQueue.main.async {
                        self.data.append(data)
                    }
                }
            }
        }
    }
}
