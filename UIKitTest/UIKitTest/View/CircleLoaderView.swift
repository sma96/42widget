//
//  CircleLoaderView.swift
//  UIKitTest
//
//  Created by 마석우 on 2022/12/10.
//

import UIKit

class CircleLoaderView: UIView {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        style()
        layout()
//        setAnimation()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 50, height: 50)
    }
}

extension CircleLoaderView {
    func style() {
        translatesAutoresizingMaskIntoConstraints = false
//        backgroundColor = .orange
    }
    
    func layout() {
        
    }
    
    func setAnimation() {
        let path = UIBezierPath(ovalIn: CGRect(origin: .zero, size: CGSize(width: 50, height: 50)))
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = 0.7
        animation.duration = 0.75
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        
        let animation2 = CABasicAnimation(keyPath: "strokeEnd")
        animation2.fromValue = 0.7
        animation2.toValue = 0.0
        animation2.duration = 1.25
        animation2.beginTime = 0.75
        animation2.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)

        let group = CAAnimationGroup()
        group.animations = [animation, animation2]
        group.duration = 2
        group.repeatCount = .infinity

        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotationAnimation.fromValue = 0.0
        rotationAnimation.toValue = Double.pi * 2 //Minus can be Direction
        rotationAnimation.duration = 0.9
        rotationAnimation.repeatCount = .infinity
        
        let layer = CAShapeLayer()
        layer.strokeColor = UIColor.systemGray4.cgColor
        layer.fillColor = nil
        layer.lineWidth = 5
        layer.path = path.cgPath
        layer.strokeEnd = 0.7
        layer.add(group, forKey: "strokeEnd")
        layer.lineCap = .round
        
        self.layer.addSublayer(layer)
        self.layer.add(rotationAnimation, forKey: "rotate")
    }
    
    func start() {
        guard let superview = self.superview else {
            return
        }
        
        setAnimation()
        NSLayoutConstraint.activate([
            self.centerXAnchor.constraint(equalTo: superview.centerXAnchor),
            self.centerYAnchor.constraint(equalTo: superview.centerYAnchor)
        ])
    }
    
    func stop() {
        self.layer.removeAllAnimations()
        self.layer.sublayers?.removeAll()
        print("***********stop circle*********")
//        self.removeFromSuperview()
    }
}
