import Foundation

extension String {
    func trim() -> String {
        return String(self.filter { !"\n".contains($0) })
    }
}
