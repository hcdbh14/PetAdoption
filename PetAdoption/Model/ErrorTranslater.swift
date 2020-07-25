import Foundation

struct ErrorTranslater {

    func signUpErrors(_ errorDescription: String) -> String {
        
        switch errorDescription {
        
        case "The password must be 6 characters long or more.":
            return "סיסמה אמורה להיות 6 תווים לפחות"
        
        case "An email address must be provided.":
            return "חסר כתובת מייל"
            
        case "The email address is badly formatted.":
            return "כתובת מייל שהוזן לא תקין"
            
        case "The email address is already in use by another account.":
            return "המייל שהוזן כבר רשום"
            
        default:
            return errorDescription
        }
    }
}
