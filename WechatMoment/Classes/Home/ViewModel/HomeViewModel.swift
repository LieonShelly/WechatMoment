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
    /// output
    let userProfileOutput: BehaviorRelay<UserProfile> = BehaviorRelay(value: UserProfile())
    let sectionDataDriver: Driver<[SectionModel<String, Tweet>]>
    let tweetList: BehaviorRelay<[Tweet]> = BehaviorRelay(value: [])
    
    init() {
        let provider = MoyaProvider<HomeService>()
        let activity = ActivityIndicator()
      
        
        viewDidLoad.asObservable()
            .flatMap { _ in
                provider.rx.request(.userProfile)
                    .model(UserProfile.self)
                    .asObservable()
                    .trackActivity(activity)
            }
            .debug()
            .bind(to: userProfileOutput)
            .disposed(by: bag)

        viewDidLoad.asObservable()
            .flatMap {
                provider.rx.request(.tweetList)
                    .modelWithArray(Tweet.self)
                    .asObservable()
                    .trackActivity(activity)
            }
            .map({ (serverData) -> [Tweet] in
                let normalData = serverData.filter { $0.error == nil}.filter { $0.unknownError == nil}
                return normalData
            })
            .bind(to: tweetList)
            .disposed(by: bag)
        
        sectionDataDriver = tweetList.asObservable()
            .map { [SectionModel<String, Tweet>(model: "tweetList", items: $0)]}
            .asDriver(onErrorJustReturn: [])
    }
}
