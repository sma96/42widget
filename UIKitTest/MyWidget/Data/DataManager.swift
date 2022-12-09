//
//  DataManager.swift
//  UIKitTest
//
//  Created by 마석우 on 2022/12/03.
//

import Foundation
import Alamofire

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
    
    
    func fetchDayData(completion: @escaping (Result<Days, FetchError>) -> Void) {
        guard let token = self.token else {
            print("no token")
            completion(.failure(.NoToken))
            return
        }
        let parameters = ["year": year!, "month": month!, "day": day!]
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)", "accept": "application/json"]
        let encoder = URLEncodedFormParameterEncoder(encoder: URLEncodedFormEncoder(keyEncoding: .convertToSnakeCase))
        
        print("\(year!) : \(month!) : \(day!)")
        
        AF.request("https://api.24hoursarenotenough.42seoul.kr/v1/tag-log/perday", parameters: parameters, encoder: encoder, headers: headers).validate(statusCode: 200..<300).responseDecodable(of: Days.self) { response in
            switch response.result {
            case .success(let days):
                completion(.success(days))
                print("day data = \(days)")
            case .failure(let error):
                completion(.failure(.RequestError))
                print(error)
            }
        }
    }
    
    func fetchMonthData(completion: @escaping (Result<Days, FetchError>) -> Void) {
        guard let token = self.token else {
            print("no token")
            completion(.failure(.NoToken))
            return
        }
        print("\(year!) : \(month!) : \(day!)")
        let parameters = ["year": year!, "month": month!]
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)", "accept": "application/json"]
        let encoder = URLEncodedFormParameterEncoder(encoder: URLEncodedFormEncoder(keyEncoding: .convertToSnakeCase))
        
        AF.request("https://api.24hoursarenotenough.42seoul.kr/v1/tag-log/permonth", parameters: parameters, encoder: encoder, headers: headers).validate(statusCode: 200..<300).responseDecodable(of: Days.self) { response in
            switch response.result {
            case .success(let month):
                completion(.success(month))
                print("month data = \(month)")
            case .failure(let error):
                completion(.failure(.RequestError))
                print(error)
            }
        }
    }
    
    private init() {}
}


//func fetchDayData(completion: @escaping (Result<Days, FetchError>) -> Void) {
//    guard let token = self.token else {
//        print("no token")
//        completion(.failure(.NoToken))
//        return
//    }
//    print("\(year!) : \(month!) : \(day!)")
//    var components = URLComponents(string: "https://api.24hoursarenotenough.42seoul.kr/v1/tag-log/perday")!
//    components.queryItems = [URLQueryItem(name: "year", value: "\(year!)"), URLQueryItem(name: "month", value: "\(month!)"), URLQueryItem(name: "day", value: "\(day!)")]
//    
//    var request = URLRequest(url: components.url!)
//    request.httpMethod = "GET"
//    request.allHTTPHeaderFields = ["Authorization": "Bearer \(token)", "accept": "application/json"]
//    
//    let task = URLSession.shared.dataTask(with: request) { data, response, error in
//        guard error == nil, let data = data else {
//            print("url error")
//            completion(.failure(.FetchError))
//            return
//        }
//        let decoder = JSONDecoder()
//        decoder.keyDecodingStrategy = .convertFromSnakeCase
//        if let response = response as? HTTPURLResponse {
//            switch response.statusCode {
//            case 400:
//                completion(.failure(.QuaryError))
//                return
//            case 401:
//                completion(.failure(.NoAccessError))
//                return
//            case 500:
//                completion(.failure(.ServerError))
//                return
//            default:
//                break
//            }
//        }
//        if let hane = try? decoder.decode(Days.self, from: data) {
//            completion(.success(hane))
//            return
//        } else {
//            completion(.failure(.DecodeError))
//            return
//        }
//    }
//    task.resume()
//}
//
//func fetchMonthData(completion: @escaping (Result<Days, FetchError>) -> Void) {
//    guard let token = self.token else {
//        print("no token")
//        completion(.failure(.NoToken))
//        return
//    }
//    print("\(year!) : \(month!) : \(day!)")
//    var components = URLComponents(string: "https://api.24hoursarenotenough.42seoul.kr/v1/tag-log/permonth")!
//    components.queryItems = [URLQueryItem(name: "year", value: "\(year!)"), URLQueryItem(name: "month", value: "\(month!)")]
//    
//    var request = URLRequest(url: components.url!)
//    request.httpMethod = "GET"
//    request.allHTTPHeaderFields = ["Authorization": "Bearer \(token)", "accept": "application/json"]
//    
//    let task = URLSession.shared.dataTask(with: request) { data, response, error in
//        guard error == nil, let data = data else {
//            print("url error")
//            completion(.failure(.FetchError))
//            return
//        }
//        let decoder = JSONDecoder()
//        decoder.keyDecodingStrategy = .convertFromSnakeCase
//        if let response = response as? HTTPURLResponse {
//            switch response.statusCode {
//            case 400:
//                completion(.failure(.QuaryError))
//                return
//            case 401:
//                completion(.failure(.NoAccessError))
//                return
//            case 500:
//                completion(.failure(.ServerError))
//                return
//            default:
//                break
//            }
//        }
//        if let hane = try? decoder.decode(Days.self, from: data) {
//            completion(.success(hane))
//            return
//        } else {
//            completion(.failure(.DecodeError))
//            return
//        }
//    }
//    task.resume()
//}
