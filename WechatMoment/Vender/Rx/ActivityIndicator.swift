//
//  ActivityIndicator.swift
//  RxSwiftUtilities
//
//  Created by Krunoslav Zaher on 10/18/15.
//  Copyright © 2015 Krunoslav Zaher. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

private struct ActivityToken<E> : ObservableConvertibleType, Disposable {
    private let _source: Observable<E>
    private let _dispose: Cancelable
    
    init(source: Observable<E>, disposeAction: @escaping () -> ()) {
        _source = source
        _dispose = Disposables.create(with: disposeAction)
    }
    
    func dispose() {
        _dispose.dispose()
    }
    
    func asObservable() -> Observable<E> {
        return _source
    }
}

/**
 Enables monitoring of sequence computation.
 If there is at least one sequence computation in progress, `true` will be sent.
 When all activities complete `false` will be sent.
 */
public class ActivityIndicator : SharedSequenceConvertibleType {
    public typealias E = Bool
    public typealias SharingStrategy = DriverSharingStrategy
    
    private let _lock = NSRecursiveLock()
    private let _variable = Variable(0)
    private let _loading: SharedSequence<SharingStrategy, Bool>
    
    public init() {
        _loading = _variable.asDriver()
            .map { $0 > 0 }
            .distinctUntilChanged()
    }
    
    fileprivate func trackActivityOfObservable<O: ObservableConvertibleType>(_ source: O) -> Observable<O.E> {
        return Observable.using({ () -> ActivityToken<O.E> in
            self.increment()
            return ActivityToken(source: source.asObservable(), disposeAction: self.decrement)
        }) { t in
            return t.asObservable()
        }
    }
    
    private func increment() {
        _lock.lock()
        _variable.value = _variable.value + 1
        _lock.unlock()
    }
    
    private func decrement() {
        _lock.lock()
        _variable.value = _variable.value - 1
        _lock.unlock()
    }
    
    public func asSharedSequence() -> SharedSequence<SharingStrategy, E> {
        return _loading
    }
}

extension ObservableConvertibleType {
    public func trackActivity(_ activityIndicator: ActivityIndicator) -> Observable<E> {
        return activityIndicator.trackActivityOfObservable(self)
    }
}



import PKHUD
import RxSwift
import RxCocoa

struct HUDValue {
    let type: HUDContentType
    let delay: TimeInterval
    
    init(_ type: HUDContentType, delay: TimeInterval = 2.0) {
        self.type = type
        self.delay = delay
    }
}

extension HUD {
    
    static var flash: Binder<HUDValue> {
        return PKHUD.sharedHUD.rx.flash
    }
    
    static var loading: Binder<Bool> {
        return PKHUD.sharedHUD.rx.loading
    }
    
    static var justLoading: Binder<Bool> {
        return PKHUD.sharedHUD.rx.justLoading
    }
}

extension Reactive where Base: PKHUD {
    var flash: Binder<HUDValue> {
        UIApplication.shared.keyWindow?.endEditing(true)
        return Binder<HUDValue>(base, scheduler: MainScheduler.instance, binding: { (control, value) in
            if control.isVisible { control.hide(false) }
            DispatchQueue.main.asyncAfter(deadline: .now() +  0.25, execute: {
                control.contentView = Base.contentView(value.type)
                control.show()
                control.hide(afterDelay: value.delay) { isSuccess in
                    
                }
            })
        })
    }
    
    var loading: Binder<Bool> {
        return Binder<Bool>(base, scheduler: MainScheduler.instance, binding: { (control, value) in
            let queue = DispatchQueue.main
            queue.asyncAfter(deadline: DispatchTime.now() + 0.2, execute: {
                value ? control.loading() : control.dismiss()
            })
        })
    }
    
    var justLoading: Binder<Bool> {
        return Binder<Bool>(base, scheduler: MainScheduler.instance, binding: { (control, value) in
            let queue = DispatchQueue.main
            queue.async(execute: {
                value ? control.loading() : control.dismiss()
            })
        })
    }
}

extension PKHUD {
    
    func loading() {
        self.contentView = PKHUD.contentView(HUDContentType.progress)
        self.show(onView: UIApplication.shared.keyWindow)
    }
    
    func dismiss() {
        self.hide(false)
    }
    
    fileprivate static func contentView(_ type: HUDContentType) -> UIView {
        switch type {
        case .success: return PKHUDSuccessView()
        case .error: return PKHUDErrorView()
        case .progress: return PKHUDProgressView()
        case .image(let image): return PKHUDSquareBaseView(image: image)
        case .rotatingImage(let image):
            return PKHUDRotatingImageView(image: image, title: nil, subtitle: nil)
        case let .labeledSuccess(title, subtitle):
            return PKHUDSuccessView(title: title, subtitle: subtitle)
        case let .labeledError(title, subtitle):
            return PKHUDErrorView(title: title, subtitle: subtitle)
        case let .labeledProgress(title, subtitle):
            return PKHUDProgressView(title: title, subtitle: subtitle)
        case let .labeledImage(image, title, subtitle):
            return PKHUDSquareBaseView(image: image, title: title, subtitle: subtitle)
        case let .labeledRotatingImage(image, title, subtitle):
            return PKHUDRotatingImageView(image: image, title: title, subtitle: subtitle)
            
        case .label(let text): return PKHUDTextView(text: text)
        case .systemActivity: return PKHUDSystemActivityIndicatorView()
        case .errorTip(let text): return PKHUDErrorTipView(text)
        }
    }
}
