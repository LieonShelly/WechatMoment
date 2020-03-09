//
//  MomentRefreshView.swift
//  WechatMoment
//
//  Created by lieon on 2019/6/23.
//  Copyright © 2019 lieon. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

@IBDesignable
class MomentRefreshView: UIView {
    struct UISize {
        static let width: CGFloat = 60
        static let height: CGFloat = 60
        static let xDelata: CGFloat = 47
        static let minOffsetY: CGFloat = -64
    }
    
    struct Keys {
        static let animationKey = "animation"
        static let positionKey = "position"
    }
    
    enum HeaderStatus: Int {
        case normal = 0
        case refreshing = 1
        case willRefresh = 2
    }
    
    var refreshAction: (() -> Void)?
    
    fileprivate var scrollView: UIScrollView?
    
    fileprivate lazy var imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "refresh_icon"))
        return imageView
    }()
    
    var rotationAnimation: CABasicAnimation = {
       let anima = CABasicAnimation()
        anima.keyPath = "transform.rotation.z"
        anima.fromValue = 0
        anima.toValue = Float.pi * 2
        anima.duration =  1
        anima.repeatCount = Float.infinity
        return anima
    }()
    
    fileprivate var status: HeaderStatus = .normal {
        didSet {
            switch status {
            case .normal:
                layer.removeAnimation(forKey: Keys.animationKey)
                self.transform = CGAffineTransform.identity
                let postion = CABasicAnimation()
                postion.keyPath = "position"
                postion.fromValue = self.center
                postion.toValue = CGPoint(x: center.x, y: -center.y)
                postion.duration = 0.5
                postion.delegate = self
                layer.add(postion, forKey: Keys.positionKey)
            case .willRefresh:
                 self.alpha = 1
                isHidden = false
            case .refreshing:
                refreshAction?()
                 self.alpha = 1
                layer.add(rotationAnimation, forKey: Keys.animationKey)

            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configUI()
    }
    
    fileprivate func configUI() {
        addSubview(imageView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    static func loadView(with center: CGPoint) -> MomentRefreshView {
        let view = MomentRefreshView()
        view.center = center
        view.frame.size = CGSize(width: 30, height: 30)
        view.isHidden = true
        return view
    }
    
    func endRefresh() {
        if status.rawValue == HeaderStatus.refreshing.rawValue {
            status = .normal
        }
    }
    
    func configScrollView(_ scrollView: UIScrollView) {
        self.scrollView = scrollView
        scrollView.addObserver(self, forKeyPath: "contentOffset", options: NSKeyValueObservingOptions.new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentOffset" {
            update(scrollView?.contentOffset.y ?? 0)
        }
    }
    
    fileprivate func update(_ offsetY: CGFloat) {
        var offsetY = offsetY
        if offsetY < UISize.minOffsetY {
            offsetY = UISize.minOffsetY
        }
        if self.scrollView!.isDragging, status.rawValue != HeaderStatus.willRefresh.rawValue {
            self.status = .willRefresh
        } else if self.scrollView!.isDragging == false, status.rawValue == HeaderStatus.willRefresh.rawValue, offsetY == 0{
            self.status = .refreshing
        }
        if self.status.rawValue == HeaderStatus.refreshing.rawValue {
            return
        }
        let rotateValue = CGFloat(Float.pi) * offsetY / UISize.xDelata
        let translate = CGAffineTransform(translationX: 0, y: -offsetY)
        self.transform = translate
        self.transform = self.transform.rotated(by: rotateValue)
    }

    deinit {
        scrollView?.removeObserver(self, forKeyPath: "contentOffset")
    }
}


extension MomentRefreshView: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        guard let anima = anim as? CABasicAnimation else {
            return
        }
        guard anima.keyPath == Keys.positionKey, flag == true else {
            return
        }
        layer.removeAllAnimations()
        isHidden = true
    }
}



extension Reactive where Base: MomentRefreshView {
    var momentHeaderRefreshStatus: Binder<RefreshStatus> {
        return Binder<RefreshStatus>(base, scheduler: MainScheduler.instance, binding: { (control, value) in
            switch value {
            case .endHeaderRefresh:
               control.endRefresh()
            default:
                break
            }
        })
    }
}
