import SwiftUI

struct IntroPage: View {
    @State private var imageVerticalOffset: CGFloat = 50
    @State private var imageIsVisible = false
    @State private var isTextVisible = false
    @State private var signUpOffsetX: CGFloat = -300 // Start position of the Sign Up button
    @State private var logInOffsetX: CGFloat = 300 // Start position of the Log In button
    @State private var navigateToSignUp = false
    @State private var navigateToLogIn = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black // Black background for the whole body
                    .ignoresSafeArea() // Ensures the background extends to the entire screen
                
                VStack{
                    Spacer()
                    Text("Get your muscles")
                        .font(.system(size: 24))
                        .bold()
                        .foregroundColor(.white)
                        .opacity(isTextVisible ? 1 : 0)
                        .animation(.easeIn(duration: 1.5), value: isTextVisible)
                        .onAppear {
                            isTextVisible = true
                        }
                    
                    Spacer()
                    
                    Image("fas1") // Replace with your image name
                        .resizable()
                        .scaledToFit() // Ensures the image fits while preserving its aspect ratio
                        .mask(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.black, Color.black.opacity(0)]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(maxWidth: .infinity, alignment: .top) // Ensures the image is aligned to the top
                        .frame(maxHeight: .infinity, alignment: .top)
                        .offset(y: imageVerticalOffset)
                        .opacity(imageIsVisible ? 1 : 0) // Controls the opacity
                        .onAppear {
                            withAnimation(.easeIn(duration: 4.0)) {
                                imageIsVisible = true
                            }
                            // Animate buttons sliding in when the view appears
                            withAnimation(.easeOut(duration: 1).delay(0.5)) {
                                signUpOffsetX = 0 // Move Sign Up button to center
                                logInOffsetX = 0 // Move Log In button to center
                            }
                        }
                    
                    Spacer() // Pushes buttons to the bottom
                    
                    HStack {
                        NavigationLink(destination: SignUpView()) {
                            Button(action: {
                                navigateToSignUp = true
                            }) {
                                Text("Sign Up")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(LinearGradient(gradient: Gradient(colors: [Color(red: 0.0, green: 0.3, blue: 0.3), Color(red: 0.0, green: 0.6, blue: 0.4)]), startPoint: .leading, endPoint: .trailing))
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                    .padding(.leading, 16)
                            }
                            .navigationDestination(isPresented: $navigateToSignUp) {
                                SignUpView()
                            }
                        }
                        .offset(x: signUpOffsetX) // Slide in from left
                        .frame(height: 50)
                        
                        NavigationLink(destination: SignUpView()) {
                            Button(action: {
                                navigateToLogIn = true
                            }) {
                                Text("Log In")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(LinearGradient(gradient: Gradient(colors: [Color(red: 0.6, green: 0.6, blue: 0.6), Color(red: 0.3, green: 0.3, blue: 0.3)]), startPoint: .leading, endPoint: .trailing))
                                    .foregroundColor(.black)
                                    .cornerRadius(10)
                                    .padding(.trailing, 16)
                            }
                            .navigationDestination(isPresented: $navigateToLogIn) {
                                LoginView()
                            }
                        }
                        .offset(x: logInOffsetX) // Slide in from right
                        .frame(height: 50)
                    }
                    .padding(.bottom, 40) // Bottom padding to avoid overlap with the screen edge
                }
            }
        }
    }
}

// Preview
struct IntroPage_Preview: PreviewProvider {
    static var previews: some View {
        IntroPage()
    }
}
