//
//  RefreshFooterStatusView.swift
//  Arab
//
//  Created by lieon on 2018/10/25.
//  Copyright © 2018 kanshu.com. All rights reserved.
//

import Foundation
import UIKit

class RefreshFooterStatusView: UIView {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    static func loadView() -> RefreshFooterStatusView {
        guard let view = Bundle.main.loadNibNamed("RefreshFooterStatusView", owner: nil, options: nil)?.first as? RefreshFooterStatusView else {
            return RefreshFooterStatusView()
        }
      
        return view
    }
    
    func startAnimation() {
        imageView.isHidden = false
        let anima = CABasicAnimation(keyPath: "transform.rotation.z")
        anima.toValue = Float.pi * 2.0
        anima.duration = 2
        anima.isCumulative = true
        anima.repeatCount = Float.infinity
        imageView.layer.add(anima, forKey: "transform.rotation.z")
    }
    
    func stopAnimation() {
         imageView.isHidden = true
        if let _ = imageView.layer.animation(forKey: "transform.rotation.z") {
            imageView.layer.removeAnimation(forKey: "transform.rotation.z")
        }
    }

}
