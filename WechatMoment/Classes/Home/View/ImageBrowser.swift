//
//  ImageBrowser.swift
//  WechatMoment
//
//  Created by lieon on 2019/6/15.
//  Copyright © 2019 lieon. All rights reserved.
//

import UIKit

class ImageBrowser: UIView {

    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.tintColor = UIColor.gray
        pageControl.currentPageIndicatorTintColor = UIColor.white
        return pageControl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configUI()
    }
    
    fileprivate func configUI() {
        addSubview(scrollView)
        addSubview(pageControl)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        scrollView.frame = bounds
        scrollView.delegate = self
        if UIDevice.current.isiPhoneXSeries {
            pageControl.frame = CGRect(x: 0, y: bounds.height - 80, width: UIScreen.main.bounds.width, height: 20)
        } else {
            pageControl.frame = CGRect(x: 0, y: bounds.height - 40, width: UIScreen.main.bounds.width, height: 20)
        }
    }
    
  
}

extension ImageBrowser: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x / self.frame.width)
    }
}


class ImageScrollView: UIScrollView {
    var didSingleTap: ((ImageScrollView) -> Void)?
    var didlongPress: ((ImageScrollView) -> Void)?
    var originRect: CGRect?
    
    fileprivate lazy var iamgeView: UIImageView = {
        let iamgeView = UIImageView()
        iamgeView.clipsToBounds = true
        iamgeView.contentMode = .scaleAspectFill
        iamgeView.contentScaleFactor = UIScreen.main.scale
        iamgeView.backgroundColor = UIColor.lightGray
        return iamgeView
    }()
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    func configImage(_ image: UIImage?) {
        iamgeView.image = image
    }
    
    func configContentRect(_ contentRect: CGRect) {
        iamgeView.frame = contentRect
    }
    
    func updateRect() {
        guard let picSize = iamgeView.image?.size else {
            return
        }
        let scaleX = self.frame.size.width / picSize.width
        let scaleY = self.frame.size.height / picSize.height
        if scaleX > scaleY {
            let imgViewWidth = picSize.width * scaleY
            self.maximumZoomScale = self.frame.size.width / imgViewWidth
            self.originRect = CGRect(x: self.frame.size.width / 2 - imgViewWidth / 2, y: 0, width: imgViewWidth, height: self.frame.size.height)
        } else {
            let imgViewHeight = picSize.height * scaleX
            self.maximumZoomScale = self.frame.size.height / imgViewHeight
            self.originRect = CGRect(x: 0, y: self.frame.size.height / 2 - imgViewHeight / 2, width: self.frame.size.width, height: imgViewHeight)
        }
        
        UIView.animate(withDuration: 0.25) {
            self.iamgeView.frame = self.originRect ?? .zero
        }
        
    }
    
    fileprivate func setupUI() {
        backgroundColor = UIColor.clear
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        isUserInteractionEnabled = true
        minimumZoomScale = 1.0
        bouncesZoom = false
        delegate = self
        addSubview(iamgeView)
        let doubletap = UITapGestureRecognizer()
        doubletap.addTarget(self, action: #selector(self.doubletapAction(_:)))
        doubletap.numberOfTapsRequired = 2
        addGestureRecognizer(doubletap)
        
        let singletap = UITapGestureRecognizer()
        singletap.addTarget(self, action: #selector(self.singletapAction(_:)))
        singletap.require(toFail: doubletap)
        addGestureRecognizer(singletap)
        
        let longPress = UILongPressGestureRecognizer()
        longPress.addTarget(self, action: #selector(self.longtapAction(_:)))
        addGestureRecognizer(longPress)
    }
}

extension ImageScrollView: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return iamgeView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let boundsSize = scrollView.bounds.size
        let imageframe = iamgeView.frame
        let contentSize = scrollView.contentSize
        var centerPoint = CGPoint(x: contentSize.width * 0.5, y: contentSize.height * 0.5)
        if imageframe.size.width <= boundsSize.width {
            centerPoint.x = boundsSize.width * 0.5
        }
        if imageframe.size.height < boundsSize.height {
            centerPoint.y = boundsSize.height * 0.5
        }
        iamgeView.center = centerPoint
    }
}


extension ImageScrollView {
    @objc fileprivate func doubletapAction( _ ges: UITapGestureRecognizer) {
        var cuurentZoomScale = self.zoomScale
        if cuurentZoomScale == minimumZoomScale {
            cuurentZoomScale = 0
        } else {
            cuurentZoomScale = maximumZoomScale
        }
        UIView.animate(withDuration: 0.25) {
            self.zoomScale = cuurentZoomScale
        }
    }
    
    @objc fileprivate func singletapAction( _ ges: UITapGestureRecognizer) {
        didSingleTap?(self)
    }
    
    @objc fileprivate func longtapAction( _ ges: UILongPressGestureRecognizer) {
        didlongPress?(self)
    }
}
