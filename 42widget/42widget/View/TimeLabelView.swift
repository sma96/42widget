//
//  File.swift
//  UIKitTest
//
//  Created by 마석우 on 2022/12/11.
//

import UIKit


class TimeLabelView: UIView {
    
    let stackView = UIStackView()
    let dayTimeLabel = TimeView()
    let monthTimeLabel = TimeView()
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
        
        dayTimeLabel.seperatorLabel.text = "D"
        monthTimeLabel.seperatorLabel.text = "M"
        
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.backgroundColor = .systemGray6
    }
    
    func layout() {
        stackView.addArrangedSubview(dayTimeLabel)
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
            monthTimeLabel.heightAnchor.constraint(equalToConstant: 105)
        ])
    }
    
    func startShimmerAnimation() {
        dayTimeLabel.makeShimmerAnimation()
        monthTimeLabel.makeShimmerAnimation()
    }
    
    func stopShimmerAnimation() {
        dayTimeLabel.removeShimmerAnimation()
        monthTimeLabel.removeShimmerAnimation()
    }
}
