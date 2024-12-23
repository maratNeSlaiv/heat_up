import SwiftUI

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    
    var body: some View {
        ZStack{
            Color.black // Black background for the whole body
                .ignoresSafeArea() // Ensures the background extends to the entire screen
            
            VStack(spacing: 20) {
                // Title Text
                Text(LocalizedStringKey("login_title"))
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white) // Change to the desired color
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)

                Spacer()
                
                // Email TextField
                TextField(LocalizedStringKey("login_emailPlaceholder"), text: $email)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                    .padding(.horizontal, 16)
                
                // Password SecureField
                
//                SecureField(LocalizedStringKey("login_passwordPlaceholder"), text: $password)
                SecureField("", text: $password)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .padding(.horizontal, 16)
                
                // Login Button
                Button(action: {
                    // Handle login logic here
                }) {
                    Text(LocalizedStringKey("login_confirm"))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(red: 0.0, green: 0.6, blue: 0.4))
                        .cornerRadius(8)
                }
                .padding(.horizontal, 16)
                
                // Forgot Password Link
                NavigationLink(destination: ResetPasswordView()) {
                    Text(LocalizedStringKey("login_forgotPassword"))
                        .foregroundColor(Color(red: 0.0, green: 0.6, blue: 0.4))
                        .font(.system(size: 18))
                        .padding()
                        .underline()
                }
                
                Spacer()
            }
        }
    }
}

struct LoginViewPreview: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LoginView()
        }
    }
}
