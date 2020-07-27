import Foundation

struct ErrorTranslater {
    
    func signUpErrors(_ errorDescription: String) -> String {
        
        switch errorDescription {
            
        case "Network error (such as timeout, interrupted connection or unreachable host) has occurred.":
            return "לא נמצא חיבור לאינטרנט"
            
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
    
    
    func signInErrors(_ errorDescription: String) -> String {
        
        switch errorDescription {
            
        case "Network error (such as timeout, interrupted connection or unreachable host) has occurred.":
            return "לא נמצא חיבור לאינטרנט"
            
        case "The email address is badly formatted.":
            return "כתובת מייל שהוזן לא תקין"
            
        case "There is no user record corresponding to this identifier. The user may have been deleted.":
            return "סיסמה או מייל לא נכונים"
            
        case "The password is invalid or the user does not have a password.":
            return "סיסמה או מייל לא נכונים"
            
        default:
            return errorDescription
        }
    }
    
    func passwordResetErrors(_ errorDescription: String) -> String {
        
        switch errorDescription {
            
        case "Network error (such as timeout, interrupted connection or unreachable host) has occurred.":
            return "לא נמצא חיבור לאינטרנט"
            
        case "The email address is badly formatted.":
            return "כתובת מייל שהוזן לא תקין"
            
        case "There is no user record corresponding to this identifier. The user may have been deleted.":
            return "כתובת מייל שהוקלד לא קיים"
            
        case "An email address must be provided.":
            return "חסר כתובת מייל"
            
        default:
            return errorDescription
        }
    }
}
