//
//  TweetTableViewCell.swift
//  WechatMoment
//
//  Created by lieon on 2019/6/14.
//  Copyright © 2019 lieon. All rights reserved.
//  文字图片都有

import UIKit

class TweetTableViewCell: UITableViewCell {
    @IBOutlet weak var imageContainer: UIView!
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
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
        contentLabel.text = model.content
    }
}
