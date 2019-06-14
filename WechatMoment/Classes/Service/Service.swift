//
//  Service.swift
//  WechatMoment
//
//  Created by lieon on 2019/6/14.
//  Copyright © 2019 lieon. All rights reserved.
//
/*
 https://thoughtworks-mobile-2018.herokuapp.com/user/jsmith
 https://thoughtworks-mobile-2018.herokuapp.com/user/jsmith/tweets
 */
import Foundation
import Moya

protocol AppTargetType: TargetType {
    var publicParam: [String: Any] { get}
}

extension AppTargetType {
    var baseURL: URL {
        return URL(string: "https://thoughtworks-mobile-2018.herokuapp.com")!
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    var publicParam: [String: Any] {
        let param: [String: Any] = [String: Any]()
        return param
    }
    
    var sampleData: Data {
        return Data()
    }
}


enum HomeService: AppTargetType {
    case userProfile
    case tweetList
    
    var method: Moya.Method {
        return .get
    }
    
    var path: String {
        switch self {
        case .tweetList:
            return "/user/jsmith/tweets"
        case .userProfile:
            return "/user/jsmith"
        }
    }
    
    var task: Task {
        return .requestParameters(parameters: publicParam, encoding: URLEncoding.default)
    }
}
