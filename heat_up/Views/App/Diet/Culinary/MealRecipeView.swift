//
//  MealRecipeView.swift
//  heat_up
//
//  Created by marat orozaliev on 9/1/2025.
//

import SwiftUI

struct MealView: View {
    @StateObject private var viewModel = MealViewModel()
    let idMeal: String
    
    var body: some View {
        Group {
            if let meal = viewModel.meals.first {
                // Display meal details
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        Text(meal.strMeal)
                            .font(.title)
                            .fontWeight(.bold)
                        
                        // Meal Image
                        AsyncImage(url: URL(string: meal.strMealThumb)) { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .cornerRadius(10)
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(height: 340)
                        .padding()
                        
                        // Meal Info
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Category: \(meal.strCategory ?? "Category is not loaded")")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            Text("Origin: \(meal.strArea ?? "Origin is not loaded")")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        
                        // Ingredients Table
                        let ingredients = meal.getIngredients()

                        VStack(alignment: .leading, spacing: 8) {
                            if !ingredients.isEmpty {
                                Text("Ingredients:")
                                    .font(.headline)
                                
                                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                                    ForEach(ingredients, id: \.self) { ingredient in
                                        Text(ingredient)
                                            .padding(.vertical, 4)
                                            .padding(.horizontal, 8)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .background(Color(UIColor.secondarySystemBackground))
                                            .cornerRadius(8)
                                    }
                                }
                            } else {
                                Text("No ingredients found")
                                    .foregroundColor(.red)
                            }
                        }
                        .padding(.vertical)
                        
                        // Instructions
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Instructions:")
                                .font(.headline)
                            
                            Text(meal.strInstructions ?? "Instruction failed to load")
                                .font(.body)
                                .multilineTextAlignment(.leading)
                        }
                        
                        // YouTube Button
                        Button(action: {
                            if let url = URL(string: meal.strYoutube ?? "Youtube link failed to load") {
                                UIApplication.shared.open(url)
                            }
                        }) {
                            HStack {
                                Image(systemName: "play.circle")
                                Text("Watch on YouTube")
                                    .fontWeight(.bold)
                            }
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.red)
                            .cornerRadius(8)
                        }
                    }
                    .padding()
                }
            } else if let errorMessage = viewModel.errorMessage {
                // Show error message if any
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            } else {
                // Show loading indicator
                ProgressView()
                    .onAppear {
                        viewModel.lookupMealById(id: idMeal)
                    }
            }
        }
    }
}

struct MealView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MealView(idMeal: "52995")
        }
    }
}
