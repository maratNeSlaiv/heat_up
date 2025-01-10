//
//  MealDisplayView.swift
//  heat_up
//
//  Created by marat orozaliev on 10/1/2025.
//

import SwiftUI

struct MealIconView: View {
    let meal: Meal
    var size: CGFloat = 175 // Default size
    
    var body: some View {
        NavigationLink(destination: MealView(meal: meal)) {
            VStack {
                // Name of the meal with dynamic font size
                Text(meal.strMeal)
                    .font(.system(size: size * 0.09)) // Scale font size based on 'size'
                    .padding(.top, 10)
                    .foregroundColor(.white)
                    .shadow(radius: 5)
                
                // Image of the meal
                AsyncImage(url: URL(string: meal.strMealThumb)) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: size, height: size)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.white, lineWidth: 4)
                        )
                        .shadow(radius: 10)
                } placeholder: {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .frame(width: size, height: size)
                }
                
                Spacer()
            }
            .frame(width: size * 1.05, height: size * 1.2)
            .background(Color.black.opacity(0.7))
            .cornerRadius(15)
            .padding()
        }
        .buttonStyle(PlainButtonStyle()) // Prevents default button styling
    }
}

struct MealDisplayView: View {
    // ViewModel instance
    @StateObject private var viewModel = MealViewModel()
    
    let columns = [
        GridItem(.flexible()), // Column 1
        GridItem(.flexible())  // Column 2
    ]
    
    var body: some View {
        NavigationView {
            VStack {
                // If there's an error message, show it
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
                
                // If meals are loaded, display them using MealIconView in a grid
                if !viewModel.meals.isEmpty {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 20) {
                            ForEach(viewModel.meals, id: \.strMeal) { meal in
                                MealIconView(meal: meal) // Use MealIconView for each meal
                            }
                        }
                        .padding()
                    }
                } else {
                    Text("Loading meals...")
                        .foregroundColor(.gray)
                }
            }
            .onAppear {
                // Trigger fetch on view appearance
                viewModel.fetchMeals()
            }
            .navigationTitle("Meals")
        }
    }
}

struct MealDisplayView_Previews: PreviewProvider {
    static var previews: some View {
        MealDisplayView()
            .previewDevice("iPhone 14")
    }
}
