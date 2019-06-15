//
//  ImageListView.swift
//  WechatMoment
//
//  Created by lieon on 2019/6/15.
//  Copyright © 2019 lieon. All rights reserved.
//

import UIKit

@IBDesignable
class ImageListView: UIView {
    struct UISize {
        static let imageWidth: CGFloat = 75
        static let imagePadding: CGFloat = 5
        static let width: CGFloat = UIScreen.main.bounds.width - 10 - 10 - 10 - 40
    }
    fileprivate lazy var imageViewArray: [UIImageView] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupImageViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupImageViews()
    }
    
    fileprivate func setupImageViews() {
        for index in ( 0 ..< 9 ) {
            let imageView = UIImageView()
            imageView.tag = index + 1000
            imageViewArray.append(imageView)
            addSubview(imageView)
        }
    }
    
    func config(_ data: [URL]) {
        imageViewArray.forEach { $0.isHidden = true}
        let imageCount = data.count
        if imageCount == 0 {
            frame.size = .zero
            return
        }
        var lastImageView: UIImageView?
        for index in (0 ..< imageCount) {
            var rowNum = index / 3
            var colNum = index % 3
            if imageCount == 4 {
                rowNum = index / 2
                colNum = index % 2
            }
            let imageX: CGFloat = CGFloat(colNum) * (UISize.imageWidth + UISize.imagePadding)
            let imageY: CGFloat = CGFloat(rowNum) * (UISize.imageWidth + UISize.imagePadding)
            var frame = CGRect(x: imageX, y: imageY, width: UISize.imageWidth, height: UISize.imageWidth)
            if imageCount == 1 {
                let singleSize = CGSize(width: 100, height: 120) /// 暂时这么写
                frame = CGRect(x: 0, y: 0, width: singleSize.width, height: singleSize.height)
            }
            lastImageView =  viewWithTag(1000 + index) as? UIImageView
            lastImageView?.isHidden = false
            lastImageView?.frame = frame
            lastImageView?.kf.setImage(with: data[index], options: [                                                .transition(.fade(1)),
                                                                                                                   .cacheOriginalImage], completionHandler: { (result) in
                                                                                                                    
            })
            self.frame.size.width = UISize.width
            self.frame.size.height = lastImageView?.frame.maxY ?? 0
        }
    }
}
