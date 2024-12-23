//
//  MainPage.swift
//  heat_up
//
//  Created by marat orozaliev on 21/12/2024.
//

import SwiftUI

struct MainPageView: View {
    
    var body: some View {
        ZStack {
            Color.white // Black background for the whole body
                .ignoresSafeArea() // Ensures the background extends to the entire screen
            
            VStack{
                
                HStack {
                    Text(String("\u{1F525}"))// Unicode for 🔥
                        .font(.system(size: 24))
                    Spacer() // Pushes the text to the right
                    
                    
                    Text("Heat Up")
                        .foregroundStyle(.white)
                        .bold()
                        .font(.system(size: 12))
                        .padding(.trailing, 20)
                }
                Spacer()
                
                Text("Marat")
                    .foregroundColor(.white) // White text for contrast
                    .font(.largeTitle)
            }
        }
    }
}

struct MainPageView_Preview: PreviewProvider {
    static var previews: some View {
        MainPageView()
    }
}
