//
//  CommodityView.swift
//  heat_up
//
//  Created by marat orozaliev on 12/1/2025.
//

import SwiftUI

struct CommodityView: View {
    @StateObject var viewModel = CommodityViewModel()
    var barcode: String
    
    var body: some View {
        VStack {
            if let commodity = viewModel.product {
                Text("Nutriscore Grade: \(commodity.nutriscoreGrade)")
                Text("Nutriscore Score: \(commodity.nutriscoreScore)")
                
                if let imageUrl = URL(string: commodity.imageUrl), !commodity.imageUrl.isEmpty {
                    AsyncImage(url: imageUrl) { image in
                        image.resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                    } placeholder: {
                        Image(systemName: "app.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                    }
                } else {
                    Image(systemName: "app.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                }
                
                ForEach(commodity.nutriments.keys.sorted(), id: \.self) { key in
                    if let value = commodity.nutriments[key] {
                        Text("\(key): \(value)")
                    }
                }
            } else if let errorMessage = viewModel.errorMessage {
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
            } else {
                Text("Product not found.")
                    .foregroundColor(.gray)
            }
        }
        .onAppear {
            viewModel.fetchCommodityData(barcode: barcode)
        }
    }
}

#Preview {
    CommodityView(barcode: "9300633539047")
}
