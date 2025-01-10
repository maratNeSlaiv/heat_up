//
//  MealRecipeView.swift
//  heat_up
//
//  Created by marat orozaliev on 9/1/2025.
//

import SwiftUI

struct MealView: View {
    let meal: Meal
    
    var body: some View {
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
                    Text("Category: \(meal.strCategory)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text("Origin: \(meal.strArea)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                // Ingredients Table
                if let ingredients = meal.getIngredients() {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Ingredients:")
                            .font(.headline)
                        
                        // Table-like grid
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
                    }
                    .padding(.vertical)
                }else {
                    Text("No ingredients found")
                        .foregroundColor(.red)
                }
                
                // Instructions
                VStack(alignment: .leading, spacing: 8) {
                    Text("Instructions:")
                        .font(.headline)
                    
                    Text(meal.strInstructions)
                        .font(.body)
                        .multilineTextAlignment(.leading)
                }
                
                // YouTube Button
                Button(action: {
                    if let url = URL(string: meal.strYoutube) {
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
    }
}








//MARK: Sample case
let sampleMeal = Meal(
    strMeal: "Polskie Naleśniki (Polish Pancakes)",
    strCategory: "Dessert",
    strArea: "Polish",
    strInstructions: """
Add flour, eggs, milk, water, and salt in a large bowl then mix with a hand mixer until you have a smooth, lump-free batter.
At this point, mix in the butter or the vegetable oil. Alternatively, you can use them to grease the pan before frying each pancake.
Heat a non-stick pan over medium heat, then pour in the batter, swirling the pan to help it spread.
When the pancake starts pulling away a bit from the sides, and the top is no longer wet, flip it and cook shortly on the other side as well.
Transfer to a plate. Cook the remaining batter until all used up.
Serve warm, with the filling of your choice.
""",
    strMealThumb: "https://www.themealdb.com/images/media/meals/58bkyo1593350017.jpg",
    strYoutube: "https://www.youtube.com/watch?v=EZS4ev2crHc",
    strIngredients: [
        "Flour", "Eggs", "Milk", "Water", "Salt", "Sugar", "Butter", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil
    ],
    strMeasures: [
        "1 cup", "2", "1 cup", "3/4 cup", "Pinch", "1 tsp", "3 tbs", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil
    ]
)

struct MealView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MealView(meal: sampleMeal)
        }
    }
}
