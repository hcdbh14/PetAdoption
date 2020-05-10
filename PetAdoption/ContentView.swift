import SwiftUI
import Firebase

struct ContentView: View {
    
    let ref = Database.database().reference()
    
    var body: some View {
        Text("Hello, World!")
            .onAppear() {
                self.ref.child("test/name").setValue("Kenny")
                self.ref.childByAutoId().setValue(["name":"Tom", "role":"Admin", "age": 30])
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
