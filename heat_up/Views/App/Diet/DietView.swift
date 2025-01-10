//
//  DietView.swift
//  heat_up
//
//  Created by marat orozaliev on 26/12/2024.
//

import SwiftUI

struct DietView: View {
    var body: some View {
        NavigationView {
            VStack {
                Spacer()

                NavigationLink(destination: MealFilterView()) {
                    Text("Find Meals")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .background(LinearGradient(
                            gradient: Gradient(colors: [Color.green.opacity(0.7), Color.green]),
                            startPoint: .leading,
                            endPoint: .trailing
                        ))
                        .cornerRadius(10)
                        .padding(.horizontal, 40)
                }

                Spacer()
            }
            .navigationTitle("Diet")
        }
    }
}

struct DietView_Previews: PreviewProvider {
    static var previews: some View {
        DietView()
    }
}
