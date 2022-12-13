//
//  ViewController.swift
//  UIKitTest
//
//  Created by 마석우 on 2022/08/09.
//

import UIKit
import WidgetKit

class ViewController: UIViewController {
    
    var complete = false
    let button = UIButton()
    let refreshButton = UIButton()
    let buttonLabel = UILabel()
    let circleLoader = CircleLoaderView()
    let timeLabel = TimeLabelView()
    let tabBar = CustomTabbarView()
    
//    var currentDate = Date.now
    let stackView = UIStackView()
    
    var tabBarTopAnchor: NSLayoutConstraint?
    var animator: UIViewPropertyAnimator?
    var backAnimator: UIViewPropertyAnimator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        layout()
        // expiresdate test timer
//        let timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { timer in
//            self.currentDate = Date.now + 20
//            print("timer")
//        }
        registerNotifications()
        getUserDefaultData()
        checkAllData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let path = UIBezierPath(ovalIn: CGRect(origin: CGPoint(x: 25, y: 25), size: CGSize(width: 50, height: 50)))
        
        let layer = CAGradientLayer()
        layer.frame = tabBar.profileImage.bounds
        layer.cornerRadius = 25
        layer.colors = [UIColor.blue.cgColor, UIColor.purple.cgColor, UIColor.blue.cgColor]
        layer.startPoint = CGPoint(x: 0.5, y: 0.5)
        layer.type = .conic
        
        let mask = CAShapeLayer()
        mask.bounds = layer.bounds
        mask.path = path.cgPath
        mask.fillColor = nil
        mask.lineWidth = 4
        mask.strokeColor = UIColor.white.cgColor
        
        layer.mask = mask
        
        tabBar.profileView.layer.addSublayer(layer)
    }
}

extension ViewController {
    
    private func layout() {
        stackView.addArrangedSubview(buttonLabel)
        stackView.addArrangedSubview(button)
        
        view.addSubview(stackView)
        view.addSubview(timeLabel)
        view.addSubview(refreshButton)
        view.addSubview(circleLoader)
        view.addSubview(tabBar)
        
        NSLayoutConstraint.activate([

            button.widthAnchor.constraint(equalToConstant: 30),
            button.heightAnchor.constraint(equalToConstant: 30),
            
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            refreshButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            refreshButton.topAnchor.constraint(equalToSystemSpacingBelow: timeLabel.bottomAnchor, multiplier: 3),
            refreshButton.widthAnchor.constraint(equalToConstant: 30),
            refreshButton.heightAnchor.constraint(equalToConstant: 30),
//
            timeLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            timeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            tabBar.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 0),
            tabBar.trailingAnchor.constraint(equalToSystemSpacingAfter: view.trailingAnchor, multiplier: 0)
        ])
        
