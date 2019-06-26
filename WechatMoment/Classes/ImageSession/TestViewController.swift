//
//  TestViewController.swift
//  WechatMoment
//
//  Created by lieon on 2019/6/24.
//  Copyright © 2019 lieon. All rights reserved.
//

import UIKit
import RxSwift

class TestViewController: UIViewController {
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       let url = URL(string: "https://thoughtworks-mobile-2018.herokuapp.com/images/tweets/008.jpeg")!
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: OperationQueue.main)
       let task = session.downloadTask(with: URLRequest(url: url))
       task.resume()
       view.backgroundColor = .white
        
        let btn = UIButton(type: .contactAdd)
        btn.frame = CGRect(x: 100, y: 100, width: 40, height: 40)
        view.addSubview(btn)
        btn.rx.tap.mapToVoid()
            .subscribe(onNext: { () in
                self.showMenu()
            })
            .disposed(by: bag)
    }
    

    fileprivate func showMenu() {
        becomeFirstResponder()
        let copyItem = UIMenuItem(title: "拷贝", action: #selector(self.copyAction))
        UIMenuController.shared.menuItems = [copyItem]
        UIMenuController.shared.setTargetRect(CGRect(x: 100, y: 200, width: 40, height: 40), in: self.view)
        UIMenuController.shared.setMenuVisible(true, animated: true)
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    @objc fileprivate func copyAction() {
        let pasteboard = UIPasteboard.general
        pasteboard.string = "contentLabel.text"
        UIMenuController.shared.setMenuVisible(false, animated: true)
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
