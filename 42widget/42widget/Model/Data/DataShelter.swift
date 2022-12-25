//
//  DataShelter.swift
//  UIKitTest
//
//  Created by 마석우 on 2022/12/02.
//

import UIKit
import Alamofire

class DataShelter {
    static let shared: DataShelter = DataShelter()
    
    let userDefaultGroupName: String = "group.me.ma.seokwoo.42widget"
    let userDefaultTokenKeyName: String = "accessToken"
    let userDefaultDateKeyName: String = "expiresDate"
    let userDefaultImageName: String = "profileImage"
    let userDefaultIntraName: String = "intraID"
    let widgetKind: String = "MyWidget"
    
    var tokenExpiresDate: Date? {
        didSet {
            if let fetchedExpiresDate = self.tokenExpiresDate {
                UserDefaults(suiteName: userDefaultGroupName)?.set(fetchedExpiresDate, forKey: userDefaultDateKeyName)
            }
        }
    }
    var token: String? {
        didSet {
            if let fetchedToken = self.token {
                UserDefaults(suiteName: userDefaultGroupName)?.set(fetchedToken, forKey: userDefaultTokenKeyName)
            }
        }
    }
    var profileImage: Data? {
        didSet {
            if let fetchedImage = self.profileImage {
                UserDefaults(suiteName: userDefaultGroupName)?.set(fetchedImage, forKey: userDefaultImageName)
            }
        }
    }
    var intraID: String? {
        didSet {
            if let fetchedID = self.intraID {
                UserDefaults(suiteName: userDefaultGroupName)?.set(fetchedID, forKey: userDefaultIntraName)
            }
        }
    }
    var imageURL: String?
    
    var dayData: TimeDataModel?
    var monthData: TimeDataModel?
    
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
    private init() {}
    
    func fetchDayData(completion: @escaping (Result<TimeDataModel, FetchError>) -> Void) {
        let parameters = ["year": year!, "month": month!, "day": day!]
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token!)", "accept": "application/json"]
        let encoder = URLEncodedFormParameterEncoder(encoder: URLEncodedFormEncoder(keyEncoding: .convertToSnakeCase))

        AF.request("https://api.24hoursarenotenough.42seoul.kr/v1/tag-log/perday", parameters: parameters, encoder: encoder, headers: headers).validate(statusCode: 200..<300).responseDecodable(of: TimeDataModel.self) { response in
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
    
    func fetchMonthData(completion: @escaping (Result<TimeDataModel, FetchError>) -> Void) {
        
        let parameters = ["year": year!, "month": month!]
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token!)", "accept": "application/json"]
        let encoder = URLEncodedFormParameterEncoder(encoder: URLEncodedFormEncoder(keyEncoding: .convertToSnakeCase))
        
        AF.request("https://api.24hoursarenotenough.42seoul.kr/v1/tag-log/permonth", parameters: parameters, encoder: encoder, headers: headers).validate(statusCode: 200..<300).responseDecodable(of: TimeDataModel.self) { response in
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
    
    func fetchAllData(completion: @escaping () -> Void) {
        let group = DispatchGroup()
    
        group.enter()
        fetchDayData { result in
            switch result {
            case .success(let day):
                print(day)
                self.dayData = day
                self.imageURL = day.profileImage
                self.intraID = day.login
            case .failure(let error):
                print(error)
            }
            group.leave()
        }
        group.enter()
        fetchMonthData { result in
            switch result {
            case .success(let month):
                print(month)
                self.monthData = month
            case .failure(let error):
                print(error)
            }
            group.leave()
        }
        group.notify(queue: .main) {
            completion()
        }
    }
}

struct TimeDataModel: Codable {
    let login: String
    let profileImage: String
    let inOutLogs: [InOutLogs]
    
    struct InOutLogs: Codable {
        let inTimeStamp: Int
        let outTimeStamp: Int
        let durationSecond: Int
    }
}
enum FetchError: Error {
    case FetchError
    case QuaryError
    case NoAccessError
    case ServerError
    case DecodeError
    case NoToken
    case RequestError
}
