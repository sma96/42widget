//
//  TimeView.swift
//  UIKitTest
//
//  Created by 마석우 on 2022/12/18.
//

import UIKit


class TimeView: UIView {
    let seperatorLabel = UILabel()
    let timeLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        style()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 200, height: 200)
    }
}

extension TimeView {
    func style() {
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 25
        backgroundColor = .labelBackgroundColor
        
        seperatorLabel.translatesAutoresizingMaskIntoConstraints = false
        seperatorLabel.text = "D"
        seperatorLabel.textColor = .gray
        seperatorLabel.textAlignment = .center
        seperatorLabel.font = .preferredFont(forTextStyle: .footnote)
        seperatorLabel.font = .systemFont(ofSize: 20, weight: .bold)
        
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.text = ""
        timeLabel.textAlignment = .center
        timeLabel.textColor = .black
        timeLabel.font = .systemFont(ofSize: 25, weight: .bold)
        timeLabel.adjustsFontSizeToFitWidth = true
        timeLabel.minimumScaleFactor = 0.1
        timeLabel.numberOfLines = 1
    }
    
    func layout() {
        self.addSubview(seperatorLabel)
        self.addSubview(timeLabel)
        
        NSLayoutConstraint.activate([
            timeLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            timeLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            timeLabel.widthAnchor.constraint(equalToConstant: 125),
            timeLabel.heightAnchor.constraint(equalToConstant: 50),
            
            timeLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: seperatorLabel.trailingAnchor, multiplier: 1.5),
//            seperationLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 2),
            seperatorLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func removeShimmerAnimation() {
        self.seperatorLabel.layer.removeAllAnimations()
        self.seperatorLabel.layer.sublayers?.removeAll()
        self.timeLabel.layer.removeAllAnimations()
        self.timeLabel.layer.sublayers?.removeAll()
    }
    
    func makeShimmerAnimation() {
        let seperatorLabelAnimation = CABasicAnimation(keyPath: "locations")
        seperatorLabelAnimation.fromValue = [-10.0, -5.0, 0.0]
        seperatorLabelAnimation.toValue = [0.0, 5.0, 10.0]
        seperatorLabelAnimation.duration = 2
        seperatorLabelAnimation.repeatCount = .infinity
        seperatorLabelAnimation.beginTime = 0.0
        
        let timeLabelAnimation = CABasicAnimation(keyPath: "locations")
        timeLabelAnimation.fromValue = [-10.0, -5.0, 0.0]
        timeLabelAnimation.toValue = [0.0, 5.0, 10.0]
        timeLabelAnimation.duration = 2
        timeLabelAnimation.repeatCount = .infinity
        timeLabelAnimation.beginTime = 1.35

        let seperatorLabelLayer = CAGradientLayer()
        seperatorLabelLayer.frame = seperatorLabel.bounds
        seperatorLabelLayer.cornerRadius = 5
        seperatorLabelLayer.colors = [UIColor.labelBackgroundColor.cgColor, UIColor.labelShimmerColor.cgColor, UIColor.labelBackgroundColor.cgColor]
        seperatorLabelLayer.locations = [0.0, 0.1, 0.2]
        seperatorLabelLayer.startPoint = CGPoint(x: 0, y: 0)
        seperatorLabelLayer.endPoint = CGPoint(x: 1, y: 1)
        seperatorLabelLayer.add(seperatorLabelAnimation, forKey: "locations")

        let timeLabelLayer = CAGradientLayer()
        timeLabelLayer.frame = timeLabel.bounds
        timeLabelLayer.cornerRadius = 15
        timeLabelLayer.colors = [UIColor.labelBackgroundColor.cgColor, UIColor.labelShimmerColor.cgColor, UIColor.labelBackgroundColor.cgColor]
        timeLabelLayer.locations = [0.0, 0.1, 0.2]
        timeLabelLayer.startPoint = CGPoint(x: 0, y: 0)
        timeLabelLayer.endPoint = CGPoint(x: 1, y: 1)
        timeLabelLayer.add(timeLabelAnimation, forKey: "locations")
        
        seperatorLabel.layer.addSublayer(seperatorLabelLayer)
        timeLabel.layer.addSublayer(timeLabelLayer)
        
    }
}
