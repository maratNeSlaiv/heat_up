import SwiftUI

struct FatsIntakeTrackerView: View {
    @State private var gramsConsumed = 0
    @State private var lastResetDate = Date()
    @State private var weight: Double = UserDefaults.standard.double(forKey: "userWeight") // Load weight from UserDefaults
    @State private var adjustmentValue = UserDefaults.standard.integer(forKey: "FatsTracker_adjustmentValue") // Load adjustment value from UserDefaults

    let adjustmentOptions = [1, 3, 5, 10, 20]
    
    let size: CGFloat // Customizable size parameter

    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    var goalGrams: Int {
        let gramsPerKg = 0.8 // Example: 0.8g of fats per kg of body weight
        let dynamicGoal = weight * gramsPerKg
        return max(Int(dynamicGoal), 40) // At least 40 grams to avoid very low goals
    }

    var progress: Double {
        return min(Double(gramsConsumed) / Double(goalGrams), 1.0)
    }
    
    var intakeColor: Color {
        let ratio = Double(gramsConsumed) / Double(goalGrams)
        
        switch ratio {
        case ..<0.4:
            return .gray // Very far from the goal
        case 0.4..<0.8:
            return Color.green.opacity(0.6) // Slight green for 60-80% of the goal
        case 0.8..<1.1:
            return .green // Strong green for 80-110% of the goal
        case 1.1..<1.25:
            return .orange // Moderately exceeding the goal
        case 1.25...:
            return .red // Significantly exceeding the goal
        default:
            return .gray
        }
    }


    var body: some View {
        NavigationView {
            VStack {
                Text("Fat Intake")
                    .font(.system(size: size * 0.13))

                ZStack {
                    Circle()
                        .stroke(lineWidth: size * 0.1)
                        .opacity(0.3)
                        .foregroundColor(intakeColor)

                    Circle()
                        .trim(from: 0.0, to: progress)
                        .stroke(style: StrokeStyle(lineWidth: size * 0.1, lineCap: .round, lineJoin: .round))
                        .foregroundColor(intakeColor)
                        .rotationEffect(Angle(degrees: -90))
                        .animation(.easeInOut, value: progress)

                    VStack(spacing: size * 0.02) {
                        Text("\(gramsConsumed)/\(goalGrams) grams")
                            .font(.system(size: size * 0.1))
                            .bold()
                        if gramsConsumed >= goalGrams {
                            Text("Goal Reached!")
                                .font(.system(size: size * 0.08))
                                .foregroundColor(.green)
                        }
                    }
                }
                .frame(width: size, height: size)
                .padding(size * 0.05)

                HStack(spacing: size * 0.05) {
                    Button(action: {
                        if gramsConsumed >= adjustmentValue {
                            gramsConsumed -= adjustmentValue
                            saveData()
                        }
                    }) {
                        Text("-")
                            .font(.system(size: size * 0.2))
                            .frame(width: size * 0.3, height: size * 0.3)
                            .background(Color.green)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                    }
                    
                    Button(action: {
                        cycleAdjustmentValue()
                    }) {
                        Text("\(adjustmentValue)")
                            .font(.system(size: size * 0.15))
                            .padding(size * 0.05)
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .clipShape(Capsule())
                    }
                    
                    Button(action: {
                        gramsConsumed += adjustmentValue
                        saveData()
                    }) {
                        Text("+")
                            .font(.system(size: size * 0.2))
                            .frame(width: size * 0.3, height: size * 0.3)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                    }
                }
                .padding(size * 0.05)
            }
            .onAppear(perform: onAppearActions)
        }
    }

    func onAppearActions() {
        checkReset()
        loadWeight()
        loadAdjustmentValue()
    }

    func checkReset() {
        let currentDate = dateFormatter.string(from: Date())
        let lastDate = dateFormatter.string(from: lastResetDate)
        
        if currentDate != lastDate {
            gramsConsumed = 0
            lastResetDate = Date()
            saveData()
        } else {
            loadData()
        }
    }

    func saveData() {
        UserDefaults.standard.set(gramsConsumed, forKey: "FatsTracker_gramsConsumedToday")
        UserDefaults.standard.set(lastResetDate, forKey: "FatsTracker_lastResetDate")
    }

    func loadData() {
        if let savedGrams = UserDefaults.standard.value(forKey: "FatsTracker_gramsConsumedToday") as? Int {
            gramsConsumed = savedGrams
        }
        if let savedDate = UserDefaults.standard.value(forKey: "FatsTracker_lastResetDate") as? Date {
            lastResetDate = savedDate
        }
    }

    func loadWeight() {
        if let savedWeight = UserDefaults.standard.value(forKey: "userWeight") as? Double, savedWeight > 0 {
            weight = savedWeight
        } else {
            weight = 70 // Default weight of 70kg if not set
        }
    }

    func loadAdjustmentValue() {
        // If no adjustment value is saved, set the default to 10
        if adjustmentValue == 0 {
            adjustmentValue = 10
            saveAdjustmentValue()
        }
    }

    func saveAdjustmentValue() {
        UserDefaults.standard.set(adjustmentValue, forKey: "FatsTracker_adjustmentValue")
    }

    func cycleAdjustmentValue() {
        // Cycle through adjustment options and update
        if let currentIndex = adjustmentOptions.firstIndex(of: adjustmentValue) {
            let nextIndex = (currentIndex + 1) % adjustmentOptions.count
            adjustmentValue = adjustmentOptions[nextIndex]
        } else {
            adjustmentValue = adjustmentOptions[0] // Default to the first option if invalid
        }
        saveAdjustmentValue()
    }
}

struct FatsIntakeTrackerView_Previews: PreviewProvider {
    static var previews: some View {
        FatsIntakeTrackerView(size: 150) // Pass custom size
    }
}
