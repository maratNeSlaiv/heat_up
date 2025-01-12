import SwiftUI

struct NutrientView: View {
    var nutrient: String
    var value: Double
    var scale: [Double] // Values defining the thresholds for color ranges
    var colors: [Color] // List of colors corresponding to the scale
    var descriptions: [String] // Descriptions for each color range
    var iconName: String

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
        HStack {
            // Left Icon
            Image(systemName: iconName)
                .resizable()
                .frame(width: 30, height: 30)
                .foregroundColor(calculateColor())

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
                Text("\(value, specifier: "%.1f")g")
                    .font(.title3)
                    .foregroundColor(calculateColor())

                Circle()
                    .fill(calculateColor())
                    .frame(width: 20, height: 20)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

struct NutrientView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            NutrientView(
                nutrient: "Protein",
                value: 10,
                scale: [0, 20, 50, 100],
                colors: [.green.opacity(0.6), .green, .blue],
                descriptions: ["Some protein", "Moderate protein", "High protein"],
                iconName: "leaf.fill"
            )
        }
        .padding()
    }
}
