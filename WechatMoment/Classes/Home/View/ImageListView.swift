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
    var urls: [URL] = []
    fileprivate lazy var imageViewArray: [CanTapImageView] = []
    fileprivate lazy var imageBrowser: ImageBrowser = {
        let imageBrowser = ImageBrowser()
        return imageBrowser
    }()
    
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
            let imageView = CanTapImageView(frame: CGRect.zero)
            imageView.tag = index + 1000
            imageView.didTap = {[weak self] current in
                self?.didTapSmallImage(current)
            }

       
            imageViewArray.append(imageView)
            addSubview(imageView)
        }
        imageBrowser.frame = UIScreen.main.bounds
    }
    
    func config(_ data: [URL]) {
        urls = data
        imageViewArray.forEach { $0.isHidden = true}
        let imageCount = data.count
        if imageCount == 0 {
            frame.size = .zero
            return
        }
        imageBrowser.pageControl.numberOfPages = imageCount
        imageBrowser.scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width * CGFloat(imageCount), height: UIScreen.main.bounds.height)
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

extension ImageListView {
    fileprivate func didTapSmallImage(_ imageView: CanTapImageView) {
        let window = UIApplication.shared.keyWindow
        window?.addSubview(imageBrowser)
        window?.bringSubviewToFront(imageBrowser)
        for subView in imageBrowser.scrollView.subviews {
            subView.removeFromSuperview()
        }
        let imageViewIndex = imageView.tag - 1000
        let count = urls.count
        var convertRect: CGRect?
        if count == 1 {
            imageBrowser.pageControl.isHidden = true
        }
        for index in (0 ..< count) {
            guard let perImageView = viewWithTag(1000 + index) as? CanTapImageView else {
                continue
            }
            convertRect = perImageView.superview?.convert(perImageView.frame, to: window)
            let imgScrollView = ImageScrollView(frame: CGRect(x: CGFloat(index) * imageBrowser.frame.width, y: 0, width: imageBrowser.frame.width, height: imageBrowser.frame.height))
            imgScrollView.tag = 100 + index
            imgScrollView.maximumZoomScale = 2
            imgScrollView.configImage(perImageView.image)
            imgScrollView.configContentRect(convertRect ?? .zero)
            imgScrollView.didSingleTap  = { currentSv in
                
            }
            imgScrollView.didlongPress  = { currentSv in
                
            }
            imageBrowser.scrollView .addSubview(imgScrollView)
            if index == imageViewIndex {
                UIView.animate(withDuration: 0.25) {
                    self.imageBrowser.backgroundColor = UIColor.black
                    self.imageBrowser.pageControl.isHidden = false
                    imgScrollView.updateRect()
                }
            } else {
                imgScrollView.updateRect()
            }
            var offset = imageBrowser.scrollView.contentOffset
            offset.x = CGFloat(index) * UIScreen.main.bounds.width
            imageBrowser.scrollView.contentOffset = offset
            
        }
    }
}


@IBDesignable
class CanTapImageView: UIImageView {
    
    var didTap: ((CanTapImageView) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    
    fileprivate func setupUI() {
        backgroundColor = UIColor.lightGray
        contentScaleFactor = UIScreen.main.scale
        contentMode = .scaleAspectFill
        clipsToBounds = true
        isUserInteractionEnabled = true
        let imageTap = UITapGestureRecognizer()
        imageTap.addTarget(self, action: #selector(self.imageTapAction(_:)))
        addGestureRecognizer(imageTap)
        
    }
    
    @objc fileprivate func imageTapAction(_ imageView: UIImageView) {
        didTap?(self)
    }
}
