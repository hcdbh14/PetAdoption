import Foundation

struct ErrorTranslater {

    func signUpErrors(_ errorDescription: String) -> String {
        
        switch errorDescription {
        
        case "The password must be 6 characters long or more.":
            return "סיסמה אמורה להיות 6 תווים לפחות"
            
        default:
            return errorDescription
        }
    }
}
