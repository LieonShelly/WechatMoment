//
//  TweetTableViewOnlySenderCell.swift
//  WechatMoment
//
//  Created by lieon on 2019/6/15.
//  Copyright © 2019 lieon. All rights reserved.
//

import UIKit

class TweetTableViewOnlySenderCell: UITableViewCell {


    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var commentHeight: NSLayoutConstraint!
    @IBOutlet weak var commentView: CommentView!
    var tweet: Tweet?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        iconView.layer.cornerRadius  = 5
        iconView.layer.masksToBounds = true
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
        var currentRowHeight =  nameLabel.frame.maxY + 10
        if let commets = model.comments {
            commentView.configData(commets)
            commentHeight.constant = commentView.frame.size.height
            currentRowHeight =  commentView.frame.maxY + 10
        } else {
            commentHeight.constant = 0
        }
        tweet?.rowHegight = currentRowHeight
        layoutIfNeeded()
        
    }
}
