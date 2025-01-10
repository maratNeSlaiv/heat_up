//
//  AreaCategoryView.swift
//  heat_up
//
//  Created by marat orozaliev on 10/1/2025.
//

import SwiftUI

struct AreaCategoryView: View {
    let countries = [
        "american", "british", "canadian", "chinese", "croatian", "dutch", "egyptian", "filipino", "french", "greek", "indian", "irish", "italian", "jamaican", "japanese", "kenyan", "malaysian", "mexican", "moroccan", "polish", "portuguese", "russian", "spanish", "thai", "tunisian", "turkish", "ukrainian", "vietnamese", "unknown"
    ]
    
    var body: some View {
        let gridItems = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
        
        ScrollView {
            LazyVGrid(columns: gridItems, spacing: 10) {
                ForEach(countries, id: \.self) { country in
                    CountryFlagIconView(country: country)
                }
            }
            .padding()
        }
    }
}

struct CountryFlagIconView: View {
    let country: String
    
    var body: some View {
        VStack {
            Text(country.capitalized)
                .font(.subheadline)
            
            Image("country_flags_\(country)") // Make sure to add the images with the correct names in your assets
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
        }
        .frame(width: 80, height: 110)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
        .padding(5)
    }
}

struct AreaCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        AreaCategoryView()
    }
}
