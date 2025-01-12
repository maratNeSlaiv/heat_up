//
//  CarbsIntakeView.swift
//  heat_up
//
//  Created by marat orozaliev on 11/1/2025.
//

import SwiftUI

struct CarbsIntakeTrackerView: View {
    @State private var gramsConsumed = 0
    @State private var lastResetDate = Date()
    @State private var weight: Double = UserDefaults.standard.double(forKey: "CarbsTracker_userWeight") // Load weight from UserDefaults
    @State private var adjustmentValue = UserDefaults.standard.integer(forKey: "CarbsTracker_adjustmentValue") // Load adjustment value from UserDefaults
    
    let adjustmentOptions = [1, 3, 5, 10, 20]
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    var goalGrams: Int {
        let gramsPerKg = 3.0 // Example: 3g of carbs per kg of body weight
        let dynamicGoal = weight * gramsPerKg
        return max(Int(dynamicGoal), 100) // At least 100 grams to avoid very low goals
    }
    
    var progress: Double {
        return min(Double(gramsConsumed) / Double(goalGrams), 1.0)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Carbohydrate Intake")
                    .font(.title)
                    .padding()
                    .foregroundColor(.orange)

                ZStack {
                    Circle()
                        .stroke(lineWidth: 20)
                        .opacity(0.3)
                        .foregroundColor(.blue)

                    Circle()
                        .trim(from: 0.0, to: progress)
                        .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round))
                        .foregroundColor(.orange)
                        .rotationEffect(Angle(degrees: -90))
                        .animation(.easeInOut, value: progress)

                    VStack {
                        Text("\(gramsConsumed)/\(goalGrams) grams")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.blue)
                        if gramsConsumed >= goalGrams {
                            Text("Goal Reached!")
                                .font(.subheadline)
                                .foregroundColor(.orange)
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
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                    }
                    
                    Button(action: {
                        cycleAdjustmentValue()
                    }) {
                        Text("\(adjustmentValue)")
                            .font(.headline)
                            .padding()
                            .background(Color.purple)
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
                            .background(Color.orange)
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
        UserDefaults.standard.set(gramsConsumed, forKey: "CarbsTracker_gramsConsumedToday")
        UserDefaults.standard.set(lastResetDate, forKey: "CarbsTracker_lastResetDate")
    }
    
    func loadData() {
        if let savedGrams = UserDefaults.standard.value(forKey: "CarbsTracker_gramsConsumedToday") as? Int {
            gramsConsumed = savedGrams
        }
        if let savedDate = UserDefaults.standard.value(forKey: "CarbsTracker_lastResetDate") as? Date {
            lastResetDate = savedDate
        }
    }
    
    func loadWeight() {
        if let savedWeight = UserDefaults.standard.value(forKey: "CarbsTracker_userWeight") as? Double, savedWeight > 0 {
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
        UserDefaults.standard.set(adjustmentValue, forKey: "CarbsTracker_adjustmentValue")
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

struct CarbsIntakeTrackerView_Previews: PreviewProvider {
    static var previews: some View {
        CarbsIntakeTrackerView()
    }
}
