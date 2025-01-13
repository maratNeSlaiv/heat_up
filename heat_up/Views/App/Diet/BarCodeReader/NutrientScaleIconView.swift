import SwiftUI

struct NutrientScaleIconView: View {
    var pipeWidth: CGFloat
    var value: CGFloat
    var numbers: [CGFloat] // User-defined numbers
    var colors: [Color]    // User-defined colors

    // Function to determine the color at a specific value
    private func colorForValue(_ value: CGFloat) -> Color {
        // Loop through the ranges defined by `numbers` and assign a color based on the value's position in those ranges
        for i in 0..<numbers.count-1 {
            if value >= numbers[i] && value < numbers[i + 1] {
                // Return the color corresponding to the range
                return colors[i]
            }
        }
        
        // If the value exceeds the last number in `numbers`, return the last color
        return colors.last!
    }

    
    private func getTriangleOffset(for value: CGFloat) -> CGFloat {
        // Calculate the proportional position of the value within the numbers
        let _ = numbers.last! - numbers.first!
        
        // Find the normalized position of the value in the scale
        var relativePosition: CGFloat = 0
        for i in 0..<numbers.count-1 {
            let lowerBound = numbers[i]
            let upperBound = numbers[i + 1]
            
            if value >= lowerBound && value <= upperBound {
                let segmentRange = upperBound - lowerBound
                relativePosition = (value - lowerBound) / segmentRange + CGFloat(i)
                break
            }
        }

        // If the value is greater than the largest number, point at the maximum position
        if value > numbers.last! {
            relativePosition = CGFloat(numbers.count - 1)
        }

        // Clamp the relative position to ensure it stays within the range
        relativePosition = max(0, min(relativePosition, CGFloat(numbers.count - 1)))
        
        // Calculate the corresponding position on the scale, mapped to the pipe width
        return (pipeWidth * relativePosition) / CGFloat(numbers.count - 1) - pipeWidth / 2
    }
    
    private func formattedNumber(_ number: CGFloat) -> String {
            if number == floor(number) {
                return String(format: "%.0f", number)  // Integer format
            } else {
                return String(format: "%.1f", number)  // One decimal point
            }
        }

    var body: some View {
        VStack {
            HStack {
                ForEach(0..<numbers.count, id: \.self) { index in
                    Text(formattedNumber(numbers[index]))
                        .font(.system(size: pipeWidth / 30))
                        .frame(width: pipeWidth / CGFloat(numbers.count), alignment: .center)
                }
            }
            .padding(.horizontal, pipeWidth / 6)

            HStack(spacing: pipeWidth / 200) {
                ForEach(0..<colors.count, id: \.self) { index in
                    Rectangle()
                        .fill(colors[index])
                        .frame(width: pipeWidth / CGFloat(colors.count), height: 7)
                }
            }
            .cornerRadius(5)
            .padding(.bottom, -pipeWidth / 15)

            // Triangle pointing to the specified value
            // Triangle pointing to the specified value
            NutrientScalePointingTriangle()
                .fill(colorForValue(value))
                .frame(width: pipeWidth / 30, height: pipeWidth / 30)
                .offset(x: getTriangleOffset(for: value), y: 5)
        }
    }
}

struct NutrientScalePointingTriangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY)) // Top of the triangle
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY)) // Bottom left
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY)) // Bottom right
        path.closeSubpath()
        return path
    }
}

struct NutrientScaleIconView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            // Example of user-defined numbers and colors
            NutrientScaleIconView(pipeWidth: 300, value: 25, numbers: [0, 25.1, 50, 75.6, 100], colors: [.green, .yellow, .orange, .red])
        }
    }
}
