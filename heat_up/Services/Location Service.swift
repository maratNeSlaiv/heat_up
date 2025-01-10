import Foundation

class LocationService {
    func fetchLocation(completion: @escaping (String?, String?) -> Void) {
        guard let url = URL(string: "https://ipinfo.io/json?token=ef4cffe5bb6bf9") else { // ef4cffe5bb6bf9
            completion(nil, nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Ошибка запроса: \(error?.localizedDescription ?? "Неизвестная ошибка")")
                completion(nil, nil)
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    let city = json["city"] as? String
                    let country = json["country"] as? String
                    completion(city, country)
                } else {
                    completion(nil, nil)
                }
            } catch {
                print("Ошибка декодирования JSON: \(error.localizedDescription)")
                completion(nil, nil)
            }
        }.resume()
    }
}
