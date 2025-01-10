import SwiftUI

struct ResetPasswordView: View {
    @State private var email: String = ""
    @State private var isValidEmail: Bool = true
    @State private var isRequestSent: Bool = false
    @State private var otp: String = ""
    @State private var isValidOTP: Bool = true
    @State private var navigateToPasswordView = false  // Для навигации

    
    private func isValidEmailFormat(_ email: String) -> Bool {
        let emailRegex = "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: email)
    }
    
    private func sendResetPasswordRequest() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            isRequestSent = true
        }
    }
    
    private func verifyOTP() {
        if otp == "123456" {  // Проверка корректности OTP
            isValidOTP = true
            navigateToPasswordView = true  // Активировать переход
        } else {
            isValidOTP = false
        }
    }
    
    private func isDigitOTP() -> Bool {
        let otpDigitsOnly = otp.filter { $0.isNumber } // Remove non-numeric characters
        return otpDigitsOnly.count == 6
    }
    
    var body: some View{
        NavigationStack{
            ZStack{
                Color.black // Black background for the whole body
                    .ignoresSafeArea() // Ensures the background extends to the entire screen
                
                VStack {
                    
                    Text(LocalizedStringKey("resetPassword_title"))
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white) // Change to the desired color
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 20)
                    
                    Text(LocalizedStringKey("resetPassword_instruction"))
                        .font(.title2)
                        .padding()
                        .foregroundColor(.white)
                    
                    // Поле ввода email
                    TextField(LocalizedStringKey("resetPassword_email"), text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                        .padding(.horizontal)
                        .foregroundColor(.white)
                        .onChange(of: email) {
                            isValidEmail = isValidEmailFormat(email)
                        }
                    
                    // Сообщение об ошибке для некорректного email
                    if !isValidEmail {
                        Text(LocalizedStringKey("resetPassword_invalidEmail"))
                            .foregroundColor(.red)
                            .padding(.bottom)
                    }
                    
                    // Кнопка отправки OTP
                    Button(action: sendResetPasswordRequest) {
                        Text(LocalizedStringKey("resetPassword_sendOTP"))
                            .foregroundColor(.white)
                            .padding()
                            .background(isValidEmail && !email.isEmpty ? Color(red: 0.0, green: 0.6, blue: 0.4) : Color.gray)
                            .cornerRadius(8)
                    }
                    .disabled(!isValidEmail || email.isEmpty)
                    .padding()
                    
                    Spacer()
                    // Подтверждение отправки OTP
                    if isRequestSent {
                        Text(LocalizedStringKey("resetPassword_OTPSentConfirmation"))
                            .foregroundColor(.green)
                            .padding()
                        
                        // Поле ввода OTP
                        TextField(LocalizedStringKey("resetPassword_otp"), text: $otp)
                            .keyboardType(.numberPad)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(8)
                            .foregroundColor(.white)
                            .padding(.horizontal)
                        
                        // Сообщение об ошибке для некорректного OTP
                        if !isValidOTP {
                            Text(LocalizedStringKey("resetPassword_invalidOTP"))
                                .foregroundColor(.red)
                                .padding(.bottom)
                        }
                        
                        // Кнопка проверки OTP
                        Button(action: verifyOTP) {
                            Text(LocalizedStringKey("resetPassword_verifyOTP"))
                                .foregroundColor(.white)
                                .padding()
                                .background(isDigitOTP() ? Color(red: 0.0, green: 0.6, blue: 0.4) : Color.gray)
                                .cornerRadius(8)
                        }
                        .disabled(!isDigitOTP())
                        .padding()
                    }
                    
                    Spacer()
                }
                .navigationDestination(isPresented: $navigateToPasswordView) {
                    SetNewPasswordView()
                }
            }
        }
    }
}

struct ResetPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ResetPasswordView()
    }
}
