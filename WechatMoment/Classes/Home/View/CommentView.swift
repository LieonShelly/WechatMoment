//
//  CommentView.swift
//  WechatMoment
//
//  Created by lieon on 2019/6/15.
//  Copyright © 2019 lieon. All rights reserved.
//

import UIKit

protocol CommentData {
    var username: String { get }
    var contentText: String { get }
    
}

@IBDesignable
class CommentView: UITableView {

    struct UISize {
        static let width: CGFloat = UIScreen.main.bounds.width - 10 - 10 - 10 - 40
        static let padding: CGFloat = 3
    }
    fileprivate var rowHeights: [String: CGFloat] = [:]
    fileprivate var totalHeight: CGFloat = 0
    
    var datas: [CommentData] = []
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configUI()
    }
    
    func configData(_ data: [CommentData]) {
        datas = data
        let sizeResult = CommentView.caculateSize(data)
        rowHeights = sizeResult.0
        totalHeight = sizeResult.1
        frame.size.height = totalHeight
        reloadData()
    }
    
    fileprivate func configUI() {
        registerNibWithCell(CommentTableViewCell.self)
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        isScrollEnabled = false
        delegate = self
        dataSource = self
    }
    
    static func caculateSize(_ datas: [CommentData]) -> ([String: CGFloat], CGFloat){
        var rowHeights: [String: CGFloat] = [:]
        var totalHeight: CGFloat = 0
        for comment in datas {
            let rowText = comment.username + "：" + comment.contentText
            let rowHeight = rowText.height(fontSize: 15, width: UISize.width)
            rowHeights[comment.contentText] = rowHeight
            totalHeight += rowHeight
        }
        return (rowHeights, totalHeight + CGFloat((datas.count - 1) ) * UISize.padding)
    }
}

extension CommentView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = datas[indexPath.row]
        let rowHeight = rowHeights[model.contentText]
        return rowHeight ?? 0
    }
}

extension CommentView: UITableViewDataSource {
    override func numberOfRows(inSection section: Int) -> Int {
         return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(CommentTableViewCell.self, for: indexPath)
        cell.selectionStyle = .none
        cell.config(datas[indexPath.row])
        return cell
    }
}

