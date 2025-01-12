//
//  CommodityModel.swift
//  heat_up
//
//  Created by marat orozaliev on 12/1/2025.
//

import Foundation

struct Commodity {
    let nutriscoreGrade: String
    let nutriscoreScore: Double
    let imageUrl: String
    let nutriments: [String: String]
}

struct CommodityResponse: Codable {
    let code: String
    let status: Int
    let status_verbose: String
    let product: CommodityData?
}

struct CommodityData: Codable {
    let nutriscore_grade: String?
    let nutriscore_score: Double?
    let image_url: String?
    let nutriments: [String: CommodityNutrientValue]?  // Updated type to NutrientValue
    
    // Optional: other fields if necessary
}

enum CommodityNutrientValue: Codable {
    case string(String)
    case number(Double)
    
    // Decoder for flexible type handling
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        // Try to decode as a String
        if let stringValue = try? container.decode(String.self) {
            self = .string(stringValue)
        }
        // Try to decode as a Double (e.g., for numeric values)
        else if let numberValue = try? container.decode(Double.self) {
            self = .number(numberValue)
        } else {
            throw DecodingError.typeMismatch(CommodityNutrientValue.self, DecodingError.Context(
                codingPath: decoder.codingPath,
                debugDescription: "Expected String or Number but found something else."
            ))
        }
    }
    
    // Method to extract the value as a String, regardless of its original type
    func getValue() -> String {
        switch self {
        case .string(let value):
            return value
        case .number(let value):
            return String(value)
        }
    }
}
