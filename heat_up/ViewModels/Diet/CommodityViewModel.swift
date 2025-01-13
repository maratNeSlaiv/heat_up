//
//  CommodityViewModel.swift
//  heat_up
//
//  Created by marat orozaliev on 12/1/2025.
//

import Foundation
import SwiftUI
import Combine

class CommodityViewModel: ObservableObject {
    @Published var product: Commodity? = nil
    @Published var errorMessage: String? = nil
    
    func fetchCommodityData(barcode: String) {
        let urlString = "https://world.openfoodfacts.org/api/v0/product/\(barcode).json"
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self?.errorMessage = "Error: \(error.localizedDescription)"
                }
                print("Network Error: \(error.localizedDescription)") // Log network error
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    self?.errorMessage = "No data received."
                }
                print("No data received.") // Log case when no data is received
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(CommodityResponse.self, from: data)
                DispatchQueue.main.async {
                    if response.status == 1, let productData = response.product {
                        self?.product = self?.parseCommodity(productData)
                    } else {
                        self?.product = nil
                        self?.errorMessage = "Product not found."
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self?.errorMessage = "Error decoding response."
                }
                print("Decoding Error: \(error)") // Log decoding error
            }
        }
        task.resume()
    }
    
    func parseCommodity(_ productData: CommodityData) -> Commodity {
        // Default values for missing keys
        let productName = productData.product_name ?? ""
        let nutriscoreGrade = productData.nutriscore_grade ?? ""
        let nutriscoreScore = productData.nutriscore_score ?? 1000.0

        
        // Use a default food icon URL if no image is found
        let imageUrl = productData.image_url ?? "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRP9fFcG7-Ldbywf_v4ouWc19enMjPNjPItZg&s"
        
        // List of the specific nutrients to filter for
        let requiredNutrients = [
            "carbohydrates_100g", "fat_100g", "proteins_100g", "sodium_100g",
            "saturated-fat_100g", "sugars_100g", "fiber_100g", "energy_100g"
        ]
        
        // Initialize an empty dictionary to store the filtered nutriments
        var nutriments: [String: Double] = [:]
        
        if let nutrimentData = productData.nutriments {
            for requiredKey in requiredNutrients {
                if let nutrientValue = nutrimentData[requiredKey] {
                    nutriments[requiredKey] = nutrientValue
//                } else {
//                    nutriments[requiredKey] = -1.0
                }
            }
        }
        
        return Commodity(productName: productName, nutriscoreGrade: nutriscoreGrade, nutriscoreScore: nutriscoreScore, imageUrl: imageUrl, nutriments: nutriments)
    }
}
