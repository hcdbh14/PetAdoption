import SwiftUI

class SavedDogsVM: ObservableObject {
    
    private let localDB = LocalDB()
    @ObservedObject private var imageLoader: ImageLoader
    
    init(indexCount: Int) {
        imageLoader = ImageLoader(urlString: localDB.savedDogsURLS?[indexCount] ?? [])
    }
}
