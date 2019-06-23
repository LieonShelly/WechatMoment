//
//  Observable+Ex.swift
//  Arab
//
//  Created by lieon on 2018/9/14.
//  Copyright © 2018年 kanshu.com. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

extension ObservableType where E == Bool {
    /// Boolean not operator
    public func not() -> Observable<Bool> {
        return self.map(!)
    }
    
}

extension SharedSequenceConvertibleType {
    func mapToVoid() -> SharedSequence<SharingStrategy, Void> {
        return map { _ in }
    }
}

extension ObservableType {
    
    func catchErrorJustComplete() -> Observable<E> {
        return catchError { _ in
            return Observable.empty()
        }
    }
    
    func asDriverOnErrorJustComplete() -> Driver<E> {
        return asDriver { _ in
            //            assertionFailure()
            return Driver.empty()
        }
    }
    
    func mapToVoid() -> Observable<Void> {
        return map { _ in }
    }
}

extension ObservableType {
    /// 数组更新
    func update<T>(to variable: RxSwift.Variable<[T]>, page: inout Int) -> Disposable where T : Any, Self.E == [T] {
        
        return subscribe(onNext: { element in
//            page = 1
//            var values = variable.value
//            values.append(contentsOf: element)
//            if page > 1 {
//                variable.value = values
//            }else{
//                variable.value = element
//            }
//            page = 1
//            debugPrint(page)
        })
//        return subscribe { [page] e in
//            switch e {
//            case let .next(element):
//                var values = variable.value
//                values.append(contentsOf: element)
////                var page = page
//                if page > 1 {
//                    variable.value = values
//                }else{
//                    variable.value = element
//                }
////                page = 1
//                debugPrint(page)
//            case let .error(error):
//                debugPrint("[Rx] \(error.localizedDescription)")
//            case .completed:
//                break
//            }
//        }
    }
    
//    func filter(_ predicate: @escaping (Self.E) throws -> Bool) -> RxSwift.Observable<Self.E> {
//
//    }
    
//    func attach(_ predicate: @escaping (Self.E) throws -> Bool) -> RxSwift.Observable<Self.E> {
//
//    }
    func attach(_ page: inout Int) -> RxSwift.Observable<Self.E> {
        return map{ $0 }
    }
}
