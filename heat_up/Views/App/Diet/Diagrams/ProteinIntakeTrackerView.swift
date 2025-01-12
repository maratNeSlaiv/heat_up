import SwiftUI

struct ProteinIntakeTrackerView: View {
    @State private var gramsConsumed = 0
    @State private var lastResetDate = Date()
    @State private var weight: Double = UserDefaults.standard.double(forKey: "ProteinTracker_userWeight") // Load weight from UserDefaults
    @State private var adjustmentValue = UserDefaults.standard.integer(forKey: "ProteinTracker_adjustmentValue") // Load adjustment value from UserDefaults
    
    let adjustmentOptions = [1, 3, 5, 10, 20]
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    var goalGrams: Int {
        let gramsPerKg = 1.5 // Example: 1.5g of protein per kg of body weight
        let dynamicGoal = weight * gramsPerKg
        return max(Int(dynamicGoal), 50) // At least 50 grams to avoid very low goals
    }
    
    var progress: Double {
        return min(Double(gramsConsumed) / Double(goalGrams), 1.0)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Protein Intake")
                    .font(.title)
                    .padding()

                ZStack {
                    Circle()
                        .stroke(lineWidth: 20)
                        .opacity(0.3)
                        .foregroundColor(.green)

                    Circle()
                        .trim(from: 0.0, to: progress)
                        .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round))
                        .foregroundColor(.green)
                        .rotationEffect(Angle(degrees: -90))
                        .animation(.easeInOut, value: progress)

                    VStack {
                        Text("\(gramsConsumed)/\(goalGrams) grams")
                            .font(.title2)
                            .bold()
                        if gramsConsumed >= goalGrams {
                            Text("Goal Reached!")
                                .font(.subheadline)
                                .foregroundColor(.green)
                        }
                    }
                }
                .frame(width: 200, height: 200)
                .padding()

                HStack {
                    Button(action: {
                        if gramsConsumed >= adjustmentValue {
                            gramsConsumed -= adjustmentValue
                            saveData()
                        }
                    }) {
                        Text("-")
                            .font(.largeTitle)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                    }
                    
                    Button(action: {
                        cycleAdjustmentValue()
                    }) {
                        Text("\(adjustmentValue)")
                            .font(.headline)
                            .padding()
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .clipShape(Capsule())
                            .padding(.horizontal, 10)
                    }
                    
                    Button(action: {
                        gramsConsumed += adjustmentValue
                        saveData()
                    }) {
                        Text("+")
                            .font(.largeTitle)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                    }
                }
                .padding()
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
        UserDefaults.standard.set(gramsConsumed, forKey: "ProteinTracker_gramsConsumedToday")
        UserDefaults.standard.set(lastResetDate, forKey: "ProteinTracker_lastResetDate")
    }
    
    func loadData() {
        if let savedGrams = UserDefaults.standard.value(forKey: "ProteinTracker_gramsConsumedToday") as? Int {
            gramsConsumed = savedGrams
        }
        if let savedDate = UserDefaults.standard.value(forKey: "ProteinTracker_lastResetDate") as? Date {
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
        UserDefaults.standard.set(adjustmentValue, forKey: "ProteinTracker_adjustmentValue")
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

struct ProteinIntakeTrackerView_Previews: PreviewProvider {
    static var previews: some View {
        ProteinIntakeTrackerView()
    }
}
