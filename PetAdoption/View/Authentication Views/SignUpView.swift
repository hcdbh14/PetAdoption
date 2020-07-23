import SwiftUI

struct SignUpView: View {
    
    @Binding var showLogin: Bool
    @State var error: String = ""
    @State var email: String = ""
    @State var password: String = ""
    @State var fullName: String = ""
    @Binding var showRegistration: Bool
    @EnvironmentObject var session: SessionStore
    @Environment (\.colorScheme) var colorScheme: ColorScheme
    
    init(showLogin: Binding<Bool>, showRegistration: Binding<Bool>) {
        
        self._showLogin = showLogin
        self._showRegistration = showRegistration
    }
    
    func moveToLogin() {
        showLogin = true
        showRegistration = false
    }
    
    func signUp() {
        session.signUp(email: email, password: password) { (result, error) in
            if let error = error {
                self.error = error.localizedDescription
            } else {
                self.session.saveUserData(email: self.email, fullName: self.fullName)
                self.session.verifyEmail()
                self.fullName = ""
                self.email = ""
                self.password = ""
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 8) {
            
//            ZStack {
//
//            Image("bone").resizable()
//                       .renderingMode(.template)
//                       .frame(width: 100, height: 100)
//                       .foregroundColor(.orange)
//
//            }.frame(width: UIScreen.main.bounds.width, alignment: .trailing)
            
            HStack {
                
                Text("הרשמה")
                    .font(.system(size: 36, weight: .heavy))
                    .foregroundColor(.white)
                    .padding(.leading, 25)
                Spacer()
                

            }
            
            VStack {
                HStack(spacing: 15) {
                    Image(systemName: "person.fill")
                        .foregroundColor(Color.gray)
                    
                    if colorScheme == .light {
                        TextField("שם מלא", text: $fullName)
                            .colorInvert()
                    } else {
                        TextField("שם מלא", text: $fullName)
                    }
                    
                    
                }.frame(height: 15)
                    .padding(.leading, 25)
                //            .modifier(TextFieldModifier())
                
                line.frame(width: UIScreen.main.bounds.width  / 1.2, height: 1)
            }     .padding(15)
            
            
            VStack {
                HStack(spacing: 15) {
                    
                    Image(systemName: "envelope.fill")
                        .foregroundColor(Color.gray)
                    
                    if colorScheme == .light {
                        TextField("אימייל", text: $email)
                            .colorInvert()
                    } else {
                        TextField("אימייל", text: $email)
                    }
                    
                    
                }.frame(height: 15)
                    .padding(.leading, 25)
                //            .modifier(TextFieldModifier())
                
                line.frame(width: UIScreen.main.bounds.width  / 1.2, height: 1)
            } .padding(15)
            
            
            VStack {
                HStack(spacing: 15) {
                    Image(systemName: "lock.fill")
                        .foregroundColor(Color.gray)
                    if colorScheme == .light {
                        SecureField("סיסמה", text: $password)
                            .colorInvert()
                    } else {
                        SecureField("סיסמה", text: $password)
                    }
                    
                    
                    
                }.frame(height: 15)
                    .padding(.leading, 25)
                //            .modifier(TextFieldModifier())
                
                line.frame(width: UIScreen.main.bounds.width  / 1.2, height: 1)
            }  .padding(15)
            
            Button(action: signUp) {
                Text("המשך")
                    .frame(width: UIScreen.main.bounds.width - 100, height: 50)
                    .foregroundColor(.white)
                    .background(Color("orange"))
                    .cornerRadius(30)
                    .shadow(radius: 5)
            }.padding(15)
            
            HStack {
                Button(action: moveToLogin) {
                    Text("כבר רשום?")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                    Text("כניסה")
                        .font(.system(size: 16, weight: .bold))
                        .underline()
                        .foregroundColor(.orange)
                }
            }
            .padding(.trailing, 25)
               Spacer()
            HStack {
                Spacer()
            Image("cuteDog").resizable()
                       .renderingMode(.template)
                       .frame(width: 200, height: 200)
                       .foregroundColor(.orange)
                .opacity(0.8)
                   
            }.frame(width: UIScreen.main.bounds.width)
                .padding(.bottom, -10)
       
        }
    }
}

