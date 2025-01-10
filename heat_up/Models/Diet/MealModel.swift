//
//  MealModel.swift
//  heat_up
//
//  Created by marat orozaliev on 10/1/2025.
//
import Foundation

struct Meal: Decodable{
    let strMeal: String
    let strCategory: String
    let strArea: String
    let strInstructions: String
    let strMealThumb: String
    let strYoutube: String
    let strIngredients: [String?]
    let strMeasures: [String?]
    
    func getIngredients() -> [String]? {
        let filteredIngredients = strIngredients.compactMap { $0?.isEmpty == false ? $0 : nil }
        
        let filteredMeasures = strMeasures.compactMap { $0?.isEmpty == false ? $0 : nil }
        
        // Ensure both arrays have the same length after filtering
        guard filteredIngredients.count == filteredMeasures.count else { return nil }
        
        // Combine ingredients and measures into formatted strings
        var result: [String] = []
        for (ingredient, measure) in zip(filteredIngredients, filteredMeasures) {
            result.append("\(measure) \(ingredient)")
        }
        
        // Return the result, or nil if the result is empty
        return result.isEmpty ? nil : result
    }
}

func parseMealsWithDescription(from jsonData: Data) -> [Meal]? {
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
            
            return Meal(
                strMeal: rawMeal.strMeal,
                strCategory: rawMeal.strCategory,
                strArea: rawMeal.strArea,
                strInstructions: rawMeal.strInstructions,
                strMealThumb: rawMeal.strMealThumb,
                strYoutube: rawMeal.strYoutube,
                strIngredients: ingredients,
                strMeasures: measures
            )
        }
    } catch {
        print("Failed to decode JSON: \(error)")
        return nil
    }
}
