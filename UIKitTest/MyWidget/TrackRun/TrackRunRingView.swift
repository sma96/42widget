//
//  TrackRunRingView.swift
//  UIKitTest
//
//  Created by 마석우 on 2022/12/03.
//

import SwiftUI

struct TrackRunRingView: View {
    
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
//                .frame(width: 50, height: 50)
            RingShape(currentPercentage: percentage, thickness: thickness)
                .foregroundColor(.white.opacity(0.65))
//                .frame(width: 50, height: 50)
            
        }
    }
}

//struct TrackRunRingView_Previews: PreviewProvider {
//    static var previews: some View {
//        ZStack {
//            Color.indigo
//            TrackRunRingView(percentage: 0.6)
//                .frame(width: 75)
//        }
//    }
//}
