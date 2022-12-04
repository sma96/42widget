//
//  DataManager.swift
//  UIKitTest
//
//  Created by 마석우 on 2022/12/03.
//

import Foundation

class DataManager {
    
    static let shared: DataManager = DataManager()
    
    var token: String? {
        if let sharedToken = UserDefaults(suiteName: DataShelter.shared.groupName)?.object(forKey: DataShelter.shared.keyName) as? String {
            return sharedToken
        } else {
            return nil
        }
    }
    
    var dateComponents: DateComponents {
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        
        return components
    }
    
    var year: Int? {
        dateComponents.year
    }
    
    var month: Int? {
        dateComponents.month
    }
    
    var day: Int? {
        dateComponents.day
    }
    
    var index: Int = 1
    
    func fetchDayData(completion: @escaping (Result<Days, FetchError>) -> Void) {
        guard let token = self.token else {
            print("no token")
            completion(.failure(.NoToken))
            return
        }
        index += 1
        print("\(year!) : \(month!) : \(day!)")
        var components = URLComponents(string: "https://api.24hoursarenotenough.42seoul.kr/v1/tag-log/perday")!
        components.queryItems = [URLQueryItem(name: "year", value: "\(year!)"), URLQueryItem(name: "month", value: "\(month!)"), URLQueryItem(name: "day", value: "\(day!)")]
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = ["Authorization": "Bearer \(token)", "accept": "application/json"]
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil, let data = data else {
                print("url error")
                completion(.failure(.FetchError))
                return
            }
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            if let response = response as? HTTPURLResponse {
                switch response.statusCode {
                case 400:
                    completion(.failure(.QuaryError))
                    return
                case 401:
                    completion(.failure(.NoAccessError))
                    return
                case 500:
                    completion(.failure(.ServerError))
                    return
                default:
                    break
                }
            }
            if let hane = try? decoder.decode(Days.self, from: data) {
                completion(.success(hane))
                return
            } else {
                completion(.failure(.DecodeError))
                return
            }
        }
        task.resume()
    }
    
    func fetchMonthData(completion: @escaping (Result<Days, FetchError>) -> Void) {
        guard let token = self.token else {
            print("no token")
            completion(.failure(.NoToken))
            return
        }
        print("\(year!) : \(month!) : \(day!)")
        var components = URLComponents(string: "https://api.24hoursarenotenough.42seoul.kr/v1/tag-log/permonth")!
        components.queryItems = [URLQueryItem(name: "year", value: "\(year!)"), URLQueryItem(name: "month", value: "\(month!)")]
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = ["Authorization": "Bearer \(token)", "accept": "application/json"]
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil, let data = data else {
                print("url error")
                completion(.failure(.FetchError))
                return
            }
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            if let response = response as? HTTPURLResponse {
                switch response.statusCode {
                case 400:
                    completion(.failure(.QuaryError))
                    return
                case 401:
                    completion(.failure(.NoAccessError))
                    return
                case 500:
                    completion(.failure(.ServerError))
                    return
                default:
                    break
                }
            }
            if let hane = try? decoder.decode(Days.self, from: data) {
                completion(.success(hane))
                return
            } else {
                completion(.failure(.DecodeError))
                return
            }
        }
        task.resume()
    }
    
    private init() {}
}
