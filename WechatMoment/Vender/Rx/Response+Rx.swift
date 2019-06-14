//
//  Response+Rx.swift
//  Arab
//
//  Created by lieon on 2018/9/13.
//  Copyright © 2018年lieon. All rights reserved.
//

import Moya
import RxSwift
import RxCocoa
import HandyJSON
import CryptoSwift

extension ObservableType where E == Response {
    
    func model<T: HandyJSON>(_ type: T.Type) -> Observable<T> {
        return flatMap{
            return Observable.just(try $0.model(type))
        }
    }

}


extension PrimitiveSequence where Trait == SingleTrait, Element == Moya.Response {
    
    func model<T: HandyJSON>(_ type: T.Type) -> Single<T> {
        return flatMap{
            return Single.just(try $0.model(type))
        }
    }
}

extension ObservableConvertibleType where E == Response {
    
    func logPrinter() -> Observable<E> {
        return asObservable()
            .map{
                $0.logPrinter()
                return $0
        }
    }
    
}

extension Response {
    func model<T: HandyJSON>(_ type: T.Type) throws -> T {
        print("✈ -------------------------------------------- ✈")
        print("[URL]\t:", self.request?.urlRequest?.url ?? "")
        if let paramData = request?.urlRequest?.httpBody {
            do{
                let param = try JSONSerialization.jsonObject(with: paramData, options: JSONSerialization.ReadingOptions.allowFragments)// as? [String: Any]
                print("[PARAM]\t:",param)
            }catch let e {
                print("[PARAM]\t:", String(data: paramData, encoding: String.Encoding.utf8) ?? "[ERROR]\t:\(e.localizedDescription)")
            }
        }
        
        if let header = request?.allHTTPHeaderFields {
            print("[HEADER]\t:",header)
        }
        
        guard let rawJson = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any],
            let result = rawJson?["result"] as? [String: Any],
            let status = result["status"] as? [String: Any],
            let code = status["code"] as? Int  else  {
                throw MoyaError.jsonMapping(self)
        }
        print("[RES]\t\t:",rawJson ?? "", "\n")
        if code == 0  {
            guard let ret = JSONDeserializer<T>.deserializeFrom(dict: result) else {
                throw NetError.info("加载失败，请检查网络链接")
            }
            return ret
        } else {
            let message = status["msg"] as? String  ?? ""
            print("[RES]\t\t:",rawJson ?? "", "\n")
            throw AppError(message: message, code: ErrorCode(rawValue: code) ?? .none)
        }
        
    }
    
    
    func logPrinter() {
        print("", self.request?.url ?? "======")
    }
}

