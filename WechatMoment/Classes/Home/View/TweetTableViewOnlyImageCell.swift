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
    @IBOutlet weak var commentView: UITableView!
     @IBOutlet weak var imageHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        iconView.layer.cornerRadius  = 5
        iconView.layer.masksToBounds = true
    }
    
    func config(_ model: Tweet) {
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
        /// FIXME: 缓存行高 
        let currentRowHeight =  imageContainer.frame.maxY + 10
        layoutIfNeeded()
        
    }

    
}
