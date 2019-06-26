//
//  TweetTableViewOnlyImageCell.swift
//  WechatMoment
//
//  Created by lieon on 2019/6/14.
//  Copyright © 2019 lieon. All rights reserved.
//

import UIKit

class TweetTableViewOnlyImageCell: UITableViewCell {

    @IBOutlet weak var imageContainer: ImageListView!
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
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

    
}
