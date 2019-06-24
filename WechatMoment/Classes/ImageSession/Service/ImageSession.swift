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
    fileprivate lazy var tasks: [URLSessionTask] = []
    
    private init() { }
    
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
}

extension LeeImageManager: Cacheable {}

extension LeeImageManager: Downloadable {
    
    func downloadImage(_ url: URL,
                       successCallback: ((UIImage) -> Void)?,
                       failCallBack:(() -> Void)?) {
        
        var existOpertaion = operations[url.absoluteString]
        if existOpertaion != nil {
            return
        }
        existOpertaion = BlockOperation(block: {
            let  session = URLSession(configuration: URLSessionConfiguration.default)
            session.downloadTask(with: url) { (resURL, response, error) in
                if let imageData = try? Data(contentsOf: resURL!), let image = UIImage(data: imageData) {
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
            }.resume()
        })
        operations[url.absoluteString] = existOpertaion!
        queue.addOperation(existOpertaion!)
    }
}
