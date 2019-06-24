//
//  Protocol.swift
//  WechatMoment
//
//  Created by lieon on 2019/6/25.
//  Copyright © 2019 lieon. All rights reserved.
//

import Foundation
import UIKit

public struct LeeWrapper<Base> {
    public let base: Base
    public init(_ base: Base) {
        self.base = base
    }
}

extension LeeWrapper where Base: UIImageView {
    /// FIXME: cell中的imageView不能刷新
    func setImage( _ url: URL,
                   successCallback: ((UIImage) -> Void)? = nil,
                   failCallBack:(() -> Void)? = nil) {
        LeeImageManager.shared.retrieveImage(url, successCallback: { (image) in
            self.base.image = image
            successCallback?(image)
        }, failCallBack: failCallBack)
    }
}


public protocol LeeCompatible: AnyObject { }

extension LeeCompatible {
    public var lee: LeeWrapper<Self> {
        get { return LeeWrapper(self) }
        set { }
    }
}

extension UIImageView: LeeCompatible {}


protocol Downloadable {
    func downloadImage(_ url: URL,
                       successCallback: ((UIImage) -> Void)?,
                       failCallBack:(() -> Void)?)
}

protocol Cacheable {
    func imageCachePath(_ url: URL) -> String
}

extension Cacheable {
    func imageCachePath(_ url: URL) -> String {
        var cachPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last
        cachPath!.append("/")
        cachPath?.append("com.Lee.ImageCache")
        cachPath!.append("/")
        if !FileManager.default.fileExists(atPath: cachPath!) {
            try? FileManager.default.createDirectory(at: URL(fileURLWithPath: cachPath!), withIntermediateDirectories: true, attributes: nil)
        }
        cachPath!.append(url.lastPathComponent)
        debugPrint("cachPath:\(cachPath ?? "") - url:\(url)")
        return cachPath!
    }
}

