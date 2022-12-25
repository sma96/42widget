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
        if let sharedToken = UserDefaults(suiteName: DataShelter.shared.userDefaultGroupName)?.object(forKey: DataShelter.shared.userDefaultTokenKeyName) as? String {
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
    
    func fetchDayData(completion: @escaping (Result<TimeDataModel, FetchError>) -> Void) {
        guard let token = self.token else {
            completion(.failure(.NoToken))
            return
        }
        let parameters = ["year": year!, "month": month!, "day": day!]
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)", "accept": "application/json"]
        let encoder = URLEncodedFormParameterEncoder(encoder: URLEncodedFormEncoder(keyEncoding: .convertToSnakeCase))
        
        AF.request("https://api.24hoursarenotenough.42seoul.kr/v1/tag-log/perday", parameters: parameters, encoder: encoder, headers: headers).validate(statusCode: 200..<300).responseDecodable(of: TimeDataModel.self) { response in
            switch response.result {
            case .success(let days):
                completion(.success(days))
            case .failure(let error):
                completion(.failure(.RequestError))
                print(error)
            }
        }
    }
    
    func fetchMonthData(completion: @escaping (Result<TimeDataModel, FetchError>) -> Void) {
        guard let token = self.token else {
            completion(.failure(.NoToken))
            return
        }
        let parameters = ["year": year!, "month": month!]
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)", "accept": "application/json"]
        let encoder = URLEncodedFormParameterEncoder(encoder: URLEncodedFormEncoder(keyEncoding: .convertToSnakeCase))
        
        AF.request("https://api.24hoursarenotenough.42seoul.kr/v1/tag-log/permonth", parameters: parameters, encoder: encoder, headers: headers).validate(statusCode: 200..<300).responseDecodable(of: TimeDataModel.self) { response in
            switch response.result {
            case .success(let month):
                completion(.success(month))
            case .failure(let error):
                completion(.failure(.RequestError))
                print(error)
            }
        }
    }
    
    private init() {}
}
