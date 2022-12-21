//
//  TimeManager.swift
//  UIKitTest
//
//  Created by 마석우 on 2022/12/04.
//

import Foundation

class TimeManager {
    static let shared: TimeManager = TimeManager()
    
    let maxTime: Double = 80
    
    private init() {}
    
    func getAllTime(from monthData: TimeDataModel?, _ dayData: TimeDataModel?) -> [Int] {
        guard let day = dayData, let month = monthData else {
            return [0, 0]
        }
        
        var monthTime: Int = 0
        for monthLog in month.inOutLogs {
            monthTime += monthLog.durationSecond
        }
        var dayTime: Int = 0
        for dayLog in day.inOutLogs {
            dayTime += dayLog.durationSecond
        }

        return [monthTime, dayTime]
    }
}
