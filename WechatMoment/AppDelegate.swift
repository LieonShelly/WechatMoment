//
//  AppDelegate.swift
//  WechatMoment
//
//  Created by lieon on 2019/6/14.
//  Copyright © 2019 lieon. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        chooseRootVc(launchOptions)
        return true
    }
    
    fileprivate func chooseRootVc(_ launchOption: [UIApplication.LaunchOptionsKey: Any]?) {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UINavigationController(rootViewController: ImageSessionViewController())// UINavigationController(rootViewController: HomeViewController(HomeViewModel())) //
        window?.makeKeyAndVisible()
        // 屏蔽控制台autolayout约束内容的输出
        UserDefaults.standard.setValue(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
    }
    


}

