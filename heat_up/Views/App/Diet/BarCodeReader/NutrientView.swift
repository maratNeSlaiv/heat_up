import SwiftUI

struct NutrientView: View {
    var nutrient: String
    var value: Double
    var scale: [CGFloat] // Values defining the thresholds for color ranges
    var colors: [Color] // List of colors corresponding to the scale
    var descriptions: [String] // Descriptions for each color range
    var iconName: String
    var unit: String = "g" // Default to 'g' (grams)

    @State private var isExpanded: Bool = false // State to track expansion

    // Function to calculate the color based on the value
    private func calculateColor() -> Color {
        for i in 0..<scale.count-1 {
            if value >= scale[i] && value < scale[i + 1] {
                return colors[i]
            }
        }
        // Return the last color if the value exceeds the last scale value
        return colors.last!
    }

    // Function to get the description based on the value
    private func getDescription() -> String {
        for i in 0..<scale.count-1 {
            if value >= scale[i] && value < scale[i + 1] {
                return descriptions[i]
            }
        }
        // Return the last description if the value exceeds the last scale value
        return descriptions.last!
    }

    var body: some View {
        VStack {
            HStack {
                // Left Icon
                Image(iconName)
                    .resizable()
                    .frame(width: 40, height: 40)

                VStack(alignment: .leading) {
                    Text(nutrient)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(getDescription())
                        .font(.subheadline)
                        .foregroundColor(calculateColor().opacity(0.7))
                }

                Spacer()

                // Right Value
                HStack {
                    Text("\(value, specifier: "%.1f") \(unit)")
                        .font(.title3)
                        .foregroundColor(calculateColor())

                    Circle()
                        .fill(calculateColor())
                        .frame(width: 20, height: 20)
                }

                // Arrow button
                Button(action: {
                    withAnimation {
                        isExpanded.toggle()
                    }
                }) {
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.gray)
                        .frame(width: 20, height: 20)  // Fixed size
                        .padding(.leading, 8)
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 5)

            // Expandable view
            if isExpanded {
                NutrientScaleIconView(pipeWidth: 280, value: value, numbers: scale, colors: colors)
            }
        }
    }
}

//MARK: Protein
struct NutrientProteinView: View {
    var value: Double // Protein value

    var body: some View {
        NutrientView(
            nutrient: "Protein",
            value: value,
            scale: [0, 4, 8, 15, 30], // Protein-specific ranges
            colors: [.yellow, .green.opacity(0.5), .green, .blue], // Protein-specific colors
            descriptions: ["Some protein", "Moderate protein", "Good protein", "High protein"], // Protein-specific descriptions
            iconName: "protein_icon" // Protein-specific icon
        )
    }
}

//MARK: Carbs
struct NutrientCarbsView: View {
    var value: Double // Protein value

    var body: some View {
        NutrientView(
            nutrient: "Carbs",
            value: value,
            scale: [0, 10, 30, 50, 80], // Protein-specific ranges
            colors: [.green, .yellow, .orange, .red], // Protein-specific colors
            descriptions: ["Low carbs", "Moderate carbs", "High carbs", "Very high carbs"], // Protein-specific descriptions
            iconName: "carbs_icon" // Protein-specific icon
        )
    }
}

//MARK: Fats
struct NutrientFatsView: View {
    var value: Double // Protein value

    var body: some View {
        NutrientView(
            nutrient: "Fats",
            value: value,
            scale: [0, 3, 17, 35, 50], // Protein-specific ranges
            colors: [.green, .yellow, .orange, .red], // Protein-specific colors
            descriptions: ["Low fat", "Moderate", "High fat", "Very high fat"], // Protein-specific descriptions
            iconName: "fats_icon" // Protein-specific icon
        )
    }
}

//MARK: Fiber
struct NutrientFiberView: View {
    var value: Double // Protein value

    var body: some View {
        NutrientView(
            nutrient: "Fiber",
            value: value,
            scale: [0, 1, 5, 10, 20], // Protein-specific ranges
            colors: [.yellow, .green.opacity(0.6), .green, .blue], // Protein-specific colors
            descriptions: ["Some fiber", "Moderate fiber", "Good fiber", "High fiber"], // Protein-specific descriptions
            iconName: "fiber_icon" // Protein-specific icon
        )
    }
}

//MARK: Sugar
struct NutrientSugarView: View {
    var value: Double // Protein value

    var body: some View {
        NutrientView(
            nutrient: "Sugar",
            value: value,
            scale: [0, 5, 15, 30, 50], // Protein-specific ranges
            colors: [.green, .yellow, .orange, .red], // Protein-specific colors
            descriptions: ["Low sugar", "Moderate sugar", "High sugar", "Very high sugar"], // Protein-specific descriptions
            iconName: "sugar_icon" // Protein-specific icon
        )
    }
}
//MARK: Sodium
struct NutrientSodiumView: View {
    var value: Double // Protein value
    
    var body: some View {
        NutrientView(
            nutrient: "Sodium",
            value: value,
            scale: [0, 0.2, 0.4, 0.8, 1.2], // Protein-specific ranges
            colors: [.green, .yellow, .orange, .red], // Protein-specific colors
            descriptions: ["Low sodium", "Moderate sodium", "High sodium", "Very high sodium"], // Protein-specific descriptions
            iconName: "sodium_icon", // Protein-specific icon
            unit:"mg"
        )
    }
}

//MARK: Energy
struct NutrientEnergyView: View {
    var value: Double // Protein value

    var body: some View {
        NutrientView(
            nutrient: "Energy",
            value: value,
            scale: [0, 418, 1046, 2092, 3765], // Protein-specific ranges
            colors: [.green, .yellow, .orange, .red], // Protein-specific colors
            descriptions: ["Low callories", "Moderate callories", "High callories", "Very high callories"], // Protein-specific descriptions
            iconName: "energy_icon", // Protein-specific icon
            unit:"kj"
        )
    }
}

//MARK: SaturatedFat
struct NutrientSaturatedFatView: View {
    var value: Double // Protein value

    var body: some View {
        NutrientView(
            nutrient: "Saturated fats",
            value: value,
            scale: [0, 1, 5, 10, 20], // Protein-specific ranges
            colors: [.green, .yellow, .orange, .red], // Protein-specific colors
            descriptions: ["Low saturated fat", "Moderate saturated fat", "High saturated fat", "Very high saturated fat"], // Protein-specific descriptions
            iconName: "saturatedFat_icon" // Protein-specific icon
        )
    }
}

struct AllNutrientsView: View{
    var body: some View {
        ScrollView {
            VStack {
                NutrientProteinView(value: 25)
                
                NutrientCarbsView(value: 20)
                
                NutrientFatsView(value: 25)
                
                NutrientFiberView(value: 25)
                
                NutrientEnergyView(value: 1500)
                
                NutrientSaturatedFatView(value: 25)
                
                NutrientSugarView(value: 25)
                
                NutrientSodiumView(value: 25)
            }
        }
    }
}

#Preview{
    AllNutrientsView()
}
