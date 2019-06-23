//
//  AppError.swift
//  Arab
//
//  Created by lieon on 2018/9/12.
//  Copyright © 2018年lieon. All rights reserved.
//

import UIKit


enum ErrorCode: Int {
    case none = -1111
    case writeOrderFaile = 32301
    case tokenNull = 32302
    case recerpyDataNull = 32303
    case productIdentifierNull = 32304
    case appleOrderRetureFaile = 32305
    case productConfigNull = 32306
    case illeagalOperation = 32307
    case createOrderFaile = 32308
    case orderNotExist = 32309
    case totalMoneyError = 32310
    case totalCoinError = 32311
    case payTypeError = 32312
    case unsupportIAP = -11111
    case requestAppleProductFaile = -11112
    case getAppStoreReceiptURLFaile = -11113
    case chapterNeedPay  = 91000
    case commicPayMoneyNotEnough = 31305
    case commicReaderLastPage = 31666
    case expired = 10416
    case tribeNotHere = 31307
    case other = -1000
    
    var message: String {
        switch self {
        case .none:
            return NSLocalizedString("none", comment: "")
        case .writeOrderFaile:
            return NSLocalizedString("writeOrderFaile", comment: "")
        case .tokenNull:
            return NSLocalizedString("tokenNull", comment: "")
        case .recerpyDataNull:
            return NSLocalizedString("recerpyDataNull", comment: "")
        case .productIdentifierNull:
            return NSLocalizedString("productIdentifierNull", comment: "")
        case .appleOrderRetureFaile:
            return NSLocalizedString("appleOrderRetureFaile", comment: "")
        case .productConfigNull:
            return NSLocalizedString("productConfigNull", comment: "")
        case .illeagalOperation:
            return NSLocalizedString("illeagalOperation", comment: "")
        case .createOrderFaile:
            return  NSLocalizedString("createOrderFaile", comment: "")
        case .orderNotExist:
            return  NSLocalizedString("orderNotExist", comment: "")
        case .totalMoneyError:
            return  NSLocalizedString("totalMoneyError", comment: "")
        case .totalCoinError:
            return  NSLocalizedString("totalCoinError", comment: "")
        case .payTypeError:
            return  NSLocalizedString("payTypeError", comment: "")
        case .unsupportIAP:
            return  NSLocalizedString("unsupportIAP", comment: "")
        case .requestAppleProductFaile:
            return  NSLocalizedString("requestAppleProductFaile", comment: "")
        case .getAppStoreReceiptURLFaile:
            return  NSLocalizedString("getAppStoreReceiptURLFaile", comment: "")
        default:
            return ""
        }
    }
}


class AppError: Error {
    var message: String
    var code: ErrorCode
    
    init(message: String, code: ErrorCode) {
        self.message = message
        self.code = code
    }
}

extension AppError: LocalizedError {
    var localizedDescription: String {
        return message
    }
}

enum NetError: Error {
    case unknown
    case info(String)
}

extension NetError: LocalizedError {
    
    var errorDescription: String? {
        return localizedDescription
    }
    
    var localizedDescription: String {
        switch self {
        case .unknown:
            return "发生未知错误"
        case .info(let label):
            return label
        }
    }
    
}
