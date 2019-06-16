//
//  UIDeviceExtension.swift
//  WechatMoment
//
//  Created by lieon on 2019/6/15.
//  Copyright © 2019 lieon. All rights reserved.
//

import Foundation
import UIKit


extension UIDevice {
    
    var isiPhoneXSeries: Bool {
        if self.userInterfaceIdiom != UIUserInterfaceIdiom.phone {
            return false
        }
        if #available(iOS 11.0, *) {
            guard let mainWindow = UIApplication.shared.keyWindow  else {
                return false
            }
            if mainWindow.safeAreaInsets.bottom > 0.0 {
                return true
            }
        }
        return false
    }
    
    var safeAreaInsets: UIEdgeInsets {
        if self.userInterfaceIdiom != UIUserInterfaceIdiom.phone {
            return .zero
        }
        if #available(iOS 11.0, *) {
            guard let mainWindow = UIApplication.shared.keyWindow  else {
                return .zero
            }
            return mainWindow.safeAreaInsets
        }
        return .zero
    }
}


