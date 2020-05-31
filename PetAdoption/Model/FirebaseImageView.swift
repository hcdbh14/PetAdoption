import SwiftUI
import Combine
import FirebaseStorage

class DataLoader: ObservableObject {
    @Published var didChange = PassthroughSubject<[Data], Never>()
    @Published var data: [Data] = [] { didSet {
        didChange.send(data)
        }
    }
    
    init(urlString: [String]) {
        getDataFromURL(urlString: urlString)
    }
    
    func getDataFromURL(urlString: [String]) {
        DispatchQueue.global().async {
            for i in urlString {
                guard let url = URL(string: i) else { return }
                
                
                
                
                let (data, _, error) = URLSession.shared.synchronousDataTask(urlrequest: url)
                if let error = error {
                    print("Synchronous task ended with error: \(error)")
                }
                else {
                    guard let data = data else { return }
                    DispatchQueue.main.async {
                        print("logic", self.data)
                        self.data.append(data)
                    }
                }
            }
        }
    }
}
