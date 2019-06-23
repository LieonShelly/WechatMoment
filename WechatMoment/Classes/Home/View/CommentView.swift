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
class CommentView: UIView {
    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: UITableView.Style.plain)
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        tableView.separatorColor = UIColor.clear
        tableView.isHidden = true
        return tableView
    }()
    fileprivate lazy var bgView: UIImageView = {
        let bgView = UIImageView()
        bgView.image = UIImage(named: "comment_bg")?.stretchableImage(withLeftCapWidth: 40, topCapHeight: Int(UISize.bgHeight))
        bgView.isHidden = true
        return bgView
    }()
    
    struct UISize {
        static let width: CGFloat = UIScreen.main.bounds.width - 10 - 10 - 10 - 40
        static let padding: CGFloat = 3
        static let bgHeight: CGFloat = 15
    }
    fileprivate var rowHeights: [String: CGFloat] = [:]
    fileprivate var totalHeight: CGFloat = 0
    
    var datas: [CommentData] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        bgView.frame = CGRect(x: 0, y: 0, width: bounds.size.width, height: UISize.bgHeight)
        tableView.frame = CGRect(x: 0, y: UISize.bgHeight, width: bounds.size.width, height: bounds.size.height - UISize.bgHeight)
    }
    
    func configData(_ data: [CommentData]) {
        bgView.isHidden = data.isEmpty
        tableView.isHidden = data.isEmpty
        datas = data
        let sizeResult = CommentView.caculateSize(data)
        rowHeights = sizeResult.0
        totalHeight = sizeResult.1
        frame.size.height = totalHeight
        tableView.reloadData()
        tableView.backgroundColor = UIColor.clear
    }
    
    fileprivate func configUI() {
        addSubview(tableView)
        addSubview(bgView)
        tableView.backgroundColor = UIColor.clear
        tableView.registerNibWithCell(CommentTableViewCell.self)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    static func caculateSize(_ datas: [CommentData]) -> ([String: CGFloat], CGFloat){
        var rowHeights: [String: CGFloat] = [:]
        var totalHeight: CGFloat = 0
        for comment in datas {
            let rowText = comment.username + "：" + comment.contentText
            let rowHeight = rowText.height(fontSize: 15, width: UISize.width - UISize.padding * 2)
            rowHeights[comment.contentText] = rowHeight
            totalHeight += rowHeight
        }
        if totalHeight != 0 {
             totalHeight = totalHeight + CGFloat(datas.count - 1) * UISize.padding + UISize.bgHeight
        }
        return (rowHeights, totalHeight)
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
    func numberOfRows(inSection section: Int) -> Int {
         return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(CommentTableViewCell.self, for: indexPath)
        cell.selectionStyle = .none
        cell.config(datas[indexPath.row])
        cell.separatorInset = UIEdgeInsets(top: 0, left: 10000, bottom: 0, right: 0)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame: CGRect(x: 0, y: 0, width: 2, height: 0.0001))
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0001
    }
}

