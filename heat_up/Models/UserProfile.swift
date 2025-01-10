//
//  UserProfile.swift
//  heat_up
//
//  Created by marat orozaliev on 26/12/2024.
//

struct UserProfile: Identifiable, Codable {
    var id: String
    var name: String?
    var profilePicture: String?
    var dateOfBirth: String?
    var gender: String?
    var location: String?
    var height: Double?
    var weight: Double?
    var bodyFatPercentage: Double?
    var bodyType: String?
    var bmi: Double?
    var goalType: String?
    var targetWeight: Double?
    var dailyCalories: Double?
    var activityLevel: String?
    var preferredWorkouts: [String]?
    var workoutTimePreference: String?
    var experienceLevel: String?
}
