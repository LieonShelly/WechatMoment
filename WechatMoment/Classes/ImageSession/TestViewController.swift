//
//  TestViewController.swift
//  WechatMoment
//
//  Created by lieon on 2019/6/24.
//  Copyright © 2019 lieon. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
       let url = URL(string: "https://thoughtworks-mobile-2018.herokuapp.com/images/tweets/008.jpeg")!
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: OperationQueue.main)
       let task = session.downloadTask(with: URLRequest(url: url))
       task.resume()
    }
    


}

extension TestViewController: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("SessionDelegate - didFinishDownloadingTo:\(location.absoluteString) ")
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        print("SessionDelegate - progress:\(String(format: "%.1f", (Float(totalBytesWritten) / Float(totalBytesExpectedToWrite))))")
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
        print("SessionDelegate - didResumeAtOffset:\(fileOffset)")
    }
}
