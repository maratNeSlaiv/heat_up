//
//  MealModel.swift
//  heat_up
//
//  Created by marat orozaliev on 10/1/2025.
//

import Foundation

struct Meal: Decodable {
    let idMeal: String
    let strMeal: String
    let strMealThumb: String
    
    let strCategory: String?
    let strArea: String?
    let strInstructions: String?
    let strYoutube: String?
    
    let strIngredients: [String?]
    let strMeasures: [String?]

    func getIngredients() -> [String] {
        // Filter out empty or nil ingredients
        let filteredIngredients = strIngredients.compactMap { $0?.isEmpty == false ? $0 : nil }
        // Filter out empty or nil measures
        let filteredMeasures = strMeasures.compactMap { $0?.isEmpty == false ? $0 : nil }
        
        // Combine ingredients and measures, using a default string for missing measures
        var result: [String] = []
        for (index, ingredient) in filteredIngredients.enumerated() {
            let measure = index < filteredMeasures.count ? filteredMeasures[index] : "" // Use empty string if no measure
            result.append(measure.isEmpty ? ingredient : "\(measure) \(ingredient)")
        }
        
        return result
    }
}

func parseMeals(from jsonData: Data) -> [Meal]? {
    struct ServerResponse: Decodable {
        let meals: [RawMeal]
    }

    struct RawMeal: Decodable {
        let idMeal: String
        let strMeal: String
        let strMealThumb: String
        let strInstructions: String?
        let strCategory: String?
        let strArea: String?
        let strYoutube: String?
        
        // Ingredients and measures
        let strIngredient1: String?
        let strIngredient2: String?
        let strIngredient3: String?
        let strIngredient4: String?
        let strIngredient5: String?
        let strIngredient6: String?
        let strIngredient7: String?
        let strIngredient8: String?
        let strIngredient9: String?
        let strIngredient10: String?
        let strIngredient11: String?
        let strIngredient12: String?
        let strIngredient13: String?
        let strIngredient14: String?
        let strIngredient15: String?
        let strIngredient16: String?
        let strIngredient17: String?
        let strIngredient18: String?
        let strIngredient19: String?
        let strIngredient20: String?
        
        let strMeasure1: String?
        let strMeasure2: String?
        let strMeasure3: String?
        let strMeasure4: String?
        let strMeasure5: String?
        let strMeasure6: String?
        let strMeasure7: String?
        let strMeasure8: String?
        let strMeasure9: String?
        let strMeasure10: String?
        let strMeasure11: String?
        let strMeasure12: String?
        let strMeasure13: String?
        let strMeasure14: String?
        let strMeasure15: String?
        let strMeasure16: String?
        let strMeasure17: String?
        let strMeasure18: String?
        let strMeasure19: String?
        let strMeasure20: String?
    }

    do {
        let decodedResponse = try JSONDecoder().decode(ServerResponse.self, from: jsonData)
        return decodedResponse.meals.map { rawMeal in
            let ingredients = [
                rawMeal.strIngredient1, rawMeal.strIngredient2, rawMeal.strIngredient3, rawMeal.strIngredient4,
                rawMeal.strIngredient5, rawMeal.strIngredient6, rawMeal.strIngredient7, rawMeal.strIngredient8,
                rawMeal.strIngredient9, rawMeal.strIngredient10, rawMeal.strIngredient11, rawMeal.strIngredient12,
                rawMeal.strIngredient13, rawMeal.strIngredient14, rawMeal.strIngredient15, rawMeal.strIngredient16,
                rawMeal.strIngredient17, rawMeal.strIngredient18, rawMeal.strIngredient19, rawMeal.strIngredient20
            ].compactMap { $0?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false ? $0 : nil }

            let measures = [
                rawMeal.strMeasure1, rawMeal.strMeasure2, rawMeal.strMeasure3, rawMeal.strMeasure4,
                rawMeal.strMeasure5, rawMeal.strMeasure6, rawMeal.strMeasure7, rawMeal.strMeasure8,
                rawMeal.strMeasure9, rawMeal.strMeasure10, rawMeal.strMeasure11, rawMeal.strMeasure12,
                rawMeal.strMeasure13, rawMeal.strMeasure14, rawMeal.strMeasure15, rawMeal.strMeasure16,
                rawMeal.strMeasure17, rawMeal.strMeasure18, rawMeal.strMeasure19, rawMeal.strMeasure20
            ].compactMap { $0?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false ? $0 : nil }

            // Ensure that the number of ingredients and measures align
            let maxCount = max(ingredients.count, measures.count)
            let alignedIngredients = ingredients + Array(repeating: "", count: maxCount - ingredients.count) // Fills missing ingredients with empty strings
            let alignedMeasures = measures + Array(repeating: "", count: maxCount - measures.count) // Fills missing measures with empty strings

            let ingredientMeasurePairs = zip(alignedIngredients, alignedMeasures).map { ingredient, measure in
                (ingredient, measure)
            }

            return Meal(
                idMeal: rawMeal.idMeal,
                strMeal: rawMeal.strMeal,
                strMealThumb: rawMeal.strMealThumb,
                strCategory: rawMeal.strCategory,
                strArea: rawMeal.strArea,
                strInstructions: rawMeal.strInstructions,
                strYoutube: rawMeal.strYoutube,
                strIngredients: ingredientMeasurePairs.map { $0.0 }, // Only ingredients
                strMeasures: ingredientMeasurePairs.map { $0.1 } // Corresponding measures
            )
        }
    } catch {
        print("Failed to decode JSON: \(error)")
        return nil
    }
}
