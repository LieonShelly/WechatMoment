//
//  Home.swift
//  WechatMoment
//
//  Created by lieon on 2019/6/14.
//  Copyright © 2019 lieon. All rights reserved.
//

import UIKit
import Foundation
import HandyJSON


struct UserProfile: HandyJSON {
    var profile_image: String?
    var avatar: String?
    var nick: String?
    var username: String?
   
    
    mutating func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.profile_image <-- "profile-image"
    }
}

struct ImageModel: HandyJSON {
    var url: String?
}

struct Comment: HandyJSON {
    var content: String?
    var sender: UserProfile?
}

struct Tweet: HandyJSON {
    var content: String?
    var comments: [Comment]?
    var sender: UserProfile?
    var images: [ImageModel]?
    var error: String?
    var unknownError: String?
    
    mutating func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.unknownError <-- "unknown error"
    }
    
//    mutating func didFinishMapping() {
//      self.comments =  [Comment(content: "asdfasdfsdaf", sender: UserProfile(profile_image: nil, avatar: nil, nick: nil, username: "dsasdasd")),
//         Comment(content: "asdfasdfsdaf", sender: UserProfile(profile_image: nil, avatar: nil, nick: nil, username: "dsasdasd")),
//         Comment(content: "asdfasdfsdaf", sender: UserProfile(profile_image: nil, avatar: nil, nick: nil, username: "dsasdasd")),
//         Comment(content: "asdfasdfsdaf", sender: UserProfile(profile_image: nil, avatar: nil, nick: nil, username: "dsasdasd")),
//         Comment(content: "asdfasdfsdaf", sender: UserProfile(profile_image: nil, avatar: nil, nick: nil, username: "dsasdasd"))]
//    }
}

extension Comment: CommentData {
    var contentText: String {
       return self.content ?? ""
    }
    
    var username: String {
        return self.sender?.username ?? ""
    }
}
