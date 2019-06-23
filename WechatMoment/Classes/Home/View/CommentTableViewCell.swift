//
//  CommentTableViewCell.swift
//  WechatMoment
//
//  Created by lieon on 2019/6/15.
//  Copyright © 2019 lieon. All rights reserved.
//

import UIKit
// [UIColor colorWithRed:0.28 green:0.35 blue:0.54 alpha:1.0]
class CommentTableViewCell: UITableViewCell {
    @IBOutlet weak var label: UILabel!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    func config(_ comment: CommentData) {
        let userAttr = NSMutableAttributedString(string: comment.username)
        userAttr.setAttributes([NSAttributedString.Key.foregroundColor: UIColor(red: 0.28, green: 0.35, blue: 0.54, alpha: 1)], range: NSRange(location: 0, length: comment.username.count))
        let context = "：" + comment.contentText
        let contentAttr = NSMutableAttributedString(string: context)
            contentAttr.setAttributes([NSAttributedString.Key.foregroundColor: UIColor(0x333333)], range: NSRange(location: 0, length: context.count))
        let allAttr = NSMutableAttributedString()
        allAttr.append(userAttr)
        allAttr.append(contentAttr)
        label.attributedText = allAttr
    }
}
