//
//  RingView.swift
//  UIKitTest
//
//  Created by 마석우 on 2022/12/03.
//

import SwiftUI

struct RingTipShape: Shape {
    var currentPercentage: Double
    var diameter: CGFloat
    var outerThickenss: CGFloat

    func path(in rect: CGRect) -> Path {
        var path = Path()

        let angle = CGFloat((240 * currentPercentage) * .pi / 180)
        let controlRadius: CGFloat = (rect.width / 2) - (outerThickenss / 2)
        let center = CGPoint(x: rect.width / 2, y: rect.height / 2)
        let x = center.x + controlRadius * cos(angle)
        let y = center.y + controlRadius * sin(angle)
        let pointCenter = CGPoint(x: x, y: y)
        path.addEllipse(in:
            CGRect(
                x: pointCenter.x - diameter / 2,
                y: pointCenter.y - diameter / 2,
                width: diameter,
                height: diameter
            )
        )
        return path
    }
    
    var animatableData: Double {
        get { return currentPercentage }
        set { currentPercentage = newValue }
    }
}

struct RingBackgroundShape: Shape {
    var thickness: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.addArc(center: CGPoint(x: rect.width / 2, y: rect.height / 2), radius: rect.width / 2 - (thickness / 2), startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 240), clockwise: false)
        
        return path.strokedPath(.init(lineWidth: thickness, lineCap: .round, lineJoin: .round))
    }
}

struct RingShape: Shape {
    var currentPercentage: Double
    var thickness: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.addArc(center: CGPoint(x: rect.width / 2, y: rect.height / 2), radius: rect.width / 2 - (thickness / 2), startAngle: Angle(degrees: 0), endAngle: Angle(degrees: currentPercentage * 240), clockwise: false)
        
        return path.strokedPath(.init(lineWidth: thickness, lineCap: .round, lineJoin: .round))
    }
    var animatableData: Double {
        get { return currentPercentage}
        set { currentPercentage = newValue}
    }
}


struct RingView: View {
    
    var percentage: Double
    var thickness: CGFloat = 5.5
    var outerThickness: CGFloat = 5.5
    
    private var thumMask: some View {
        ZStack{
            Color.white
            RingTipShape(currentPercentage: percentage, diameter: 10, outerThickenss: thickness)
                .fill(Color.black)
        }
        .compositingGroup()
        .luminanceToAlpha()
        
    }
    

    var body: some View {
        ZStack {
            RingBackgroundShape(thickness: thickness)
                .foregroundColor(.white.opacity(0.21))
                .mask(thumMask)
            RingShape(currentPercentage: percentage, thickness: thickness)
                .foregroundColor(.white.opacity(0.65))
                .mask(thumMask)
            RingTipShape(currentPercentage: percentage, diameter: thickness, outerThickenss: thickness)
                .foregroundColor(.white)

        }
    }
}

struct RingView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.indigo
            RingView(percentage: 0.4)
                .frame(width: 75, height: 75)
        }
    }
}


