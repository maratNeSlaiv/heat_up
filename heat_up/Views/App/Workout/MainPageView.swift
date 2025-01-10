//
//  MainPageView.swift
//  heat_up
//
//  Created by marat orozaliev on 26/12/2024.
//

import SwiftUI

// Шаг 1: Перечисление для экранов
enum AppScreen: String, CaseIterable {
    case workout = "Workout"
    case diet = "Diet"
    case shop = "Shop"
    
    // Иконки для каждого экрана
    var icon: String {
        switch self {
        case .workout: return "figure.strengthtraining.traditional"
        case .diet: return "leaf"
        case .shop: return "cart"
        }
    }
}

// Шаг 2: Главное окно приложения
struct MainPageView: View {
    @State private var currentScreen: AppScreen = .workout // По умолчанию Workout
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                // Динамическая смена контента в зависимости от текущего экрана
                Group {
                    switch currentScreen {
                    case .workout:
                        WorkoutView()
                    case .diet:
                        DietView()
                    case .shop:
                        DietView()
                    }
                }
                .transition(.opacity) // Плавный переход между окнами
                .animation(.easeInOut, value: currentScreen)
                Spacer() // Разделяет контент от панели снизу
            }
            
            // Панель переключения между экранами
            HStack {
                ForEach(AppScreen.allCases, id: \.self) { screen in
                    Button(action: {
                        if currentScreen != screen { // Нельзя нажать на активный экран
                            currentScreen = screen
                        }
                    }) {
                        VStack {
                            Image(systemName: screen.icon)
                                .font(.title)
                                .foregroundColor(currentScreen == screen ? .blue : .gray)
                            Text(screen.rawValue)
                                .font(.caption)
                                .foregroundColor(currentScreen == screen ? .blue : .gray)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                    }
                    .disabled(currentScreen == screen) // Блокировка кнопки для активного экрана
                }
            }
            .background(Color(UIColor.systemGroupedBackground)) // Фон панели
            .frame(height: 80) // Высота панели
            .zIndex(1) // Устанавливаем приоритет слоя выше, чем у основного контента
        }
        .edgesIgnoringSafeArea(.bottom) // Панель всегда отображается на уровне края экрана
    }
}

// Шаг 6: Превью
struct MainPageView_Preview: PreviewProvider {
    static var previews: some View {
        MainPageView()
    }
}
