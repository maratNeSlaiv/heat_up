import SwiftUI

struct CaloriesIntakeTrackerView: View {
    @State private var gramsConsumed = 0
    @State private var lastResetDate = Date()
    @State private var weight: Double = UserDefaults.standard.double(forKey: "userWeight") // Load weight from UserDefaults
    @State private var adjustmentValue = UserDefaults.standard.integer(forKey: "CaloriesTracker_adjustmentValue") // Load adjustment value from UserDefaults

    let adjustmentOptions = [50, 100, 200, 300, 500]
    let size: CGFloat // Customizable size parameter

    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    var goalCalories: Int {
        let caloriesPerKg = 30.0 // Example: 30 calories per kg of body weight
        let dynamicGoal = weight * caloriesPerKg
        return max(Int(dynamicGoal), 1500) // At least 1500 calories to avoid very low goals
    }

    var progress: Double {
        return min(Double(gramsConsumed) / Double(goalCalories), 1.0)
    }
    
    var intakeColor: Color {
        let ratio = Double(gramsConsumed) / Double(goalCalories)
        
        switch ratio {
        case ..<0.6:
            return .gray
        case 0.6..<0.75, 1.25...:
            return .red
        case 0.75..<0.9, 1.1..<1.25:
            return .orange
        case 0.9..<1.1:
            return .green
        default:
            return .gray
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                Text("Calories Intake")
                    .font(.system(size: size * 0.13)) // Adjust title font size

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
                        Text("\(gramsConsumed)/\(goalCalories) calories")
                            .font(.system(size: size * 0.1))
                            .bold()
                        if gramsConsumed >= goalCalories {
                            Text("Goal Reached!")
                                .font(.system(size: size * 0.08))
                                .foregroundColor(.green)
                        }
                    }
                }
                .frame(width: size, height: size)
                .padding(size * 0.05)

                HStack(spacing: size * 0.05) { // Adjust button spacing
                    Button(action: {
                        if gramsConsumed >= adjustmentValue {
                            gramsConsumed -= adjustmentValue
                            saveData()
                        }
                    }) {
                        Text("-")
                            .font(.system(size: size * 0.2)) // Adjust font size
                            .frame(width: size * 0.3, height: size * 0.3) // Adjust button size
                            .background(Color.green)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                    }

                    Button(action: {
                        cycleAdjustmentValue()
                    }) {
                        Text("\(adjustmentValue)")
                            .font(.system(size: size * 0.1)) // Adjust font size
                            .padding(size * 0.05) // Adjust internal padding
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .clipShape(Capsule())
                    }

                    Button(action: {
                        gramsConsumed += adjustmentValue
                        saveData()
                    }) {
                        Text("+")
                            .font(.system(size: size * 0.2)) // Adjust font size
                            .frame(width: size * 0.3, height: size * 0.3) // Adjust button size
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                    }
                }
                .padding(size * 0.05) // Adjust HStack padding
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
        UserDefaults.standard.set(gramsConsumed, forKey: "CaloriesTracker_gramsConsumedToday")
        UserDefaults.standard.set(lastResetDate, forKey: "CaloriesTracker_lastResetDate")
    }

    func loadData() {
        if let savedGrams = UserDefaults.standard.value(forKey: "CaloriesTracker_gramsConsumedToday") as? Int {
            gramsConsumed = savedGrams
        }
        if let savedDate = UserDefaults.standard.value(forKey: "CaloriesTracker_lastResetDate") as? Date {
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
        if adjustmentValue == 0 {
            adjustmentValue = 100
            saveAdjustmentValue()
        }
    }

    func saveAdjustmentValue() {
        UserDefaults.standard.set(adjustmentValue, forKey: "CaloriesTracker_adjustmentValue")
    }

    func cycleAdjustmentValue() {
        if let currentIndex = adjustmentOptions.firstIndex(of: adjustmentValue) {
            let nextIndex = (currentIndex + 1) % adjustmentOptions.count
            adjustmentValue = adjustmentOptions[nextIndex]
        } else {
            adjustmentValue = adjustmentOptions[0]
        }
        saveAdjustmentValue()
    }
}

struct CaloriesIntakeTrackerView_Previews: PreviewProvider {
    static var previews: some View {
        CaloriesIntakeTrackerView(size: 200) // Pass custom size
    }
}
