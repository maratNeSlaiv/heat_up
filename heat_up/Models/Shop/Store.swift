//
//  Store.swift
//  heat_up
//
//  Created by marat orozaliev on 26/12/2024.
//

import Foundation

// Класс для представления магазина
class Store: Decodable {
    let name: String
    let category: String
    let logoUrl: String
    let rating: Double
    let location: String
    let workingHours: String
    
    // Инициализатор для инициализации атрибутов
    init(name: String, category: String, logoUrl: String, rating: Double, location: String, workingHours: String) {
        self.name = name
        self.category = category
        self.logoUrl = logoUrl
        self.rating = rating
        self.location = location
        self.workingHours = workingHours
    }
}
