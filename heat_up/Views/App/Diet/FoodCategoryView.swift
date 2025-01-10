import SwiftUI

struct ProductCategoryScrollView: View {
    let categories = [
        "starter",
        "chicken",
        "desserts",
        "vegan",
        "beef",
        "sides",
        "vegetarian",
        "seafood",
        "pork",
        "lamb",
        "breakfast",
        "miscellaneous",
        "pasta",
        "goat"
    ]

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    ForEach(categories, id: \.self) { category in
                        NavigationLink(destination: CategoryDetailView(categoryName: category.capitalized)) {
                            ProductCategoryIcon(
                                categoryName: category.capitalized,
                                imageName: "food_category_\(category)",
                                iconSize: 200 // Укажите желаемый размер иконки здесь
                            )
                        }
                        .buttonStyle(ZoomButtonStyle())
                    }
                }
                .padding()
            }
            .navigationTitle("Categories")
        }
    }
}


struct ProductCategoryScrollView_Previews: PreviewProvider {
    static var previews: some View {
        ProductCategoryScrollView()
    }
}

// MARK: - ProductCategoryIcon
struct ProductCategoryIcon: View {
    let categoryName: String
    let imageName: String
    let iconSize: CGFloat // Новый параметр для регулировки размера иконки
    
    var body: some View {
        VStack(spacing: 8) {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: iconSize, height: iconSize) // Используем переданный размер
                .clipShape(Circle())
                .shadow(radius: 4)
            
            Text(categoryName)
                .font(.title3)
                .fontWeight(.medium)
                .foregroundColor(.primary)
        }
        .padding()
    }
}

// MARK: - CategoryDetailView
struct CategoryDetailView: View {
    let categoryName: String
    
    var body: some View {
        VStack {
            Text(categoryName)
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
            
            Spacer()
        }
        .navigationTitle(categoryName) // Заголовок страницы
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - ZoomButtonStyle
struct ZoomButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 1.1 : 1.0) // Зум при нажатии
            .animation(.spring(response: 0.3, dampingFraction: 0.5), value: configuration.isPressed)
    }
}
