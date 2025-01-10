//
//  UserProfileViewModel.swift
//  heat_up
//
//  Created by marat orozaliev on 26/12/2024.
//

import SwiftUI

class UserProfileViewModel: ObservableObject {
    @Published var userProfile: UserProfile?
    @Published var isLoading: Bool = false
    @Published var hasError: Bool = false

    func loadUserProfile() {
        isLoading = true
        hasError = false
        
        // Пример запроса к серверу
        let url = URL(string: "https://your-api-url.com/profile")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
                if let error = error {
                    self.hasError = true
                    print("Error loading profile: \(error)")
                    return
                }
                
                guard let data = data else {
                    self.hasError = true
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let profile = try decoder.decode(UserProfile.self, from: data)
                    self.userProfile = profile
                } catch {
                    self.hasError = true
                    print("Error decoding profile: \(error)")
                }
            }
        }.resume()
    }
    
    func reloadProfile() {
        loadUserProfile()
    }
}
