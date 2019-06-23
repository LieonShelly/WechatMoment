//
//  UIViewController+Rx.swift
//  Arab
//
//  Created by lieon on 2018/9/6.
//  Copyright © 2018年lieon. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UIViewController {
    
    var viewDidLoad: Observable<Void> {
        return self.sentMessage(#selector(Base.viewDidLoad)).map{_ in Void() }
    }
    
    var viewWillAppear: Observable<Bool> {
        return self.sentMessage(#selector(Base.viewWillAppear(_:))).map{ $0.first as? Bool ?? false }
    }
    
    var viewDidAppear: Observable<Bool> {
        return self.sentMessage(#selector(Base.viewDidAppear(_:))).map{ $0.first as? Bool ?? false }
    }
    
    var viewDidDisappear: Observable<Bool> {
        return self.sentMessage(#selector(Base.viewDidDisappear(_:))).map{ $0.first as? Bool ?? false }
    }
    
    var viewWillDisappear: Observable<Bool> {
        return self.sentMessage(#selector(Base.viewWillDisappear(_:))).map{ $0.first as? Bool ?? false }
    }
    
}


extension Reactive where Base: UITabBarController {
    
    var viewDidLoad: Observable<Void> {
        return self.sentMessage(#selector(Base.viewDidLoad)).mapToVoid()
    }
    
    var viewWillAppear: Observable<Bool> {
        return self.sentMessage(#selector(Base.viewWillAppear(_:))).map{ $0.first as? Bool ?? false }
    }
    
    var viewDidAppear: Observable<Bool> {
        return self.sentMessage(#selector(Base.viewDidAppear(_:))).map{ $0.first as? Bool ?? false }
    }
    
    var viewDidDisappear: Observable<Bool> {
        return self.sentMessage(#selector(Base.viewDidDisappear(_:))).map{ $0.first as? Bool ?? false }
    }
    
    var viewWillDisappear: Observable<Bool> {
        return self.sentMessage(#selector(Base.viewWillDisappear(_:))).map{ $0.first as? Bool ?? false }
    }
    
}

//extension Reactive where Base: UITabBarController {
//    
//    var viewDidLoad: Observable<Void> {
//       return self.sentMessage(#selector(Base.viewDidLoad)).mapToVoid()
//    }
//    
//    var viewWillAppear: Observable<Bool> {
//        return self.sentMessage(#selector(Base.viewWillAppear(_:))).map{ $0.first as? Bool ?? false }
//    }
//    
//}
//
