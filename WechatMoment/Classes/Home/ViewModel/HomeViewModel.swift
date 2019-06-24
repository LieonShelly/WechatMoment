//
//  HomeViewModel.swift
//  WechatMoment
//
//  Created by lieon on 2019/6/14.
//  Copyright © 2019 lieon. All rights reserved.
//

import Foundation
import RxSwift
import RxDataSources
import Moya
import HandyJSON
import RxMoya
import RxCocoa

class HomeViewModel {
    /// input
    let viewDidLoad: PublishSubject<Void> = .init()
    let bag = DisposeBag()
    let refreshInput: PublishSubject<Bool> = .init()
    /// output
    let userProfileOutput: BehaviorRelay<UserProfile> = BehaviorRelay(value: UserProfile())
    let sectionDataDriver: Driver<[SectionModel<String, Tweet>]>
    let currentTweetList: BehaviorRelay<[Tweet]> = BehaviorRelay(value: [])
    let refreshStatus: BehaviorRelay<RefreshStatus> = BehaviorRelay(value: RefreshStatus.none)
    let laodingDriver: PublishSubject<Bool> = .init()
    var timer: Timer?
    
    init() {
        let provider = MoyaProvider<HomeService>()
        let activity = ActivityIndicator()
        let tweetList: BehaviorRelay<[Tweet]> = BehaviorRelay(value: [])
        let page: BehaviorRelay<Int> = BehaviorRelay(value: 2)
        let exceptionInput: PublishSubject<Bool> = .init()
        
        activity.asObservable()
            .bind(to: laodingDriver)
            .disposed(by: bag)
        
        Observable.merge(viewDidLoad.asObservable(),
                         refreshInput.asObservable().filter { $0 == true}.mapToVoid(),
                         exceptionInput.asObservable().filter { $0 == true}.mapToVoid())
            .flatMap { _ in
                provider.rx.request(.userProfile)
                    .model(UserProfile.self)
                    .asObservable()
                    .catchError {_ in Observable.never()}
            }
            .debug()
            .bind(to: userProfileOutput)
            .disposed(by: bag)

        ///  ignore the tweet which does not contain content and images, 这样导致数据不够
        Observable.merge(viewDidLoad.asObservable(),
                         exceptionInput.asObservable().filter { $0 == true}.mapToVoid())
            .flatMap {
                provider.rx.request(.tweetList)
                    .modelWithArray(Tweet.self)
                    .asObservable()
                    .catchError {_ in Observable.never()}
                    .trackActivity(activity)
            }
            .map({ (serverData) -> [Tweet] in
                let normalData = serverData.filter { $0.error == nil}.filter { $0.unknownError == nil}.filter { $0.unknownError == nil}.filter { $0.content != nil}//.filter { $0.images != nil}
                return normalData
            })
            .bind(to: tweetList)
            .disposed(by: bag)
        
        
        tweetList.asObservable()
            .skip(1)
            .map { (lists) -> [Tweet] in
                let endIndex = lists.count >= 5 ? 5: lists.count - 1
                return Array(lists[ 0 ..< endIndex])
            }
            .bind(to: currentTweetList)
            .disposed(by: bag)
        
        
        sectionDataDriver = currentTweetList.asObservable()
            .map { [SectionModel<String, Tweet>(model: "tweetList", items: $0)]}
            .asDriver(onErrorJustReturn: [])
        
        refreshInput.asObservable()
            .filter { $0 == true}
            .withLatestFrom(tweetList)
            .filter { $0.count >= 5}
            .map {  $0[0..<5]}
            .map { Array($0)}
            .bind(to: currentTweetList)
            .disposed(by: bag)
        
        refreshInput.asObservable()
            .filter { $0 == true}
            .withLatestFrom(tweetList)
            .filter { $0.count < 5}
            .map { Array($0)}
            .bind(to: currentTweetList)
            .disposed(by: bag)
        
         currentTweetList
            .asObservable()
<<<<<<< HEAD
=======
            .skip(1)
>>>>>>> 69b99a1062a282cc53145f01cc5fdec783b4c0fa
            .map {_ in RefreshStatus.endHeaderRefresh}
            .bind(to: refreshStatus)
            .disposed(by: bag)
        
        refreshInput.asObservable()
            .filter { $0 == false}
            .withLatestFrom(tweetList)
            .subscribe(onNext: {[weak self] (dataList) in
                guard let weakSelf = self else {
                    return
                }
                let page = page.value
                let num = 5
                let startIndex = (page - 1) * num
                var endIndex = startIndex + num
                if startIndex >= dataList.count {
                    weakSelf.refreshStatus.accept(RefreshStatus.noMoreData)
                } else {
                    endIndex = endIndex >= dataList.count ? dataList.count - 1: endIndex
                    let moreData = Array(dataList[startIndex ..< endIndex])
                    var currentListData = weakSelf.currentTweetList.value
                    currentListData.append(contentsOf: moreData)
                    weakSelf.currentTweetList.accept(currentListData)
                    weakSelf.refreshStatus.accept(RefreshStatus.endFooterRefresh)
                }
            })
            .disposed(by: bag)
        
        currentTweetList
            .asObservable()
            .withLatestFrom(refreshInput)
            .filter { $0 == false}
            .map {_ in page.value + 1}
            .bind(to: page)
            .disposed(by: bag)
        
        refreshInput.asObservable()
            .filter { $0 == true}
            .map {_ in RefreshStatus.endFooterRefresh}
            .bind(to: refreshStatus)
            .disposed(by: bag)
        
        refreshInput.asObservable()
            .filter { $0 == true}
            .map {_ in 2}
            .bind(to: page)
            .disposed(by: bag)
        
        
        let timer = Timer(timeInterval: 1, repeats: true) { (timer) in
            exceptionInput.on(.next(true))
        }
        self.timer = timer
        RunLoop.main.add(timer, forMode: RunLoop.Mode.common)
        
        tweetList
            .asObservable()
            .filter { !$0.isEmpty}
            .mapToVoid()
            .subscribe(onNext: { [weak self](_) in
                self?.timer?.invalidate()
                self?.timer = nil
                exceptionInput.on(.next(false))
                self?.laodingDriver.on(.next(false))
            })
            .disposed(by: bag)
    }
}



