//
//  ImageSession.swift
//  WechatMoment
//
//  Created by lieon on 2019/6/24.
//  Copyright © 2019 lieon. All rights reserved.
//

import Foundation
import UIKit

class LeeImageManager {
    static let shared: LeeImageManager = LeeImageManager()
    fileprivate lazy var images: [String: UIImage] = [:]
    fileprivate lazy var operations: [String: Operation] = [:]
    fileprivate lazy var datas: [URL] = []
    fileprivate lazy var queue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 5
        return queue
    }()
    
    private init() {}
    
    func retrieveImage(_ url: URL,
                       successCallback: ((UIImage) -> Void)?,
                       failCallBack:(() -> Void)?) {
        let cachedImage = images[url.absoluteString]
        if let image = cachedImage {
            successCallback?(image)
        } else {
            let filePath = imageCachePath(url)
            let fileURL = URL(fileURLWithPath: filePath)
            if let data = try? Data(contentsOf: fileURL, options: .mappedIfSafe), let image = UIImage(data: data){
                successCallback?(image)
            } else {
                downloadImage(url, successCallback: successCallback, failCallBack: failCallBack)
            }
        }
    }
    
    fileprivate func imageCachePath(_ url: URL) -> String {
        var cachPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last
        cachPath!.append("/")
        cachPath!.append(url.lastPathComponent)
        debugPrint("cachPath:\(cachPath ?? "") - url:\(url)")
        return cachPath!
    }
    
    fileprivate func downloadImage(_ url: URL,
                                   successCallback: ((UIImage) -> Void)?,
                                   failCallBack:(() -> Void)?) {
        var existOpertaion = operations[url.absoluteString]
        if existOpertaion != nil {
            return
        }
        existOpertaion = BlockOperation(block: {
            if let imageData = try? Data(contentsOf: url), let image = UIImage(data: imageData) {
                OperationQueue.main.addOperation({
                    self.images[url.absoluteString] = image
                    let data = image.pngData()
                    let fileURL = URL(fileURLWithPath: self.imageCachePath(url))
                    try? data?.write(to: fileURL, options: Data.WritingOptions.atomic)
                    self.operations.removeValue(forKey: url.absoluteString)
                    successCallback?(image)
                })
                
            } else {
                OperationQueue.main.addOperation({
                    self.operations.removeValue(forKey: url.absoluteString)
                    failCallBack?()
                })
            }
            
        })
        operations[url.absoluteString] = existOpertaion!
        queue.addOperation(existOpertaion!)
    }
}

public struct LeeWrapper<Base> {
    public let base: Base
    public init(_ base: Base) {
        self.base = base
    }
}

extension LeeWrapper where Base: UIImageView {
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
