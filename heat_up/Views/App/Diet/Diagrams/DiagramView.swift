//
//  DiagramView.swift
//  heat_up
//
//  Created by marat orozaliev on 11/1/2025.
//

import SwiftUI

struct DiagramView: View {
    var body: some View {
        ScrollView {
            VStack {
                // First Row - Protein and Carbs Tracker
                HStack {
                    ProteinIntakeTrackerView(size:120)
                    
                    CarbsIntakeTrackerView(size:120)
                }
                
                // Second Row - Fats and Calories Tracker
                HStack {
                    FatsIntakeTrackerView(size:120)
                    
                    CaloriesIntakeTrackerView(size:120)
                }
            }
        }
        .navigationBarTitle("Nutritional Intake Tracker", displayMode: .inline)
    }
}

struct DiagramView_Previews: PreviewProvider {
    static var previews: some View {
        DiagramView()
    }
}
