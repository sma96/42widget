//
//  ViewController.swift
//  UIKitTest
//
//  Created by 마석우 on 2022/08/09.
//

import UIKit
import WidgetKit

class ViewController: UIViewController {
    
    let button = UIButton()
    let refreshButton = UIButton()
    let buttonLabel = UILabel()
    let dayTimeLabel = UILabel()
    let monthTimeLabel = UILabel()
    
    let stackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("hello world")
        dayTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        dayTimeLabel.clipsToBounds = true
        dayTimeLabel.layer.cornerRadius = 15
        dayTimeLabel.text = ""
        dayTimeLabel.textColor = .black
        dayTimeLabel.backgroundColor = .secondarySystemFill
        dayTimeLabel.textAlignment = .center
        dayTimeLabel.font = .preferredFont(forTextStyle: .title2)
        dayTimeLabel.font = .systemFont(ofSize: 25, weight: .bold)
        dayTimeLabel.isHidden = true
        
        monthTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        monthTimeLabel.clipsToBounds = true
        monthTimeLabel.layer.cornerRadius = 15
        monthTimeLabel.text = ""
        monthTimeLabel.textColor = .black
        monthTimeLabel.backgroundColor = .secondarySystemFill
        monthTimeLabel.textAlignment = .center
        monthTimeLabel.font = .preferredFont(forTextStyle: .title2)
        monthTimeLabel.font = .systemFont(ofSize: 25, weight: .bold)
        monthTimeLabel.isHidden = true
        
        buttonLabel.translatesAutoresizingMaskIntoConstraints = false
        buttonLabel.text = "내 데이터 가져오기"
        buttonLabel.textColor = .blue
        buttonLabel.textAlignment = .center
        buttonLabel.font = .preferredFont(forTextStyle: .subheadline)
        
        button.translatesAutoresizingMaskIntoConstraints = false
//        button.setTitle("Get Data", for: .normal)
        button.setImage(UIImage(systemName: "arrowshape.right.fill"), for: .normal)
//        button.imageView
        button.tintColor = .white
        button.layer.cornerRadius = 15
        button.backgroundColor = .blue
        button.addTarget(self, action: #selector(getDataButtonTapped), for: .primaryActionTriggered)

        refreshButton.translatesAutoresizingMaskIntoConstraints = false
        refreshButton.backgroundColor = .systemBlue
        refreshButton.addTarget(self, action: #selector(widgetRefresh), for: .primaryActionTriggered)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 8
    
        registerNotifications()
        
        stackView.addArrangedSubview(buttonLabel)
        stackView.addArrangedSubview(button)
        
        view.addSubview(stackView)
        view.addSubview(dayTimeLabel)
        view.addSubview(monthTimeLabel)
        view.addSubview(refreshButton)
        
        NSLayoutConstraint.activate([
            dayTimeLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            dayTimeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dayTimeLabel.widthAnchor.constraint(equalToConstant: 200),
            dayTimeLabel.heightAnchor.constraint(equalToConstant: 90),
            
            monthTimeLabel.topAnchor.constraint(equalToSystemSpacingBelow: dayTimeLabel.bottomAnchor, multiplier: 1),
            monthTimeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            monthTimeLabel.widthAnchor.constraint(equalToConstant: 200),
            monthTimeLabel.heightAnchor.constraint(equalToConstant: 90),
            
            button.widthAnchor.constraint(equalToConstant: 30),
            button.heightAnchor.constraint(equalToConstant: 30),
            
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            refreshButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            refreshButton.topAnchor.constraint(equalToSystemSpacingBelow: monthTimeLabel.bottomAnchor, multiplier: 3)
        ])
    }
    
    //MARK: - webView를 열어 24hane으로부터 access token을 받아옵니다. 토큰은 shared container UserDefault에 저장해줍니다. 그래야 widget extentsion과 데이터 공유가 가능합니다.
    @objc func getDataButtonTapped() {
        if let token = UserDefaults(suiteName: DataShelter.shared.groupName)?.object(forKey: "accessToken") {
            print("you've been have token \(token)")
            return
        }
        print("button Tapped")
        button.backgroundColor = .systemGray
        button.isEnabled = false
        buttonLabel.textColor = .systemGray
        let vc = WebViewController()
        vc.modalPresentationStyle = .fullScreen
        
        present(vc, animated: true)
    }
    //MARK: - widget을 refresh 해준다.
    @objc func  widgetRefresh() {
        print("refresh")
        WidgetCenter.shared.reloadTimelines(ofKind: DataShelter.shared.kind)
    }
    
    //MARK: - 데이터 fetch하고 실행되는 함수, fetch해온 데이터로 하루 누적시간과, 한달 누적 시간을 계산하여 label에 표시해준다.
    @objc func fetchedData() {
        self.stackView.removeFromSuperview()
        dayTimeLabel.isHidden = false
        monthTimeLabel.isHidden = false
//        button.isHidden = true
        var dayAllTime = 0
        if let data = DataShelter.shared.dayData?.inOutLogs {
            for day in data {
                dayAllTime += day.durationSecond
            }
            dayTimeLabel.text = "D \(dayAllTime / 3600) : \(dayAllTime % 3600 / 60) : \(dayAllTime % 3600 % 60)"
        } else {
            dayTimeLabel.text = "D 0 : 0 : 0"
        }
        var monthAllTime = 0
        
        if let data = DataShelter.shared.monthData?.inOutLogs {
            for month in data {
                monthAllTime += month.durationSecond
            }
            monthTimeLabel.text = "M \(monthAllTime / 3600) : \(monthAllTime % 3600 / 60) : \(monthAllTime % 3600 % 60)"
        } else {
            monthTimeLabel.text = "M 0 : 0 : 0"
        }
//        WidgetCenter.shared.reloadAllTimelines()
    }
    
    //MARK: - 데이터를 fetch해왔다는 알림을 받고 지정한 함수(fetchedData)를 실행시켜준다.
    func registerNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(fetchedData), name: .fetched, object: nil)
    }
}
