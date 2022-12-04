//
//  DefaultTextView.swift
//  UIKitTest
//
//  Created by 마석우 on 2022/12/03.
//

import SwiftUI

struct DefaultTextView: View {
    
    var monthTime: Int
    
    var body: some View {
        VStack(spacing: 5) {
            Text("\(monthTime)h")
                .font(.system(size: 15, weight: .bold))
                .lineLimit(1)
                .minimumScaleFactor(0.1)
                .frame(width: 30, height: 18)
            HStack(spacing: 15) {
                Text("0")
                    .font(.system(size: 10, weight: .semibold))
                    .lineLimit(1)
                    .minimumScaleFactor(0.1)
                Text("80")
                    .font(.system(size: 10, weight: .semibold))
                    .lineLimit(1)
                    .minimumScaleFactor(0.1)
            }
        }
        .offset(y: 7)
    }
}

struct DefaultTextView_Previews: PreviewProvider {
    static var previews: some View {
        DefaultTextView(monthTime: 50)
    }
}
