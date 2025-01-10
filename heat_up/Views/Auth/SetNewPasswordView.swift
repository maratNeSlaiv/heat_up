import SwiftUI

struct PasswordField: View {
    @Binding var password: String
    @State private var isPasswordVisible = false

    var body: some View {
        HStack {
            Group {
                if isPasswordVisible {
                    TextField("", text: $password)
                        .foregroundColor(.white)
                } else {
                    SecureField("", text: $password)
                        .foregroundColor(.white)
                }
            }
            .padding()
            .background(Color.gray.opacity(0.2))
            .cornerRadius(8)

            Button(action: {
                isPasswordVisible.toggle()
            }) {
                Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                    .foregroundColor(.white)
            }
        }
        .padding(.top, 20)
    }
}

struct SetNewPasswordView: View {
    @State private var newPassword = ""
    @State private var confirmPassword = ""
    @State private var passwordMismatch = false
    @State private var isPasswordVisible = false  // Для отображения/скрытия пароля
    @State private var isConfirmPasswordVisible = false
    
    @State private var meetsLengthRequirement = false
    @State private var hasUpperCaseLetter = false
    @State private var hasDigit = false
    @State private var hasSpecialCharacter = false
    
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
    
    var body: some View {
        NavigationView {
            ZStack{
                Color.black // Black background for the whole body
                    .ignoresSafeArea() // Ensures the background extends to the entire screen
                VStack(alignment: .leading) {
                    Spacer()
                    // Заголовок
                    Text(LocalizedStringKey("setNewPassword_instruction"))
                        .font(.system(size : 24))
                        .fontWeight(.bold)
                        .foregroundColor(.white) // Change to the desired color
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 20)
                    
                    Spacer()
                    
                    HStack{
                        Text(LocalizedStringKey("setNewPassword_newPasswordPrompt"))
                            .padding(.horizontal, 20)
                            .font(.system(size: 12))
                            .foregroundColor(.white)
                        
                        Text(passwordStrength.key)
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(passwordStrength.color)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .padding(.trailing, 20)
                    }
                    // New Password
                    PasswordField(password: $newPassword)
                        .onChange(of: newPassword) {
                            meetsLengthRequirement = newPassword.count >= 8
                            hasDigit = newPassword.rangeOfCharacter(from: .decimalDigits) != nil
                            hasUpperCaseLetter = newPassword.rangeOfCharacter(from: .uppercaseLetters) != nil
                            hasSpecialCharacter = newPassword.range(of: "[*&^%$#@!]", options: .regularExpression) != nil
                            passwordMismatch = !(newPassword == confirmPassword)
                        }
                    
                    // Requirements
                    PasswordRequirementRow(isMet: meetsLengthRequirement, textKey: "SignUp_atLeast8Characters")
                    PasswordRequirementRow(isMet: hasDigit, textKey: "SignUp_containsADigit")
                    PasswordRequirementRow(isMet: hasUpperCaseLetter, textKey: "SignUp_containsUpperCase")
                    PasswordRequirementRow(isMet: hasSpecialCharacter, textKey: "SignUp_containsSpecialCharacter")
                    
                    // Confirm Password
                    Spacer()
                    Text(LocalizedStringKey("setNewPassword_confirmPasswordPrompt"))
                        .padding(.horizontal, 20)
                        .font(.system(size: 12))
                        .foregroundColor(.white)
                    
                    PasswordField(password: $confirmPassword)
                        .onChange(of: confirmPassword) {
                            passwordMismatch = !(newPassword == confirmPassword)
                        }
                    
                    // Сообщение об ошибке, если пароли не совпадают
                    if passwordMismatch {
                        Text(LocalizedStringKey("setNewPassword_passwordMismatch"))
                            .foregroundColor(.red)
                            .padding(.top, 10)
                    }
                    
                    // Кнопка "Сохранить"
                    Button(action: SetNewPassword) {
                        Text(LocalizedStringKey("setNewPassword_save"))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(
                                meetsLengthRequirement && hasUpperCaseLetter && hasDigit && hasSpecialCharacter && !passwordMismatch
                                ? Color(red: 0.0, green: 0.6, blue: 0.4)  // Original color
                                : Color.gray // Grey color when conditions are not met
                            )
                            .cornerRadius(8)
                            .padding(.top, 30)
                    }
                    .disabled(!(meetsLengthRequirement && hasUpperCaseLetter && hasDigit && hasSpecialCharacter && !passwordMismatch)) // Disabled condition
                    .padding()
                    
                Spacer()
                }
                .padding()
            }
        }
    }
}

private func SetNewPassword() {
    // Call API via ViewModel
}

struct SetNewPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        SetNewPasswordView()
    }
}
