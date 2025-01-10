import SwiftUI

struct MainPageView: View {
    var body: some View {
        NavigationView {
            ZStack{
                Color.black // Black background for the whole body
                    .ignoresSafeArea() // Ensures the background extends to the entire screen
                
                VStack{
                    NavigationLink(destination: DocumentsView()) {
                        Image(systemName: "folder.fill") // The folder icon
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50) // Adjust the size
                            .foregroundColor(.green) // Set color
                    }
                    .buttonStyle(PlainButtonStyle()) // Make the link behave like a button
                    
                    Text("Documents")
                        .font(.title)
                        .foregroundStyle(.white)
                }
                .padding()
            }
        }
    }
}

struct MainPageView_Previews: PreviewProvider {
    static var previews: some View {
        MainPageView()
    }
}
