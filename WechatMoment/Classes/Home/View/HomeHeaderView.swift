//
//  HomeHeaderView.swift
//  WechatMoment
//
//  Created by lieon on 2019/6/14.
//  Copyright © 2019 lieon. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class HomeHeaderView: UIView {
    @IBOutlet weak var bgView: UIImageView!
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        iconView.layer.cornerRadius = 8
        iconView.layer.masksToBounds = true
    }
    
    static func loadView() -> HomeHeaderView {
        guard let view = Bundle.main.loadNibNamed("HomeHeaderView", owner: nil, options: nil)?.first as? HomeHeaderView else {
            return HomeHeaderView()
        }
        return view
    }
    
}

extension Reactive where Base: HomeHeaderView {
    var userProfile: Binder<UserProfile> {
        return Binder<UserProfile>(base, scheduler: MainScheduler.instance, binding: { (control, value) in
            if let bgURL = URL(string: value.profile_image ?? "") {
                control.bgView.kf.setImage(with: bgURL, options: [                                                .transition(.fade(1)),
                                                                                                                  .cacheOriginalImage], completionHandler: { (result) in
                    
                })
            }
            if let iconURL = URL(string: value.avatar ?? "") {
                control.iconView.kf.setImage(with: iconURL, options: [                                                .transition(.fade(1)),
                                                                                                                  .cacheOriginalImage], completionHandler: { (result) in
                                                                                                                    switch result {
                                                                                                                    case .success(let value):
                                                                                                                        print(value.image.size)
                                                                                                                    case .failure(let error):
                                                                                                                        print(error.localizedDescription)
                                                                                                                    }
                })
            }
            control.nameLabel.text = value.nick
        })
    }
}
