import SwiftUI
import Combine
import FirebaseStorage

struct FirebaseImageView: View {
    @ObservedObject var imageLoader: DataLoader
    @State var image:UIImage = UIImage()
    
    init(imageURL: [String]) {
        imageLoader = DataLoader(urlString: imageURL)
    }
    
    var body: some View {
        VStack {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width:400, height:400)
        }
        //        .onReceive(imageLoader.didChange) { data in
        //            self.image = UIImage(data: data) ?? UIImage()
        //        }
    }
}

class DataLoader: ObservableObject {
    @Published var didChange = PassthroughSubject<[Data], Never>()
    @Published var data: [Data] = [] {
        didSet {
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

                
                
                
                
//                URLSession.shared.dataTask(with: url) { data, response, error in
//                    guard let data = data else { return }
//                    DispatchQueue.main.async {
//                        print("logic", self.data)
//                        self.data.append(data)
//                    }
//                }
            }
    }
}

extension URLSession {
    func synchronousDataTask(urlrequest: URL) -> (data: Data?, response: URLResponse?, error: Error?) {
        var data: Data?
        var response: URLResponse?
        var error: Error?

        let semaphore = DispatchSemaphore(value: 0)

        let dataTask = self.dataTask(with: urlrequest) {
            data = $0
            response = $1
            error = $2

            semaphore.signal()
        }
        dataTask.resume()

        _ = semaphore.wait(timeout: .distantFuture)

        return (data, response, error)
    }
}
