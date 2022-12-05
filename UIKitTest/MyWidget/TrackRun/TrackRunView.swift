//
//  TrackRunView.swift
//  UIKitTest
//
//  Created by 마석우 on 2022/12/03.
//

import SwiftUI

import WidgetKit

struct TrackRunView: View {
    
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
        GeometryReader { geo in
            ZStack {
                TrackRunRingView(percentage: percentage)
                    .rotationEffect(Angle(degrees: 150))
                Image(systemName: percentage >= 1 ? "hand.thumbsup.fill" : "hand.point.up.fill")
                    .resizable()
                    .rotationEffect(Angle(degrees: percentage >= 1 ? 0 : (percentage == 0 ? 260 : 240 * percentage + 90 + 180)))
                    .rotation3DEffect(.degrees(percentage >= 1 ? 0 : 180), axis: (x: 0, y: 0, z: 1))
                    .frame(width: 13, height: 17)
                    .offset(x: percentage >= 1 ? 0 : getPoint(width: geo.size.width - 30, height: geo.size.height - 30).x, y: percentage >= 1 ? 0 : getPoint(width: geo.size.width - 30, height: geo.size.height - 30).y)
                    .rotationEffect(Angle(degrees: percentage >= 1 ? 0 : 150))
                Text("\(monthTime)")
                    .font(.system(size: 14, weight: .bold))
                    .lineLimit(1)
                    .minimumScaleFactor(0.1)
                    .frame(width: 35, height: 18)
                    .offset(y: 22)
            }
        }
    }
    
    //MARK: - 원하는 view의 중심을 기준으로 그려지는 원호의 좌표값을 구해주는 함수
    private func getPoint(width: CGFloat, height: CGFloat) -> CGPoint {
        let angle = CGFloat((240 * percentage) * .pi / 180)
        let controlRadius: CGFloat = (width / 2) - (5.5 / 2)
        let x = controlRadius * cos(angle)
        let y = controlRadius * sin(angle)
        let point = CGPoint(x: x, y: y)
        return point
    }
    
    //MARK: - watch view에서 사용하며 일정 간격으로 원호의 좌표값을 구해준다. 만약 10개의 눈금을 둔다면 240 / 9의 각도를 가지게 된다.
    private func getPoint(width: CGFloat, height: CGFloat, index: Int) -> CGPoint {
        let angle = CGFloat(index == 0 ? 0 : 240 / 12 * index) * CGFloat(CGFloat.pi / 180)
        let controlRadius: CGFloat = (width / 2) - (5.5 / 2)
        let x = controlRadius * cos(angle)
        let y = controlRadius * sin(angle)
        let point = CGPoint(x: x, y: y)
        return point
    }
}

struct TrackRunView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.indigo
            TrackRunView(monthData: nil, dayData: nil)
                .frame(width: 75)
        }
    }
}
