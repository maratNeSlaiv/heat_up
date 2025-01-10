//
//  MealViewModel.swift
//  heat_up
//
//  Created by marat orozaliev on 10/1/2025.
//

import Foundation

class MealViewModel: ObservableObject {
    @Published var meals: [Meal] = []
    @Published var errorMessage: String?
    
    private let baseUrl = "https://www.themealdb.com/api/json/v1/1/"
    
    // Function to fetch meals by category
    func fetchMealsByCategory(category: String) {
        let urlString = "\(baseUrl)filter.php?c=\(category)"
        fetchData(from: urlString)
    }
    
    // Function to fetch meals by area
    func fetchMealsByArea(area: String) {
        let urlString = "\(baseUrl)filter.php?a=\(area)"
        fetchData(from: urlString)
    }
    
    // Function to fetch meals by first letter
    func fetchMealsByLetter(letter: String) {
        let urlString = "\(baseUrl)search.php?f=\(letter)"
        fetchData(from: urlString)
    }
    
    // Function to search meal by name
    func fetchMealByName(name: String) {
        let urlString = "\(baseUrl)search.php?s=\(name)"
        fetchData(from: urlString)
    }
    
    // Function to lookup full meal details by id
    func fetchMealById(id: String) {
        let urlString = "\(baseUrl)lookup.php?i=\(id)"
        fetchData(from: urlString)
    }
    
    // Function to fetch a random meal
    func fetchRandomMeal() {
        let urlString = "\(baseUrl)random.php"
        fetchData(from: urlString)
    }
    
    // General function to fetch data
    private func fetchData(from urlString: String) {
        guard let url = URL(string: urlString) else {
            self.errorMessage = "Invalid URL"
            return
        }
        
        let session = URLSession.shared
        session.dataTask(with: url) { [weak self] data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self?.errorMessage = "Failed to fetch data: \(error.localizedDescription)"
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    self?.errorMessage = "No data received"
                }
                return
            }
            
            // Parse the JSON response
            if let meals = parseMeals(from: data) {
                DispatchQueue.main.async {
                    self?.meals = meals
                }
            } else {
                DispatchQueue.main.async {
                    self?.errorMessage = "Failed to parse meals"
                }
            }
        }.resume()
    }
}
