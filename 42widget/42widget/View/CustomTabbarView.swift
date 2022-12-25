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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 210, height: 200)
    }
}

extension CustomTabbarView {
    func style() {
        translatesAutoresizingMaskIntoConstraints = false
        
        self.layer.borderColor = UIColor.systemBlue.cgColor
        self.layer.borderWidth = 0.2
        self.layer.cornerRadius = 30
        
        profileView.translatesAutoresizingMaskIntoConstraints = false
        profileView.clipsToBounds = true
        profileView.axis = .horizontal
        profileView.spacing = 10
        profileView.layer.cornerRadius = 15
        
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        profileImage.clipsToBounds = true
        profileImage.contentMode = .scaleAspectFill
        profileImage.layer.cornerRadius = 25
        profileImage.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        profileLabel.translatesAutoresizingMaskIntoConstraints = false
        profileLabel.text = "Sma"
        profileLabel.font = .preferredFont(forTextStyle: .headline).withSize(14)
        profileLabel.backgroundColor = .clear
        profileLabel.textColor = .systemBlue
        profileLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        profileLabel.textAlignment = .left
        profileLabel.clipsToBounds = true
        
        listButton.translatesAutoresizingMaskIntoConstraints = false
        listButton.setImage(UIImage(systemName: "list.bullet"), for: .normal)
        listButton.tintColor = .systemBlue
        
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.setTitle("로그아웃", for: .normal)
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
}
