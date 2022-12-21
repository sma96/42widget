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
    
    deinit {
        print("@@@@@@@@@@@@@@@@@@@@webviewcontroller deinit@@@@@@@@@@@@@@@@@@@")
    }
    
    var isFirstPageLoaded: Bool = false
    var webView: WKWebView!
    let circleLoader = CircleLoaderView()

    override func viewDidLoad() {
        super.viewDidLoad()
    
        style()
        layout()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        var components = URLComponents(string: "https://api.24hoursarenotenough.42seoul.kr/user/login/42")!
        let query = [URLQueryItem(name: "redirect", value: "https://24hoursarenotenough.42seoul.kr/")]
        components.queryItems = query
        
        let request = URLRequest(url: components.url!)

        circleLoader.startAnimation()
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
        view.addSubview(circleLoader)
        
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
        if !isFirstPageLoaded {
            circleLoader.stopAnimation()
            isFirstPageLoaded = true
        }
        print("didFinish navigatio                                          \(webView.url) ")
        guard let url = webView.url?.absoluteString else {
            print("webView url error")
            return
        }
        if url.hasPrefix("https://24hoursarenotenough.42seoul.kr/") {
            print("before complete")
            webView.configuration.websiteDataStore.httpCookieStore.getAllCookies { cookies in
                for cookie in cookies {
                    print(cookie)
                    if cookie.name == DataShelter.shared.userDefaultTokenKeyName {

                        print(cookie.expiresDate)
                        DataShelter.shared.tokenExpiresDate = cookie.expiresDate
                        DataShelter.shared.token = cookie.value
                        
                        DataShelter.shared.fetchAllData { [weak self] in
                            guard let self = self else {
                                return
                            }
                            
//                            MARK: - webview 쿠키 및 data 삭제 로직
                            let websiteDataTypes = NSSet(array: [WKWebsiteDataTypeDiskCache, WKWebsiteDataTypeMemoryCache, WKWebsiteDataTypeCookies])
                            let date = NSDate(timeIntervalSince1970: 0)

                            WKWebsiteDataStore.default().removeData(ofTypes: websiteDataTypes as! Set, modifiedSince: date as Date, completionHandler:{ })
                            print("delete cache data")

                            WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(), completionHandler: {
                                (records) -> Void in
                                for record in records{
                                    WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
                                    print("delete cache data")
                                }
                            })

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
