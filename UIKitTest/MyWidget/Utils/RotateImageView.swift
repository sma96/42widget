//
//  RotateImageView.swift
//  UIKitTest
//
//  Created by 마석우 on 2022/12/03.
//

import SwiftUI

struct RotateImageView: View {
    var imageName: String
    var percentage: Double
    
    var body: some View {
        Image(systemName: imageName)
            .resizable()
            .rotationEffect(Angle(degrees: percentage == 0 ? 260 : 240 * percentage + 90 + 180))
            .rotation3DEffect(.degrees(180), axis: (x: 0, y: 0, z: 1))
    }
}

struct RotateImageView_Previews: PreviewProvider {
    static var previews: some View {
        RotateImageView(imageName: "rhombus.fill", percentage: 0.5)
            .frame(width: 10, height: 20)
    }
}

