//
//  TimeScaleView.swift
//  UIKitTest
//
//  Created by 마석우 on 2022/12/03.
//

import SwiftUI

struct TimeScaleView: View {
    
    let monthData: Days?
    let dayData: Days?
    
    var monthTime: Int {
        let times = TimeManager.shared.getAllTime(monthData: monthData, dayData: dayData)
        
        return times[0] / 3600
    }
    
    var dayTime: Int {
        let times = TimeManager.shared.getAllTime(monthData: monthData, dayData: dayData)
        
        return times[1]
    }

    var percentage: Double {
        let percentage = (Double(monthTime) / TimeManager.shared.maxTime)
        
        return percentage >= 1 ? 1 : percentage
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                //MARK: - 진행량을 나타내는 ring view
                ScaleRingView(percentage: percentage)
                    .rotationEffect(Angle(degrees: 150))
                //MARK: - watch view 시간 간격을 나타내는 눈금을 표현한 view
                ForEach(0..<13) { item in
                    Circle()
                        .frame(width: item % 3 == 0 ? 3 : 1.5, height: item % 3 == 0 ? 3 : 1.5)
                        .rotationEffect(Angle(degrees: Double(percentage == 0 ? 260 : item == 0 ? 90 : 240 / 12 * item + 90)))
                        .offset(x: getPoint(width: geo.size.width - 12, height: geo.size.height - 12, index: item).x, y: getPoint(width: geo.size.width - 12, height: geo.size.height - 12, index: item).y)
                        .rotationEffect(Angle(degrees: 150))
                }
                //MARK: - rotate image view 중심을 기준으로 진행량에 맞춰서 회전하는 view
                RotateImageView(imageName: "rhombus.fill", percentage: percentage)
                    .frame(width: 4, height: 12)
                    .offset(x: getPoint(width: geo.size.width - 35, height: geo.size.height - 35).x, y: getPoint(width: geo.size.width - 35, height: geo.size.height - 35).y)
                    .rotationEffect(Angle(degrees: 150))
                Circle()
                    .frame(width: 3.5)
                Text("\(monthTime)/\(80)")
                    .font(.system(size: 12, weight: .bold))
                    .lineLimit(1)
                    .minimumScaleFactor(0.1)
                    .frame(width: 35, height: 18)
                    .offset(y: 20)
                //                    DefaultTextView()
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

struct TimeScaleView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.indigo
            TimeScaleView(monthData: nil, dayData: nil)
                .frame(width: 70, height: 70)
        }
    }
}
