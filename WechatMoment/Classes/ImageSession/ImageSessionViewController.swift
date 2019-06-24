//
//  ImageSessionViewController.swift
//  WechatMoment
//
//  Created by lieon on 2019/6/24.
//  Copyright © 2019 lieon. All rights reserved.
//

import UIKit

class ImageSessionViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
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
        imageView.lee.setImage(datas.first!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

extension ImageSessionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(UITableViewCell.self, for: indexPath)
        let imgURL = datas[indexPath.row]
        cell.imageView?.lee.setImage(imgURL)
        debugPrint("base - imageView:\(cell.imageView.debugDescription)")
        return cell
    }
    
}

extension ImageSessionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
