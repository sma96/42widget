//
//  WebViewController.swift
//  UIKitTest
//
//  Created by 마석우 on 2022/12/02.
//

import Foundation
import UIKit
import WebKit

class WebViewController: UIViewController {
    
    var webView: WKWebView!
    
    //    override func loadView() {
    //        super.loadView()
    //        let webConfiguration = WKWebViewConfiguration()
    //        webConfiguration.preferences.javaScriptEnabled = true
    //        webView = WKWebView(frame: .zero, configuration: webConfiguration)
    //        webView.uiDelegate = self
    //        webView.navigationDelegate = self
    //        self.view = self.webView!
    //    }
    var text: String = "hello" {
        willSet {
            print("didset!!")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var components = URLComponents(string: "https://api.24hoursarenotenough.42seoul.kr/user/login/42")!
        let query = [URLQueryItem(name: "redirect", value: "https://24hoursarenotenough.42seoul.kr/")]
        components.queryItems = query
        
        let request = URLRequest(url: components.url!)

        style()
        layout()
        webView.load(request)
        
    }
}

extension WebViewController {
    func style() {
        let webConfiguration = WKWebViewConfiguration()
//        webConfiguration.preferences.javaScriptEnabled = true
        
        view.backgroundColor = .white
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    func layout() {
        
        view.addSubview(webView)
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
    }
}

extension WebViewController {

}

extension WebViewController: WKUIDelegate, WKNavigationDelegate {
    
    //MARK: - 로드된 url을 보여줄지 말지 정해줄 수 있습니다. 허락하고 싶다면 .allow 아니면 .cancel
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let urlString = navigationAction.request.url?.absoluteString ?? ""
        
        print("decidePolicyFor navigationAction: \(urlString)")
        decisionHandler(.allow)
    }
    
    //MARK: - webView가 페이지 로드를 완료하면 호출되는 함수입니다. 만약 url이 "https://24hoursarenotenough.42seoul.kr/" 이라면 쿠키에 저장되어 있는 토큰을 가져와 누적 시간을 fetch 해옵니다.
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("didFinish navigatio                                          \(webView.url) ")
        guard let url = webView.url?.absoluteString else {
            print("webView url error")
            return
        }
        if url.hasPrefix("https://24hoursarenotenough.42seoul.kr/") {
            print("before complete")
            webView.configuration.websiteDataStore.httpCookieStore.getAllCookies { cookies in
                for cookie in cookies {
                    if cookie.name == DataShelter.shared.keyName {
                        let group = DispatchGroup()
                        
                        DataShelter.shared.token = cookie.value
                        
                        group.enter()
                        DataShelter.shared.fetchAllData {
                            group.leave()
                        }
                        
                        group.notify(queue: .main) {
                            self.webView.removeFromSuperview()
                            NotificationCenter.default.post(name: .fetched, object: nil)
                            self.dismiss(animated: true)
                        }
                    }
                }
            }
        }
    }
}

//    func getHTML(_ completion: @escaping ([String: String]) -> ()) {
//        webView.evaluateJavaScript("document.getElementsByTagName('pre')[0].innerHTML") { (html, error) in
//            guard var data = html as? String else {
//                print("erorror")
//                return
//            }
//            print(data)
//            data.removeAll { char in
//                if "{}\"".contains(char)  {
//                    return true
//                } else {
//                    return false
//                }
//            }
//            if data.isEmpty {
//                print("empty string")
//                return
//            } else {
//                let parsedData = data.split(separator: ":")
//                if parsedData[0] == "accessToken" {
//                    let token: [String: String] = [String(parsedData[0]): String(parsedData[1])]
//                    completion(token)
//                }
//            }
//        }
//    }
//
