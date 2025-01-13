//
//  CommodityModel.swift
//  heat_up
//
//  Created by marat orozaliev on 12/1/2025.
//

import Foundation
import AnyCodable

struct Commodity {
    let productName: String
    let nutriscoreGrade: String
    let nutriscoreScore: Double
    let imageUrl: String
    let nutriments: [String: Double]
}

struct CommodityResponse: Codable {
    let code: String
    let status: Int
    let status_verbose: String
    let product: CommodityData?
}

struct CommodityData: Codable {
    let product_name: String?
    let nutriscore_grade: String?
    let nutriscore_score: Double?
    let image_url: String?
    let nutriments: [String: Double]?

    enum CodingKeys: String, CodingKey {
        case product_name, nutriscore_grade, nutriscore_score, image_url, nutriments
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        // Decode basic properties
        product_name = try container.decodeIfPresent(String.self, forKey: .product_name)
        nutriscore_grade = try container.decodeIfPresent(String.self, forKey: .nutriscore_grade)
        nutriscore_score = try container.decodeIfPresent(Double.self, forKey: .nutriscore_score)
        image_url = try container.decodeIfPresent(String.self, forKey: .image_url)

        // Decode nutriments as [String: AnyCodable]
        if let nutriments = try container.decodeIfPresent([String: AnyCodable].self, forKey: .nutriments) {
            var nutrimentsWithDoubleValues: [String: Double] = [:]
            for (key, value) in nutriments {
                // Check if the value can be cast to Double
                if let doubleValue = value.value as? Double {
                    nutrimentsWithDoubleValues[key] = doubleValue
                } else {
                    nutrimentsWithDoubleValues[key] = 0.0 // Default to 0.0 if not a Double
                }
            }
            self.nutriments = nutrimentsWithDoubleValues
        } else {
            self.nutriments = nil
        }
    }
}
