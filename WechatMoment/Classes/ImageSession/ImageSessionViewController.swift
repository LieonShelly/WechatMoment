//
//  ImageSessionViewController.swift
//  WechatMoment
//
//  Created by lieon on 2019/6/24.
//  Copyright © 2019 lieon. All rights reserved.
//

import UIKit

class ImageSessionViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    fileprivate lazy var images: [String: UIImage] = [:]
    fileprivate lazy var operations: [String: Operation] = [:]
    fileprivate lazy var datas: [URL] = []
    fileprivate lazy var queue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 5
        return queue
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let urlStrs: [String] =
            [
                "https://thoughtworks-mobile-2018.herokuapp.com/images/tweets/008.jpeg",
                "https://thoughtworks-mobile-2018.herokuapp.com/images/tweets/009.jpeg",
                "https://thoughtworks-mobile-2018.herokuapp.com/images/tweets/010.jpeg",
                "https://thoughtworks-mobile-2018.herokuapp.com/images/tweets/014.jpeg",
                "https://thoughtworks-mobile-2018.herokuapp.com/images/tweets/015.jpeg",
                "https://thoughtworks-mobile-2018.herokuapp.com/images/tweets/016.jpeg",
                "https://thoughtworks-mobile-2018.herokuapp.com/images/tweets/016.jpeg",
                "https://thoughtworks-mobile-2018.herokuapp.com/images/tweets/017.jpeg",
                "https://thoughtworks-mobile-2018.herokuapp.com/images/tweets/008.jpeg",
                "https://thoughtworks-mobile-2018.herokuapp.com/images/tweets/003.jpeg",
                "https://thoughtworks-mobile-2018.herokuapp.com/images/tweets/020.jpeg",
                "https://thoughtworks-mobile-2018.herokuapp.com/images/tweets/021.jpeg",
                "https://thoughtworks-mobile-2018.herokuapp.com/images/tweets/001.jpeg",
                "https://thoughtworks-mobile-2018.herokuapp.com/images/tweets/002.jpeg",
                "https://thoughtworks-mobile-2018.herokuapp.com/images/tweets/003.jpeg"
        ]
        datas = urlStrs.map { URL(string: $0)! }
        tableView.registerClassWithCell(UITableViewCell.self)
        tableView.dataSource = self
    }

}

extension ImageSessionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(UITableViewCell.self, for: indexPath)
        let imgURL = datas[indexPath.row]
        let cachedImage = images[imgURL.absoluteString]
        if let image = cachedImage {
            /// 存在：说明图片已经下载成功，并缓存成功
            cell.imageView?.image = image
        } else {
            /// 不存在：说明p图片并为下载成功过，或者成功下载但是在images里缓存失败，需要在沙盒寻找相应的图片
            let filePath = imageCachePath(imgURL)
            let fileURL = URL(fileURLWithPath: filePath)
            if let data = try? Data(contentsOf: fileURL, options: .mappedIfSafe) {
                cell.imageView?.image = UIImage(data: data)
            } else {
                /// 沙盒不存在，下载图片
                cell.imageView?.image = UIImage(named: "refresh_icon")
                downloadImage(imgURL, indexPath: indexPath)
            }
        }
        return cell
    }
}

extension ImageSessionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}


extension ImageSessionViewController {
   fileprivate func imageCachePath(_ url: URL) -> String {
       var cachPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last
        cachPath!.append("/")
        cachPath!.append(url.lastPathComponent)
        debugPrint("cachPath:\(cachPath ?? "") - url:\(url)")
        return cachPath!
    }
    
    fileprivate func downloadImage(_ url: URL, indexPath: IndexPath) {
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
                    self.tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
                })
              
            } else {
                OperationQueue.main.addOperation({
                    self.operations.removeValue(forKey: url.absoluteString)
                    self.tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
                })
            }
            
        })
        operations[url.absoluteString] = existOpertaion!
        queue.addOperation(existOpertaion!)
    }
}
