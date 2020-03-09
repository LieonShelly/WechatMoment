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

extension ObservableType where Element == Response {
    
    func model<T: HandyJSON>(_ type: T.Type) -> Observable<T> {
        return flatMap{
            return Observable.just(try $0.model(type))
        }
    }

    func modelWithArray<T: HandyJSON>(_ type: T.Type) -> Observable<[T]> {
        return flatMap{
            return Observable.just(try $0.modelWithArray(type))
        }
    }

}


extension PrimitiveSequence where Trait == SingleTrait, Element == Moya.Response {
    
    func model<T: HandyJSON>(_ type: T.Type) -> Single<T> {
        return flatMap{
            return Single.just(try $0.model(type))
        }
    }
    
    func modelWithArray<T: HandyJSON>(_ type: T.Type) -> Single<[T]> {
        return flatMap{
            return Single.just(try $0.modelWithArray(type))
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
        
        guard let rawJson = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
                throw MoyaError.jsonMapping(self)
        }
        guard let ret = JSONDeserializer<T>.deserializeFrom(dict: rawJson) else {
            throw NetError.info("加载失败，请检查网络链接")
        }
        return ret
        
    }
    
    func modelWithArray<T: HandyJSON>(_ type: T.Type) throws -> [T] {
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
        
        guard let rawJson = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [[String: Any]?] else {
            throw MoyaError.jsonMapping(self)
        }
        var response: [T] = []
        for objJson in rawJson {
            if let obj = JSONDeserializer<T>.deserializeFrom(dict: objJson) {
                response.append(obj)
            }
        }
        return response
        
    }
    
    
}

