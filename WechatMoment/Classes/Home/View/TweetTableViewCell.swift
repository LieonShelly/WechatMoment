//
//  TweetTableViewCell.swift
//  WechatMoment
//
//  Created by lieon on 2019/6/14.
//  Copyright © 2019 lieon. All rights reserved.
//  文字图片都有

import UIKit

class TweetTableViewCell: UITableViewCell {
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    @IBOutlet weak var imageContainer: ImageListView!
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var commentHeight: NSLayoutConstraint!
    @IBOutlet weak var commentView: CommentView!
    struct UISize {
        static let contentLabelWidth: CGFloat = UIScreen.main.bounds.width - 10 - 10 - 10 - 40
    }
    var tweet: Tweet?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        iconView.layer.cornerRadius  = 5
        iconView.layer.masksToBounds = true
        let longpress = UILongPressGestureRecognizer(target: self, action: #selector(self.longpressAction(_:)))
        contentLabel.isUserInteractionEnabled = true
        contentLabel.addGestureRecognizer(longpress)
    }
    
    func config(_ model: Tweet) {
        tweet = model
        if let iconUrl = URL(string: model.sender?.avatar ?? "") {
            iconView.kf.setImage(with: iconUrl, options: [                                                .transition(.fade(1)),
                                                                                                              .cacheOriginalImage], completionHandler: { (result) in
                                                                                                                
            })
        } else {
            iconView.image = nil
        }
        nameLabel.text = model.sender?.nick
        contentLabel.text = model.content
        let urlStrs = model.images?.map { $0.url ?? ""}
        let urls = urlStrs?.map { URL(string: $0)}
        var newURLs: [URL] = []
        if let urls = urls {
            for url in urls  where url != nil {
                newURLs.append(url!)
            }
        }
        imageContainer.config(newURLs)
        imageHeight.constant = imageContainer.frame.height
        if let commets = model.comments {
            commentView.configData(commets)
            commentHeight.constant = commentView.frame.size.height
        } else {
             commentHeight.constant = 0
        }
      
    }
    
    
    static func caculateCellHeight(_ data: Tweet) -> CGFloat {
        var rowHeight: CGFloat = 0
        let useNameTop: CGFloat = 10
        let userNameHeight: CGFloat = 20
        var contenLabelTop: CGFloat = 5
        var contentLabelHeight: CGFloat = 0
        
        var imageViewTop: CGFloat = 10
        var imageViewHeight: CGFloat = 0
        var imageViewBottom: CGFloat = 10
        
        var commentViewTop: CGFloat = 10
        var commentViewHeight: CGFloat = 0
        var commentViewBottom: CGFloat = 10
        if data.content?.count != 0 { /// 内容不为空
           contenLabelTop = 5
            contentLabelHeight = (data.content?.height(fontSize: 15, width: UISize.contentLabelWidth) ?? 0 ) + 10
        } else {
            contenLabelTop = 0
        }
        
        if data.images?.count != 0, data.images != nil {
            let urlStrs = data.images?.map { $0.url ?? ""}
            let urls = urlStrs?.map { URL(string: $0)}
            var newURLs: [URL] = []
            if let urls = urls {
                for url in urls  where url != nil {
                    newURLs.append(url!)
                }
            }
            imageViewTop = 10
            imageViewHeight = ImageListView.caculateHeight(newURLs)
            imageViewBottom = 10
        } else {
            imageViewTop = 0
            imageViewHeight = 0
            imageViewBottom = 0
        }
        
        if data.comments?.count != 0, data.comments != nil{
            commentViewTop = 10
            commentViewBottom = 10
            commentViewHeight = CommentView.caculateSize( data.comments!).1
        } else {
            commentViewTop = 0
            commentViewHeight = 0
            commentViewBottom = 0
        }
        
        if data.content != nil, data.images != nil {
            rowHeight = useNameTop + userNameHeight +
                contentLabelHeight + contenLabelTop +
                imageViewTop + imageViewBottom + imageViewHeight +
                commentViewHeight + commentViewBottom +
                0.5
        } else if  data.content == nil, data.images != nil {
            rowHeight = useNameTop + userNameHeight +
                imageViewTop + imageViewBottom + imageViewHeight +
                commentViewHeight + commentViewBottom +
                0.5
        } else if  data.content != nil, data.images == nil {
            rowHeight = useNameTop + userNameHeight +
                contentLabelHeight + contenLabelTop + commentViewBottom +
                commentViewHeight + commentViewBottom + 0.5
        } else if  data.content == nil, data.images == nil {
            rowHeight = useNameTop + userNameHeight + contenLabelTop +
                commentViewTop + commentViewHeight + commentViewBottom + 0.5
        }
        return rowHeight
    }
}


extension TweetTableViewCell {
    @objc fileprivate func longpressAction(_ ges: UILongPressGestureRecognizer) {
        if ges.state == .began {
            becomeFirstResponder()
            contentLabel.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
            let frame: CGRect = convert(contentLabel.frame, to: self)
            let menuFrame = CGRect(x: frame.origin.x + frame.width * 0.5, y: frame.origin.y, width: 40, height: 40)
            let copyItem = UIMenuItem(title: "拷贝", action: #selector(self.copyAction))
            UIMenuController.shared.menuItems = [copyItem]
            UIMenuController.shared.setTargetRect(menuFrame, in: self)
            UIMenuController.shared.setMenuVisible(true, animated: true)
        }
    }
    
    @objc fileprivate func copyAction() {
        let pasteboard = UIPasteboard.general
        pasteboard.string = contentLabel.text
        contentLabel.backgroundColor = UIColor.white
        UIMenuController.shared.setMenuVisible(false, animated: true)
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(self.copyAction) {
            return true
        }
        return false
    }
}
