import SwiftUI
import Firebase
import Combine

class SessionStore: ObservableObject {
    
    private let db = Firestore.firestore()
    var handle: AuthStateDidChangeListenerHandle?
    var didChange = PassthroughSubject<SessionStore, Never>()
    @Published var session: User? {didSet {self.didChange.send(self) }}
    
    func listen() {
        handle = Auth.auth().addStateDidChangeListener({ (auth, user) in
            if let user = user {
                self.session = User(uid: user.uid, email: user.email)
            } else {
                self.session = nil
            }
        })
    }
    
    
    func signUp(email: String, password: String, handler: @escaping AuthDataResultCallback) {
        
        Auth.auth().createUser(withEmail: email, password: password, completion: handler)
    }
    
    
    func signIn(email: String, password: String, handler: @escaping AuthDataResultCallback) {
        
        Auth.auth().signIn(withEmail: email, password: password, completion: handler)
    }
    
    func saveUserData(email: String, fullName: String) {
        
        db.collection("Users_Data").document("FcGH2Jl2nOQZOr6O7vf1").setData([email: email ,fullName: fullName])
    }
    
    func postNewPet(petType: String, petName: String, petRace: String, petAge: String, suitables: String,petGender: String, description: String, phoneNumber: String, city: String) {
        
        let email = Auth.auth().currentUser?.email ?? ""
        db.collection("Cards_Data").document("mgKHizMkprh0maJSxnar").setData([email: email ,petType: petType, petName: petName, petRace: petRace, petAge: petAge, suitables: suitables,petGender: petGender, description: description,phoneNumber: phoneNumber, city: city])
    }
    
    func passwordReset(email: String, handler: @escaping SendPasswordResetCallback) {
        Auth.auth().sendPasswordReset(withEmail: email, completion: handler)
    }
    
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.session = nil
        } catch {
            print("Error signing out")
        }
    }
    
    
    func verifyEmail() {
        Auth.auth().currentUser?.sendEmailVerification { (error) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    
    func checkIfEmailVerified(handler: @escaping SendPasswordResetCallback) {
        Auth.auth().currentUser?.reload(completion: handler)
    }
    
    func returnEmail () -> String {
        return Auth.auth().currentUser?.email ?? "no email found"
    }
    
    func unbind() {
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
    
    
    deinit {
        unbind()
    }
}


struct User {
    
    var uid: String
    var email: String?
    
    init(uid: String, email: String?) {
        self.uid = uid
        self.email = email
    }
}
