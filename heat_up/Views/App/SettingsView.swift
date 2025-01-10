//
//  SettingsView.swift
//  heat_up
//
//  Created by marat orozaliev on 10/1/2025.
//

import SwiftUI

struct SettingsView: View {
    @State private var weight: Double = UserDefaults.standard.double(forKey: "userWeight") // Load from UserDefaults
    @State private var showingAlert = false

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Personal Info")) {
                    HStack {
                        Text("Weight (kg)")
                        Spacer()
                        Text("\(Int(weight)) kg")
                            .foregroundColor(.gray)
                    }
                    Slider(value: $weight, in: 30...150, step: 1)
                        .onChange(of: weight) { newValue in
                            saveWeight(newValue)
                        }
                }
            }
            .navigationTitle("Settings")
        }
        .onAppear {
            loadWeight()
        }
    }
    
    /// Saves the weight to UserDefaults
    private func saveWeight(_ newValue: Double) {
        UserDefaults.standard.set(newValue, forKey: "userWeight")
        showingAlert = true
    }
    
    /// Loads the weight from UserDefaults
    private func loadWeight() {
        if let savedWeight = UserDefaults.standard.value(forKey: "userWeight") as? Double, savedWeight > 0 {
            weight = savedWeight
        } else {
            weight = 70 // Default weight of 70kg if not set
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
