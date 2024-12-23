//
//  NetworkManager.swift
//  heat_up
//
//  Created by marat orozaliev on 21/12/2024.
//
// Models/NetworkManager.swift

import Foundation

class NetworkManager {
    static func registerUser(email: String, password: String, completion: @escaping (Bool, String?) -> Void) {
        let url = URL(string: "http://172.20.10.3:50462/users/pre-create")!
        let body: [String: Any] = [
            "email": email,
            "password": password
        ]
        let jsonData = try? JSONSerialization.data(withJSONObject: body)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(false, error.localizedDescription)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                completion(true, nil)
            } else {
                completion(false, "Registration failed")
            }
        }.resume()
    }
}
