//
//  File.swift
//  UIKitTest
//
//  Created by 마석우 on 2022/12/11.
//

import UIKit


class TimeLabelView: UIView {
    
    let stackView = UIStackView()
    let dayTimeLabel = UILabel()
    let monthTimeLabel = UILabel()
    let divider = UIView()
    
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

extension TimeLabelView {
    func style() {
        translatesAutoresizingMaskIntoConstraints = false
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 3.5
//        stackView.backgroundColor = .labelBackgroundColor
//        stackView.layer.cornerRadius = 20
//        stackView.clipsToBounds = true
//        stackView.distribution = .fillEqually
        
        dayTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        dayTimeLabel.clipsToBounds = true
        dayTimeLabel.layer.cornerRadius = 25
        dayTimeLabel.text = ""
        dayTimeLabel.textColor = .black
        dayTimeLabel.backgroundColor = .labelBackgroundColor
        dayTimeLabel.textAlignment = .center
        dayTimeLabel.font = .preferredFont(forTextStyle: .title2)
        dayTimeLabel.font = .systemFont(ofSize: 25, weight: .bold)
//        dayTimeLabel.isHidden = true
        
        monthTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        monthTimeLabel.clipsToBounds = true
        monthTimeLabel.layer.cornerRadius = 25
        monthTimeLabel.text = "ddd"
        monthTimeLabel.textColor = .black
        monthTimeLabel.backgroundColor = .labelBackgroundColor
        monthTimeLabel.textAlignment = .center
        monthTimeLabel.font = .preferredFont(forTextStyle: .title2)
        monthTimeLabel.font = .systemFont(ofSize: 25, weight: .bold)
        monthTimeLabel.adjustsFontSizeToFitWidth = true
        monthTimeLabel.minimumScaleFactor = 0.1
        monthTimeLabel.numberOfLines = 1
//        monthTimeLabel.isHidden = true
        
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.backgroundColor = .systemGray6
    }
    
    func layout() {
        stackView.addArrangedSubview(dayTimeLabel)
//        stackView.addArrangedSubview(divider)
        stackView.addArrangedSubview(monthTimeLabel)
        self.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalToSystemSpacingBelow: topAnchor, multiplier: 1),
            bottomAnchor.constraint(equalToSystemSpacingBelow: stackView.bottomAnchor, multiplier: 1),
            stackView.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 1),
            trailingAnchor.constraint(equalToSystemSpacingAfter: stackView.trailingAnchor, multiplier: 1),
            dayTimeLabel.widthAnchor.constraint(equalToConstant: 200),
            dayTimeLabel.heightAnchor.constraint(equalToConstant: 105),
            monthTimeLabel.widthAnchor.constraint(equalToConstant: 200),
            monthTimeLabel.heightAnchor.constraint(equalToConstant: 105),
        ])
    }
    
    func removeShimmerAnimation() {
        self.dayTimeLabel.layer.removeAllAnimations()
        self.dayTimeLabel.layer.sublayers?.removeAll()
        self.monthTimeLabel.layer.removeAllAnimations()
        self.monthTimeLabel.layer.sublayers?.removeAll()
    }
    
    func shimmerAnimation() {
        let animation = CABasicAnimation(keyPath: "locations")
        
        animation.fromValue = [-10.0, -5.0, 0.0]
        animation.toValue = [0.0, 5.0, 10.0]
        animation.duration = 2
        animation.repeatCount = .infinity
        animation.beginTime = 0.0
        
        let animation2 = CABasicAnimation(keyPath: "locations")
        
        animation2.fromValue = [-10.0, -5.0, 0.0]
        animation2.toValue = [0.0, 5.0, 10.0]
        animation2.duration = 2
        animation2.repeatCount = .infinity
        animation2.beginTime = 1.35

        let layer = CAGradientLayer()
        layer.frame = dayTimeLabel.bounds
        layer.cornerRadius = 15
        layer.colors = [UIColor.labelBackgroundColor.cgColor, UIColor.labelShimmerColor.cgColor, UIColor.labelBackgroundColor.cgColor]
        layer.locations = [0.0, 0.1, 0.2]
        layer.startPoint = CGPoint(x: 0, y: 0)
        layer.endPoint = CGPoint(x: 1, y: 1)
        layer.add(animation, forKey: "locations")
        
        let layer2 = CAGradientLayer()
        layer2.frame = dayTimeLabel.bounds
        layer2.cornerRadius = 15
        layer2.colors = [UIColor.labelBackgroundColor.cgColor, UIColor.labelShimmerColor.cgColor, UIColor.labelBackgroundColor.cgColor]
        layer2.locations = [0.0, 0.1, 0.2]
        layer2.startPoint = CGPoint(x: 0, y: 0)
        layer2.endPoint = CGPoint(x: 1, y: 1)
        layer2.add(animation2, forKey: "locations")
        
        dayTimeLabel.layer.addSublayer(layer)
        monthTimeLabel.layer.addSublayer(layer2)
        
    }
}
