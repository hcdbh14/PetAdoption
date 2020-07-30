import SwiftUI

struct PostNewDog: View {
    
    @State private var image: Image?
    @State var triggerFade = true
    @Binding var showPostPet: Bool
    @Binding var showAuthScreen: Bool
    @State private var inputImage: UIImage?
    @State private var showingImagePicker = false
    @EnvironmentObject var session: SessionStore
    
    init(showAuthScreen: Binding<Bool>, showPostPet: Binding<Bool>) {
        self._showPostPet = showPostPet
        self._showAuthScreen = showAuthScreen
    }
    
    var body: some View {
        ScrollView {
            HStack {
                Button(action: closeLoginScreen) {
                    HStack {
                        Image(systemName: "chevron.right")
                        Text("חזור")
                    }
                }
                .foregroundColor(Color("orange"))
                .padding(.leading, 25)
                Spacer()
                
                if session.session != nil {
                    Button(action: signOut) {
                        Text("התנתקות")
                            .foregroundColor(Color("orange"))
                            .padding(.trailing, 15)
                    }
                }
            }.padding(.top, 30)
            
            
            
            HStack {
                Text("תמונות")
                    .font(.system(size: 30, weight: .heavy))
                    .foregroundColor(.black)
                    .padding(.leading, 25)
                Spacer()
            }.onAppear() {
                withAnimation {
                    self.triggerFade = false
                }
            }
            HStack {
                Spacer()
                Text("צריך לפחות תמונה אחת. התמונה שפה תהיה הראשונה שאנשים יראו")
                    .frame(width: 100, alignment: .trailing)
                    .foregroundColor(.black)
                
                
                Image(systemName: "arrow.left").resizable()
                    .frame(width: 60, height: 40)
                    .padding(.leading, 20)
                    .padding(.trailing, 20)
                    .foregroundColor(.gray)
                if image != nil {
                    image?.resizable().scaledToFit()
                }
                imagePlacerHolder().onTapGesture {
                    self.showingImagePicker = true
                }
                Spacer()
            }
            
            HStack {
                Spacer()
                imagePlacerHolder()
                imagePlacerHolder()
                imagePlacerHolder()
                Spacer()
            }
    
        }.frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height, alignment: .topLeading)
            .background(Color("offWhite").frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height + 20, alignment: .bottom).edgesIgnoringSafeArea(.bottom))
        .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
            ImagePicker(image: self.$inputImage)
        }
    
   
    }
    
    func closeLoginScreen() {
        
        UIApplication.shared.endEditing()
        
        withAnimation {
            showAuthScreen = false
        }
    }
    
    func signOut() {
        session.signOut()
        showPostPet = false
    }
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)
    }
}



struct imagePlacerHolder: View {
    
    var body: some View {
        
        ZStack {
            Image(uiImage: UIImage())
                .frame(width: 100, height: 150)
                .background(Color("offGray"))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .strokeBorder(
                            style: StrokeStyle(
                                lineWidth: 2,
                                dash: [15]
                            )
                    )
                        .foregroundColor(.gray)
            )
            Image(systemName: "plus.circle").resizable()
                .frame(width: 25, height: 25)
                .foregroundColor(.gray)
        }
    }
}







struct ImagePicker: UIViewControllerRepresentable {

    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as?
                UIImage {
                parent.image = uiImage
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
    }

    @State private var inputImage: UIImage?
    @State private var showingImagePicker = false
    @Environment(\.presentationMode) var presentationMode
    @Binding var image: UIImage?
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}






