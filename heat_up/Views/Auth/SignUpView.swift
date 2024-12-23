import SwiftUI

struct PasswordRequirementRow: View {
    let isMet: Bool
    let textKey: LocalizedStringKey

    var body: some View {
        HStack {
            Circle()
                .fill(isMet ? Color.green : Color.gray)
                .frame(width: 8, height: 8)
                .padding(.leading, 10)

            Text(textKey)
                .padding(.leading, 10)
                .font(.system(size: 15))
                .foregroundColor(.white)
        }
    }
}

struct SignUpView: View {
    private var INVALID_CREDENTIALS_WARNING_TIME: TimeInterval = 3
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isPasswordVisible = false
    @State private var meetsLengthRequirement = false
    @State private var hasUpperCaseLetter = false
    @State private var hasDigit = false
    @State private var hasSpecialCharacter = false
    @State private var invalidPassword = false
    @State private var invalidEmail = false
    @State private var navigateToConfirmationPage = false
    
    private var passwordStrength: (key: LocalizedStringKey, color: Color) {
        guard meetsLengthRequirement else {
            return ("SignUp_passwordStrengthNotFinished", .gray)
        }
        
        let trueCount = [hasUpperCaseLetter, hasDigit, hasSpecialCharacter]
            .filter { $0 }
            .count
        
        switch trueCount {
        case 0...1:
            return ("SignUp_passwordStrengthWeak", .red)
        case 2:
            return ("SignUp_passwordStrengthMedium", .orange)
        case 3:
            return ("SignUp_passwordStrengthStrong", .green)
        default:
            return ("SignUp_passwordStrengthUnknown", .gray)
        }
    }
    
    private var passwordField: some View {
        Group {
            if isPasswordVisible {
                TextField("", text: $password)
                // TextField(LocalizedStringKey("signUp_passwordPlaceholder"), text: $password)
            } else {
                SecureField("", text: $password)
                // SecureField(LocalizedStringKey("signUp_passwordPlaceholder"), text: $password)
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black // Black background for the whole body
                    .ignoresSafeArea() // Ensures the background extends to the entire screen
                
                VStack(spacing: 20) {
                    Spacer() // Верхний отступ
                    
                    Text(LocalizedStringKey("SignUp_createAccountPrompt"))
                        .padding(.horizontal, 20)
                        .font(.system(size: 24))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .bold()
                        .foregroundColor(.white)
                    
                    VStack(alignment: .leading) {
                        Text(LocalizedStringKey("SignUp_emailAddressPrompt"))
                            .padding(.horizontal, 20)
                            .font(.system(size: 12))
                            .foregroundColor(.white)
                        
                        TextField(LocalizedStringKey("signUp_emailPlaceholder"), text: $email)
                            .padding() // Adds padding inside the TextField
                            .background(Color.gray.opacity(0.2)) // Sets the background color
                            .cornerRadius(8) // Rounds the corners of the background
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .foregroundColor(.white)
                            .padding(.horizontal, 20) // Adds padding around the TextField
                    }
                    
                    VStack(alignment: .leading) {
                        HStack {
                            Text(LocalizedStringKey("SignUp_passwordPrompt"))
                                .padding(.horizontal, 20)
                                .font(.system(size: 12))
                                .foregroundColor(.white)
                            
                            Text(passwordStrength.key)
                                .font(.system(size: 15, weight: .bold))
                                .foregroundColor(passwordStrength.color)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                                .padding(.trailing, 20)
                        }
                        
                        HStack {
                            passwordField
                                .padding()
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                                .background(Color.gray.opacity(0.2))
                                .foregroundColor(.white)
                                .cornerRadius(8)
                                .padding(.horizontal, 20)
                                .onChange(of: password) {
                                    meetsLengthRequirement = password.count >= 8
                                    hasDigit = password.rangeOfCharacter(from: .decimalDigits) != nil
                                    hasUpperCaseLetter = password.rangeOfCharacter(from: .uppercaseLetters) != nil
                                    hasSpecialCharacter = password.range(of: "[*&^%$#@!]", options: .regularExpression) != nil
                                }
                        }.overlay(alignment: .trailing) {
                            Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                                .foregroundColor(.white)
                                .onTapGesture {
                                    isPasswordVisible.toggle()
                                }
                                .padding(.trailing, 25)
                        }
                        
                        PasswordRequirementRow(isMet: meetsLengthRequirement, textKey: "SignUp_atLeast8Characters")
                        PasswordRequirementRow(isMet: hasDigit, textKey: "SignUp_containsADigit")
                        PasswordRequirementRow(isMet: hasUpperCaseLetter, textKey: "SignUp_containsUpperCase")
                        PasswordRequirementRow(isMet: hasSpecialCharacter, textKey: "SignUp_containsSpecialCharacter")
                        
                        if invalidEmail {
                            Text(LocalizedStringKey("SignUp_confirmEmailInvalid"))
                                .font(.subheadline)
                                .foregroundColor(.red)
                                .padding()
                                .transition(.opacity)
                        }
                        
                        if invalidPassword {
                            Text(LocalizedStringKey("SignUp_confirmPasswordInvalid"))
                                .font(.subheadline)
                                .foregroundColor(.red)
                                .padding()
                                .transition(.opacity)
                        }
                    }
                    
                    Spacer() // Отступ перед кнопками
                    
                    Button(action: {
                        if email.isEmpty {
                            invalidEmail = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + INVALID_CREDENTIALS_WARNING_TIME) {
                                invalidEmail = false
                            }
                        } else if !(meetsLengthRequirement && hasUpperCaseLetter && hasDigit && hasSpecialCharacter) {
                            invalidPassword = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + INVALID_CREDENTIALS_WARNING_TIME) {
                                invalidPassword = false
                            }
                        } else {
                            NetworkManager.registerUser(email: email, password: password) { success, errorMessage in
                                DispatchQueue.main.async {
                                    if success {
                                        navigateToConfirmationPage = true
                                    }
                                }
                            }
                        }
                    }) {
                        Text(LocalizedStringKey("signUp_confirm"))
                            .font(.headline)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(red: 0.0, green: 0.6, blue: 0.4))
                            .cornerRadius(10)
                    }
                    .padding(.horizontal, 20)
                    
                    HStack {
                        Text(LocalizedStringKey("signUp_haveAccount"))
                            .foregroundColor(.white)
                        
                        NavigationLink(destination: LoginView()) {
                            Text(LocalizedStringKey("signUp_login"))
                                .font(.headline)
                                .foregroundColor(Color(red: 0.0, green: 0.6, blue: 0.4))
                        }
                    }
                    
                    Button(action: {
                        // Guest action
                    }) {
                        Text(LocalizedStringKey("signUp_guest"))
                            .font(.headline)
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(UIColor.systemGray5))
                            .cornerRadius(10)
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer() // Нижний отступ
                }
            }
        }
    }
}

struct SignUpView_Preview: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
