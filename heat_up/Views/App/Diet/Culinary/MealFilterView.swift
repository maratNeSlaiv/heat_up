import SwiftUI

struct MealFilterView: View {
    @State private var selectedFilter: FilterType = .area

    var body: some View {
        VStack {
            // Drop-down menu for filter selection
            HStack {
                Text("Filter by:")
                    .font(.headline)
                Picker("", selection: $selectedFilter) {
                    ForEach(FilterType.allCases, id: \.self) { filter in
                        Text(filter.displayName).tag(filter)
                    }
                }
                .pickerStyle(MenuPickerStyle())
            }
            .padding()

            // Dynamically switch between views
            if selectedFilter == .area {
                AreaCategoryView()
            } else {
                ProductCategoryView()
            }
        }
        .animation(.easeInOut, value: selectedFilter)
    }
}

enum FilterType: CaseIterable {
    case area
    case product
//    case ingredient

    var displayName: String {
        switch self {
        case .area:
            return "Country"
        case .product:
            return "Foog category"
        }
    }
}

// Preview
struct MealFilterView_Previews: PreviewProvider {
    static var previews: some View {
        MealFilterView()
    }
}
