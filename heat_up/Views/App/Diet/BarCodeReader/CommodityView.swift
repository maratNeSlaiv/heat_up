import SwiftUI

struct CommodityView: View {
    var commodity: Commodity
    
    init(commodity: Commodity) {
        self.commodity = commodity
    }

    var body: some View {
        VStack {
            HStack {
                AsyncImage(url: URL(string: commodity.imageUrl)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView() // Show a loading indicator while the image is fetched
                    case .success(let image):
                        image.resizable()
                            .aspectRatio(contentMode: .fit) // Maintain aspect ratio
                            .frame(maxWidth: 100, maxHeight: 100) // Limit max dimensions
                    case .failure:
                        Text("Failed to load image") // Show an error message if loading fails
                    @unknown default:
                        Text("Unknown error")
                    }
                }
                
                VStack(alignment: .leading) {
                    Text(commodity.productName)
                        .font(.headline)
                    
                    if !commodity.nutriscoreGrade.isEmpty {
                        HStack {
                            Circle()
                                .fill(nutriscoreColor(for: commodity.nutriscoreGrade)) // Fill circle with the matching color
                                .frame(width: 20, height: 20) // Set size of the circle
                            Text(commodity.nutriscoreGrade)
                                .foregroundColor(nutriscoreColor(for: commodity.nutriscoreGrade))
                        }
                        Text(String(format: "Nutriscore: %.2f", commodity.nutriscoreScore))
                    } else {
                        Text("no nutriscore info")
                    }
                }
            }

            // Nutrients View
            if !commodity.nutriments.isEmpty {
                if let carbs = commodity.nutriments["carbohydrates_100g"] {
                    NutrientCarbsView(value: carbs)
                }
                if let fat = commodity.nutriments["fat_100g"] {
                    NutrientFatsView(value: fat)
                }
                if let proteins = commodity.nutriments["proteins_100g"] {
                    NutrientProteinView(value: proteins)
                }
                if let sodium = commodity.nutriments["sodium_100g"] {
                    NutrientSodiumView(value: sodium)
                }
                if let saturatedFat = commodity.nutriments["saturated-fat_100g"] {
                    NutrientSaturatedFatView(value: saturatedFat)
                }
                if let sugars = commodity.nutriments["sugars_100g"] {
                    NutrientSugarView(value: sugars)
                }
                if let fiber = commodity.nutriments["fiber_100g"] {
                    NutrientFiberView(value: fiber)
                }
                if let energy = commodity.nutriments["energy_100g"] {
                    NutrientEnergyView(value: energy)
                }
            }
        }
        .padding()
    }

    private func nutriscoreColor(for grade: String) -> Color {
        let normalizedGrade = grade.uppercased()
        switch normalizedGrade {
            case "A":
                return .green
            case "B":
                return .yellow
            case "C":
                return .orange
            case "D":
                return .red.opacity(0.7)
            case "E":
                return .red
            default:
                return .gray
        }
    }
}

#Preview {
    let commodity = Commodity(
        productName: "Tasty cheese",
        nutriscoreGrade: "d",
        nutriscoreScore: 15.0,
        imageUrl: "https://images.openfoodfacts.org/images/products/930/063/353/9047/front_en.3.400.jpg",
        nutriments: [
            "carbohydrates_100g": 2.5,
            "fat_100g": 21.5,
            "proteins_100g": 14.8,
            "sodium_100g": 0.65,
            "saturated-fat_100g": 14.2,
            "sugars_100g": 2.5,
//            "fiber_100g": 3.0,
            "energy_100g": 1060
        ]
    )
    
    CommodityView(commodity: commodity)
}