        tabBarTopAnchor = view.bottomAnchor.constraint(equalToSystemSpacingBelow: tabBar.topAnchor, multiplier: 10)
        tabBarTopAnchor?.isActive = true
    }
    
    private func setup() {


        
        buttonLabel.translatesAutoresizingMaskIntoConstraints = false
        buttonLabel.text = "로그인해서 데이터 가져오기"
        buttonLabel.textColor = .blue
        buttonLabel.textAlignment = .center
        buttonLabel.font = .preferredFont(forTextStyle: .subheadline)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "arrowshape.right.fill"), for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 15
        button.backgroundColor = .blue
        button.addTarget(self, action: #selector(getDataButtonTapped), for: .primaryActionTriggered)

        refreshButton.translatesAutoresizingMaskIntoConstraints = false
        refreshButton.layer.cornerRadius = 15
        refreshButton.tintColor = .systemBlue
        refreshButton.setImage(UIImage(systemName: "arrow.clockwise.circle"), for: .normal)
        refreshButton.addTarget(self, action: #selector(widgetRefresh), for: .primaryActionTriggered)
        refreshButton.isHidden = true
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 8
        
        timeLabel.isHidden = true
        
        tabBar.translatesAutoresizingMaskIntoConstraints = false
        tabBar.listButton.addTarget(self, action: #selector(listButtonTapped), for: .primaryActionTriggered)
        tabBar.isHidden = true
    }
    
    @objc private func listButtonTapped() {
        if tabBar.isListed {
            let backAnimator = UIViewPropertyAnimator(duration: 0.45, curve: .easeInOut) {
                self.tabBarTopAnchor?.constant = 80
                self.view.layoutIfNeeded()
            }
            backAnimator.startAnimation()
            tabBar.isListed.toggle()
        } else if !tabBar.isListed {
            let animator = UIViewPropertyAnimator(duration: 0.45, curve: .easeInOut) {
                self.tabBarTopAnchor?.constant = 140
                self.view.layoutIfNeeded()
            }
            
            animator.startAnimation()
            tabBar.isListed.toggle()
        }
    }
    
    private func getUserDefaultData() {
        if let expiresDate = UserDefaults(suiteName: DataShelter.shared.groupName)?.object(forKey: DataShelter.shared.dateKeyName) as? Date {
            DataShelter.shared.expiresDate = expiresDate
        }
        if let token = UserDefaults(suiteName: DataShelter.shared.groupName)?.object(forKey: DataShelter.shared.keyName) as? String {
            DataShelter.shared.token = token
        }
    }
    
    private func checkExpiresDate() {
        if let expiresDate = DataShelter.shared.expiresDate {
            let currentDate = Date.now
            if currentDate >= expiresDate {
                print("expires")
                UserDefaults(suiteName: DataShelter.shared.groupName)?.set(nil, forKey: DataShelter.shared.keyName)
                DataShelter.shared.token = nil
            } else {
                print("valid")
                print(expiresDate)
            }
        }
    }
    
    private func hasToken() -> Bool {
        if DataShelter.shared.token != nil {
            print("you've been have token")
            return true
        }
        return false
    }
    
    @objc private func checkAllData() {
        checkExpiresDate()
        if hasToken() {
            print("hasToken")
            button.isHidden = true
            buttonLabel.isHidden = true
            circleLoader.start()
            DataShelter.shared.fetchAllData {
                self.fetchedData()
                self.circleLoader.stop()
                self.complete = true
            }
        } else {
            timeLabel.isHidden = true
            refreshButton.isHidden = true
            button.isHidden = false
            buttonLabel.isHidden = false
        }
    }
    
    @objc private func checkAllDataWhenInForeground() {
        if complete == false {
            return
        }
        refreshButton.isEnabled = false
        print("+++++++++++++++++=checkAlldata+++++++++++")
        checkExpiresDate()
        if hasToken() {
            print("hasToken")
            button.isHidden = true
            buttonLabel.isHidden = true
            timeLabel.shimmerAnimation()
//            tabBar.shimmerAnimation2()
            DataShelter.shared.fetchAllData {
                self.fetchedData()
                self.refreshButton.isEnabled = true
                self.timeLabel.removeShimmerAnimation()
            }
        } else {
            timeLabel.isHidden = true
            refreshButton.isHidden = true
            tabBar.isHidden = true
            button.isHidden = false
            buttonLabel.isHidden = false
        }
    }
    
    //MARK: - 데이터를 fetch해왔다는 알림을 받고 지정한 함수(fetchedData)를 실행시켜준다.
    func registerNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(fetchedData), name: .fetched, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(checkAllDataWhenInForeground), name: .checkExpires, object: nil)
    }
    
    //MARK: - profile image 세팅해주는 함수
    private func setProfile(completion: @escaping () -> Void) {
        guard let url = URL(string: DataShelter.shared.imageURL!) else {
            completion()
            return
        }
        print(DataShelter.shared.imageName)
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    DataShelter.shared.profileImage = data
                    self.tabBar.profileImage.image = UIImage(data: data)
                    completion()
                }
            } else {
                completion()
            }
        }
    }
}

extension ViewController {
    
    //MARK: - webView를 열어 24hane으로부터 access token을 받아옵니다. 토큰은 shared container UserDefault에 저장해줍니다. 그래야 widget extentsion과 데이터 공유가 가능합니다.
    
    @objc func getDataButtonTapped() {
        print("button Tapped")
        button.backgroundColor = .systemGray
        button.isEnabled = false
        buttonLabel.textColor = .systemGray
        let vc = WebViewController()
        vc.modalPresentationStyle = .fullScreen
        
        present(vc, animated: true) {
            self.button.isHidden.toggle()
            self.buttonLabel.isHidden.toggle()
        }
    }
    
    //MARK: - widget을 refresh 해준다.
    @objc func  widgetRefresh() {
        print("refresh")
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    //MARK: - 데이터 fetch하고 실행되는 함수, fetch해온 데이터로 하루 누적시간과, 한달 누적 시간을 계산하여 label에 표시해준다.
    @objc func fetchedData() {

        if let profileImage = UserDefaults(suiteName: DataShelter.shared.groupName)?.object(forKey: DataShelter.shared.imageName) as? Data{
            tabBar.profileImage.image = UIImage(data: profileImage)
        } else {
            setProfile {
                print("setimage")
            }
        }
        tabBar.profileLabel.text = DataShelter.shared.intraID
        var dayAllTime = 0
        
        if let data = DataShelter.shared.dayData?.inOutLogs {
            for day in data {
                dayAllTime += day.durationSecond
            }
            timeLabel.dayTimeLabel.text = "D \(dayAllTime / 3600) : \(dayAllTime % 3600 / 60) : \(dayAllTime % 3600 % 60)"
        } else {
            timeLabel.dayTimeLabel.text = "D 0 : 0 : 0"
        }
        
        var monthAllTime = 0
        
        if let data = DataShelter.shared.monthData?.inOutLogs {
            for month in data {
                monthAllTime += month.durationSecond
            }
            timeLabel.monthTimeLabel.text = "M \(monthAllTime / 3600) : \(monthAllTime % 3600 / 60) : \(monthAllTime % 3600 % 60)"
        } else {
            timeLabel.monthTimeLabel.text = "M 0 : 0 : 0"
        }
        
        timeLabel.isHidden = false
        tabBar.isHidden = false
        refreshButton.isHidden = false
//        print(button.isHidden)
//        buttonLabel.isHidden.toggle()
        WidgetCenter.shared.reloadAllTimelines()
    }

}
