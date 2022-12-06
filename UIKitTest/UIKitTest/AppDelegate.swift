//
//  AppDelegate.swift
//  UIKitTest
//
//  Created by 마석우 on 2022/08/09.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.backgroundColor = .systemBackground
        window?.rootViewController = ViewController()
        
        return true
    }
    func applicationWillEnterForeground(_ application: UIApplication) {
        print("foreground")
        NotificationCenter.default.post(name: .checkExpires, object: nil)
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        print("background")
    }
}

