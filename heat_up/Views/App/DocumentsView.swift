import SwiftUI

struct AnalyzeImageView: View {
    @State private var droppedFiles: [URL] = []

    var body: some View {
        ZStack {
            Color.black // Black background for the whole body
                .ignoresSafeArea() // Ensures the background extends to the entire screen
            
            VStack {
                HStack {
                    Text("Documents")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.system(size: 24))
                        .bold()
                        .foregroundStyle(.white)
                        .padding()
                    
                    Button(action: {
                        // Действие при нажатии на плюсик
                    }) {
                        Image(systemName: "plus.circle.fill") // Плюс с окружностью
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundColor(Color(red: 0.0, green: 0.6, blue: 0.4)) // Цвет иконки
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity) // Make the VStack fill the screen
            .padding()
        }
    }
}

struct AnalyzeImageView_Previews: PreviewProvider {
    static var previews: some View {
        AnalyzeImageView()
    }
}
