//
//  CircularRingView.swift
//  UIKitTest
//
//  Created by 마석우 on 2022/12/04.
//

import SwiftUI

struct CircularRingView: View {
    
    let monthData: Days?
    let dayData: Days?
    
    var monthTime: Int {
        let times = TimeManager.shared.getAllTime(monthData: monthData, dayData: dayData)
        
        return times[0] / 3600
    }
    
    var dayTime: Int {
        let times = TimeManager.shared.getAllTime(monthData: monthData, dayData: dayData)

        return times[1] / 3600
    }
    
    var percentage: Double {
        let percentage = (Double(monthTime) / TimeManager.shared.maxTime)
        
        return percentage >= 1 ? 1 : percentage
    }
    
    var body: some View {
        ZStack {
            RingView(percentage: percentage)
                .rotationEffect(Angle(degrees: 150))
            DefaultTextView(monthTime: monthTime)
        }
    }
}

struct CircularRingView_Previews: PreviewProvider {
    static var previews: some View {
        CircularRingView(monthData: nil, dayData: nil)
    }
}
