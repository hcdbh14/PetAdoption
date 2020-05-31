import Foundation


extension Array {
    
    func hasValueAt(index: Int ) -> Bool {
        return index >= startIndex && index < endIndex
    }
}
