//
//  SessionDelegate.swift
//  WechatMoment
//
//  Created by lieon on 2019/6/25.
//  Copyright © 2019 lieon. All rights reserved.
//

import Foundation
import UIKit

/// 监听进度用
class SessionDelegate: NSObject {
    
}

extension SessionDelegate: Cacheable {}

extension SessionDelegate: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("SessionDelegate - didFinishDownloadingTo:\(location.absoluteString) ")
        if let imageData = try? Data(contentsOf: location) {
            OperationQueue.main.addOperation({
                let fileURL = URL(fileURLWithPath: self.imageCachePath(location))
                try? imageData.write(to: fileURL, options: Data.WritingOptions.atomic)
            })
            
        } else {
            OperationQueue.main.addOperation({
                
            })
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        print("SessionDelegate - progress:\(String(format: "%.1f", (Float(totalBytesWritten) / Float(totalBytesExpectedToWrite))))")
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
        print("SessionDelegate - didResumeAtOffset:\(fileOffset)")
    }
}



