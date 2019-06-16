//
//  CommentTableViewCell.swift
//  WechatMoment
//
//  Created by lieon on 2019/6/15.
//  Copyright © 2019 lieon. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    func config(_ comment: CommentData) {
        let rowText = comment.username + "：" + comment.contentText
        label.text = rowText
    }
}
