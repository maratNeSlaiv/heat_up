import SwiftUI

struct WaterCupTrackerView: View {
    @State private var cupsDrunk = 0
    @State private var lastResetDate = Date()
    @State private var weight: Double = UserDefaults.standard.double(forKey: "userWeight") // Load weight from UserDefaults
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    var goalCups: Int {
        let mlPerKg = 30.0
        let cupMl = 250.0
        let dynamicGoal = (weight * mlPerKg) / cupMl
        return max(Int(dynamicGoal), 1) // At least 1 cup to avoid zero division
    }
    
    var progress: Double {
        return min(Double(cupsDrunk) / Double(goalCups), 1.0)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Drunk Water Cups")
                    .font(.title)
                    .padding()

                ZStack {
                    Circle()
                        .stroke(lineWidth: 20)
                        .opacity(0.3)
                        .foregroundColor(.blue)

                    Circle()
                        .trim(from: 0.0, to: progress)
                        .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round))
                        .foregroundColor(.blue)
                        .rotationEffect(Angle(degrees: -90))
                        .animation(.easeInOut, value: progress)

                    VStack {
                        Text("\(cupsDrunk)/\(goalCups) cups")
                            .font(.title2)
                            .bold()
                        if cupsDrunk >= goalCups {
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
                        if cupsDrunk > 0 {
                            cupsDrunk -= 1
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
                        cupsDrunk += 1
                        saveData()
                    }) {
                        Text("+")
                            .font(.largeTitle)
                            .padding()
                            .background(Color.green)
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
    }

    func checkReset() {
        let currentDate = dateFormatter.string(from: Date())
        let lastDate = dateFormatter.string(from: lastResetDate)
        
        if currentDate != lastDate {
            cupsDrunk = 0
            lastResetDate = Date()
            saveData()
        } else {
            loadData()
        }
    }
    
    func saveData() {
        UserDefaults.standard.set(cupsDrunk, forKey: "cupsDrunkToday")
        UserDefaults.standard.set(lastResetDate, forKey: "lastResetDate")
    }
    
    func loadData() {
        if let savedCups = UserDefaults.standard.value(forKey: "cupsDrunkToday") as? Int {
            cupsDrunk = savedCups
        }
        if let savedDate = UserDefaults.standard.value(forKey: "lastResetDate") as? Date {
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
}

struct WaterCupTrackerView_Previews: PreviewProvider {
    static var previews: some View {
        WaterCupTrackerView()
    }
}
