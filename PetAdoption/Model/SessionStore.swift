import SwiftUI
import Firebase
import Combine


class SessionStore: ObservableObject {
    
    @Published var informText = ""
    private let db = Firestore.firestore()
    @ObservedObject var localDB = LocalDB()
    @Published var waitingForResponse = false
    @Published var actionText = "פרסום מודעה"
    var handle: AuthStateDidChangeListenerHandle?
    @Published var existingPost = ExistingPost()
    @Published var imagePaths: [Int : String] = [:]
    private let storage = Storage.storage().reference()
    var didChange = PassthroughSubject<SessionStore, Never>()
    @Published var session: User? { didSet {self.didChange.send(self) }}
    
    func getExistingPost() {
        
        DispatchQueue.global().async {
            guard let userId = Auth.auth().currentUser?.uid else { return }
            self.existingPost.downloadPost(id: userId)
        }
    }
    
    func listen() {
        handle = Auth.auth().addStateDidChangeListener({ (auth, user) in
            if let user = user {
                self.session = User(uid: user.uid, email: user.email)
            } else {
                self.session = nil
            }
        })
    }
    
    func checkIfUserCanEnter() -> Bool {
        guard let user = Auth.auth().currentUser else { return false }
        
        if user.isEmailVerified {
            return true
        } else {
            return false
        }
    }
    
    func signUp(email: String, password: String, handler: @escaping AuthDataResultCallback) {
        
        Auth.auth().createUser(withEmail: email, password: password, completion: handler)
    }
    
    
    func signIn(email: String, password: String, handler: @escaping AuthDataResultCallback) {
        
        Auth.auth().signIn(withEmail: email, password: password, completion: handler)
    }
    
    
    func saveUserData(email: String, fullName: String) {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        db.collection("Users_Data").document(uid).setData(["email": email ,"name": fullName])
    }
    
    
    func postPetImages(imagesData: [Data], petType: String, petName: String, petRace: String, petAge: String, petSize: String, suitables: String, petGender: String, description: String, phoneNumber: String, region: String, goodWords: String, vaccinated: String, poopTrained: String) {
        
        waitingForResponse = true
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        
        for i in imagesData {
            guard let index = imagesData.firstIndex(of: i) else { return }
            let fileName = "\(uid)/" + "\(index)"
            let metaData = StorageMetadata()
            metaData.contentType = "image/jpg"
            
            storage.child(fileName).putData(i, metadata: metaData, completion: { result, error in
                guard error == nil else {
                    self.informText = "קרתה שגיאה, אנא נסו שוב"
                    return
                }
                
                self.storage.child(fileName).downloadURL(completion: { url, error in
                    guard let url = url, error == nil else {
                        self.waitingForResponse = false
                        return
                    }
                    let urlString = url.absoluteURL
                    self.imagePaths[index] = urlString.absoluteString
                    print(urlString)
                    print(self.imagePaths)
                    
                    if self.imagePaths.count == imagesData.count {
                        var sortedImagePaths: [String] = []
                        let sortedKeys = self.imagePaths.keys.sorted()
                        for i in sortedKeys {
                            sortedImagePaths.append(self.imagePaths[i] ?? "")
                        }
                        self.postNewPet(petType: petType, petName: petName, petRace: petRace, petAge: petAge, petSize: petSize, suitables: suitables, petGender: petGender, description: description, phoneNumber: phoneNumber, region: region, goodWords: goodWords, vaccinated: vaccinated, poopTrained: poopTrained, images: sortedImagePaths )
                        self.waitingForResponse = false
                        self.localDB.savePostID(id: uid)
                        self.localDB.existingPostID = uid
                    }
                })
                print(result as Any)
            })
        }
    }
    
    
    func postNewPet(petType: String, petName: String, petRace: String, petAge: String, petSize: String, suitables: String,petGender: String, description: String, phoneNumber: String, region: String, goodWords: String, vaccinated: String, poopTrained: String, images: [String]) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        db.collection("Cards_Data").document(uid).setData(["type": petType, "name": petName, "race": petRace, "age": Float(petAge) ?? 0, "size": petSize, "suitables": suitables,"gender": petGender, "desc": description,"number": phoneNumber, "region": region,"goodWords": goodWords, "vaccinated": vaccinated, "poopTrained": poopTrained, "images": images], completion: { (error) in
            if error != nil {
                self.informText = "קרתה שגיאה, אנא נסו שוב"
            } else {
                self.informText = "מודעה פורסמה בהצלחה,ניתן לעדכן את הפרטים בכל עת"
            }
        })
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
