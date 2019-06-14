//
//  AppResponse.swift
//  Arab
//
//  Created by lieon on 2018/9/14.
//  Copyright © 2018年 kanshu.com. All rights reserved.
//

import Foundation
import HandyJSON


public class BaseResponse<T: HandyJSON>: Model {
    var status: ReponseResult?
    var data: T?
    
  
}


public class ReponseResult: Model {
    var code: Int = -1
    var msg: String?// = ""
}

public class BaseResponseArray<T: HandyJSON>: Model {
    var data: [T]?
    var status: ReponseResult?
    var num: Int = 0
    var cur_page: Int = 0
    var total_num: Int = 0
    var total_page: Int = 0
    var extra: Any?
}

public class NullResponse: BaseResponse<NullClass> {
    
    static func commonError(_ error: Error) -> NullResponse {
        let response = NullResponse()
        let status = ReponseResult()
        response.status = status
        status.code = -1
        status.msg = "遇到问题了哦"
        if let error = error as? AppError {
            status.msg = error.message
        }
        return response
    }
}

public class NullResponseArray: BaseResponseArray<NullClass> {
    
}


public class NullClass: HandyJSON {
    
    public required init() {
        
    }
}

open class Model: HandyJSON {

    public required init() {
        
    }
    
}

// MARK: - Model Debug String
extension Model: CustomDebugStringConvertible {
    
    public var debugDescription: String {
        var str = "\n"
        let properties = Mirror(reflecting: self).children
        for child in properties {
            if let name = child.label {
                str += name + ": \(child.value)\n"
            }
        }
        return str
    }
}

