//
//  CustomTabbar.swift
//  UIKitTest
//
//  Created by 마석우 on 2022/12/12.
//

import UIKit


class CustomTabbarView: UIView {
    
    let backgroundView = UIView()
    let profileView = UIStackView()
    let profileImage = UIImageView()
    let profileLabel = UILabel()
    let listButton = UIButton()
    let logoutButton = UIButton()
    
    var isListed = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        style()
        layout()
        let layer = CAGradientLayer()
        layer.frame = profileImage.bounds
        layer.cornerRadius = 25
        layer.colors = [UIColor.blue.cgColor, UIColor.yellow.cgColor, UIColor.systemPink.cgColor, UIColor.blue.cgColor]
        layer.locations = [0.0, 0.1, 0.2]
        layer.startPoint = CGPoint(x: 0, y: 0)
        layer.endPoint = CGPoint(x: 1, y: 1)
//        layer.add(animation, forKey: "locations")
    
        profileView.layer.addSublayer(layer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 200, height: 200)
    }
}

extension CustomTabbarView {
    func style() {
        translatesAutoresizingMaskIntoConstraints = false
        
        self.layer.borderColor = UIColor.systemBlue.cgColor
        self.layer.borderWidth = 0.2
        
        profileView.translatesAutoresizingMaskIntoConstraints = false
        profileView.clipsToBounds = true
//        profileView.backgroundColor = .systemGray6
        profileView.axis = .horizontal
        profileView.spacing = 10
        profileView.layer.cornerRadius = 15
        
        profileImage.translatesAutoresizingMaskIntoConstraints = false
//        profileImage.image = UIImage(systemName: "person.fill")
//        profileImage.backgroundColor = .systemGray4
        profileImage.clipsToBounds = true
        profileImage.contentMode = .scaleAspectFill
        profileImage.layer.cornerRadius = 25
//        profileImage.image = UIImage(named: "diamond")
        profileImage.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        profileLabel.translatesAutoresizingMaskIntoConstraints = false
        profileLabel.text = "Sma"
        profileLabel.font = .preferredFont(forTextStyle: .headline).withSize(14)
        profileLabel.backgroundColor = .clear
        profileLabel.textColor = .black
        profileLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
//        profileLabel.backgroundColor = .systemGray6
        profileLabel.textAlignment = .left
//        profileLabel.layer.cornerRadius = 10
        profileLabel.clipsToBounds = true
//        profileLabel.isHidden = true
        
        listButton.translatesAutoresizingMaskIntoConstraints = false
        listButton.setImage(UIImage(systemName: "list.bullet"), for: .normal)
        listButton.tintColor = .systemBlue
        
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.setTitle("로그아웃", for: .normal)
//        logoutButton.backgroundColor = .blue
        logoutButton.setTitleColor(UIColor.systemBlue, for: .normal)
        logoutButton.layer.cornerRadius = 10
        logoutButton.layer.borderWidth = 0.5
        logoutButton.titleLabel?.font = .preferredFont(forTextStyle: .footnote).withSize(15)
        logoutButton.layer.borderColor = UIColor.systemBlue.cgColor
        
    }

    func layout() {
        profileView.addArrangedSubview(profileImage)
        profileView.addArrangedSubview(profileLabel)
        
        self.addSubview(profileView)
        self.addSubview(listButton)
        self.addSubview(logoutButton)
        
        NSLayoutConstraint.activate([
            profileView.topAnchor.constraint(equalToSystemSpacingBelow: self.topAnchor, multiplier: 1),
            profileView.leadingAnchor.constraint(equalToSystemSpacingAfter: self.leadingAnchor, multiplier: 4),
//            profileView.centerXAnchor.constraint(equalTo: centerXAnchor),
            profileView.widthAnchor.constraint(equalToConstant: 150),
            profileView.heightAnchor.constraint(equalToConstant: 50),
            
            profileImage.widthAnchor.constraint(equalToConstant: 50),

            self.trailingAnchor.constraint(equalToSystemSpacingAfter: listButton.trailingAnchor, multiplier: 4),
            listButton.topAnchor.constraint(equalToSystemSpacingBelow: self.topAnchor, multiplier: 2),
            logoutButton.topAnchor.constraint(equalToSystemSpacingBelow: self.topAnchor, multiplier: 10),
//            logoutButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            logoutButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            logoutButton.widthAnchor.constraint(equalToConstant: 75),
            logoutButton.heightAnchor.constraint(equalToConstant: 25)
        ])
    }
    
//    func shimmerAnimation2() {
////        let animation = CABasicAnimation(keyPath: "locations")
////
////        animation.fromValue = [-10.0, -5.0, 0.0]
////        animation.toValue = [0.0, 5.0, 10.0]
////        animation.duration = 2
////        animation.repeatCount = .infinity
////        animation.beginTime = 0.0
////
//        let layer = CAGradientLayer()
//        layer.frame = profileView.bounds
//        layer.cornerRadius = 25
//        layer.colors = [UIColor.blue.cgColor, UIColor.yellow.cgColor, UIColor.systemPink.cgColor, UIColor.blue.cgColor]
//        layer.locations = [0.0, 0.1, 0.2]
//        layer.startPoint = CGPoint(x: 0, y: 0)
//        layer.endPoint = CGPoint(x: 1, y: 1)
////        layer.add(animation, forKey: "locations")
//
//        profileView.layer.addSublayer(layer)
//
//    }
    
//    func removeShimmerAnimation2() {
////        profileView.layer.sublayers?.removeAll()
////        profileView.layer.removeAllAnimations()
//        print("hellowo lele")
//    }
}
