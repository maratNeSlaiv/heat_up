//
//  AddressInformation.swift
//  heat_up
//
//  Created by marat orozaliev on 27/12/2024.
//

import Foundation

struct AddressInformation: Identifiable {
    var id = UUID() // Unique ID for each address
    var address: String
    var floor: String
    var doorNumber: String
    var buildingName: String?
    var additionalInfo: String?
    var buildingType: BuildingType
}

enum BuildingType {
    case house, apartment, office, other
}
