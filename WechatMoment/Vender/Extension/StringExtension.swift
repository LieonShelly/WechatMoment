//
//  StringExtension.swift
//  WechatMoment
//
//  Created by lieon on 2019/6/15.
//  Copyright © 2019 lieon. All rights reserved.
//


import Foundation
import UIKit

extension String {
    func width(fontSize: CGFloat, height: CGFloat = 15) -> CGFloat {
        let font = UIFont.systemFont(ofSize: fontSize)
        let rect = NSString(string: self).boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: height), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(rect.width)
    }
    
    func width(font: UIFont, height: CGFloat = 15) -> CGFloat {
        let rect = NSString(string: self).boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: height), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(rect.width)
    }
    
    
    func height(fontSize: CGFloat, width: CGFloat) -> CGFloat {
        /*
         NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
         paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
         paragraphStyle.alignment = NSTextAlignmentLeft;
         */
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byCharWrapping
        paragraphStyle.alignment = .left
        let font = UIFont.systemFont(ofSize: fontSize)
        let rect = NSString(string: self).boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: [.usesLineFragmentOrigin], attributes: [NSAttributedString.Key.font: font, NSAttributedString.Key.paragraphStyle: paragraphStyle], context: nil)
        return ceil(rect.height)
    }
    
    var isEmpty: Bool {
        let set = CharacterSet.whitespacesAndNewlines
        let new = trimmingCharacters(in: set)
        return new.count <= 0
    }
    
    func withlineSpacing(_ space: CGFloat) -> NSAttributedString {
        let atrrStr = NSMutableAttributedString(string: self)
        let paragrapStyle = NSMutableParagraphStyle()
        paragrapStyle.lineSpacing = space
        atrrStr.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragrapStyle, range: NSRange(location: 0, length: self.count))
        return atrrStr
    }
}



extension UIColor {
    
    // MARK: - 纬度常用颜色值，颜色名来自 sip，swift 3.0写法
    /// 主色调
    class var theme: UIColor {
        return UIColor(0x00CF7A)
    }
    
    class var menu: UIColor {
        get {
            return UIColor.black.withAlphaComponent(0.85)
        }
    }
    
    class var background: UIColor {
        get {
            return UIColor(0xE9EBF4)
        }
    }
    
    /// 纯色
    convenience init(pure: CGFloat) {
        self.init(red: pure / 255.0,
                  green: pure / 255.0,
                  blue: pure / 255.0,
                  alpha: 1.0)
    }
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    //UIColor(hexValue: 0xEBEBEB)
    convenience init(_ hexValue: Int) {
        self.init(red:(hexValue >> 16) & 0xff, green:(hexValue >> 8) & 0xff, blue:hexValue & 0xff)
    }
    
    convenience init(_ hexValue: Int, alpha: Float) {
        
        let red   = CGFloat((hexValue >> 16) & 0xff)/255.0
        let green = CGFloat((hexValue >> 8) & 0xff)/255.0
        let blue  = CGFloat(hexValue & 0xff) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: CGFloat(alpha))
    }
//    
//    convenience init( _ inputHexStr: String) {
//        let inputHexStr = inputHexStr.lowercased()
//        var red: UInt32 = 0
//        var blue: UInt32 = 0
//        var green: UInt32 = 0
//        if inputHexStr.starts(with: "#") {
//            let hexStr = inputHexStr.substring(NSRange(location: 1, length: 6))
//            let rStr = hexStr.substring(NSRange(location: 0, length: 2))
//            let gStr = hexStr.substring(NSRange(location: 2, length: 2))
//            let bStr = hexStr.substring(NSRange(location: 4, length: 2))
//            Scanner(string: String(rStr)).scanHexInt32(&red)
//            Scanner(string: String(gStr)).scanHexInt32(&green)
//            Scanner(string: String(bStr)).scanHexInt32(&blue)
//        }
//        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1)
//    }
    
    //    convenience init( _ inputHexStr: String) {
    //        let inputHexStr = inputHexStr.lowercased()
    //        var red: CGFloat = 0
    //        var blue: CGFloat = 0
    //        var green: CGFloat = 0
    //
    //        if inputHexStr.starts(with: "#") {
    //            var chars = Array(inputHexStr.hasPrefix("#") ? inputHexStr.dropFirst() : inputHexStr[...])
    //            red   = CGFloat(strtoul(String(chars[0...1]), nil, 16)) / 255
    //            green = CGFloat(strtoul(String(chars[2...3]), nil, 16)) / 255
    //            blue  = CGFloat(strtoul(String(chars[4...5]), nil, 16)) / 255
    //            self.init(red: red, green: green, blue:  blue, alpha: 1)
    //        } else {
    //             self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1)
    //        }
    //    }
    
    
    //    convenience init(_ hexString: String) {
    //        var chars = Array(hexString.hasPrefix("#") ? hexString.dropFirst() : hexString[...])
    //        let red, green, blue, alpha: CGFloat
    //        switch chars.count {
    //        case 3:
    //            chars = chars.flatMap { [$0, $0] }
    //            fallthrough
    //        case 6:
    //            chars = ["F","F"] + chars
    //            fallthrough
    //        case 8:
    //            alpha = CGFloat(strtoul(String(chars[0...1]), nil, 16)) / 255
    //            red   = CGFloat(strtoul(String(chars[2...3]), nil, 16)) / 255
    //            green = CGFloat(strtoul(String(chars[4...5]), nil, 16)) / 255
    //            blue  = CGFloat(strtoul(String(chars[6...7]), nil, 16)) / 255
    //        default:
    //            return nil
    //        }
    //        self.init(red: red, green: green, blue:  blue, alpha: alpha)
    //    }
}

