//
//  StoreNetworkManager.swift
//  heat_up
//
//  Created by marat orozaliev on 26/12/2024.
//
import Foundation

class ShopNetworkManager {
    
    // Функция для отправки запроса и получения данных о магазинах с учетом страны и города
    func fetchStores(countryCode: String, city: String, completion: @escaping (Result<[Store]?, Error>) -> Void) {
        // Создание URL с параметрами страны и города
        guard let url = URL(string: "https://example.com/stores/get_stores?country=\(countryCode)&city=\(city)") else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        // Создание запроса
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // Выполнение запроса
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Обработка ошибок
            if let error = error {
                completion(.failure(error))
                return
            }
            
            // Проверка кода ответа
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                let statusCodeError = NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Server returned error code: \(httpResponse.statusCode)"])
                completion(.failure(statusCodeError))
                return
            }
            
            // Декодирование данных
            guard let data = data else {
                completion(.success(nil)) // Возвращаем None, если данных нет
                return
            }
            
            do {
                // Попытка декодировать данные в массив объектов Store
                let stores = try JSONDecoder().decode([Store].self, from: data)
                completion(.success(stores))
            } catch {
                completion(.failure(error)) // Ошибка декодирования
            }
        }
        
        // Запуск задачи
        task.resume()
    }
    
    
//    static func fetchSupportedCountriesAndCities(completion: @escaping (Result<[String: [String]], Error>) -> Void) {
//        // Define the API endpoint
//        guard let url = URL(string: "http://127.0.0.1:8000/shop/supported_cities") else {
//            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
//            return
//        }
//        
//        // Create a data task
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            // Handle errors
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//            
//            // Ensure we have data
//            guard let data = data else {
//                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
//                return
//            }
//            
//            // Decode the JSON response
//            do {
//                let decoder = JSONDecoder()
//                let result = try decoder.decode(CountriesAndCities.self, from: data)
//                completion(.success(result.countries))
//            } catch {
//                completion(.failure(error))
//            }
//        }.resume()
//    }
}
