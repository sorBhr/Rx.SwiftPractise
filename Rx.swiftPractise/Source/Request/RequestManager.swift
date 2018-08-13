//
//  RequestManager.swift
//  Rx.swiftPractise
//
//  Created by 白海瑞 on 2018/8/10.
//  Copyright © 2018年 Rx.Swift. All rights reserved.
//

import Foundation
import Alamofire
import RxCocoa
import RxSwift
import HandyJSON
extension Alamofire.SessionManager:ReactiveCompatible{}

class SessionManager:Alamofire.SessionManager {
    
}

extension Reactive  where Base : Alamofire.SessionManager {

    func modelSerializer<T:HandyJSON>(
        _ url: URLConvertible,
        parameters: [String: Any]? = nil,
        _ method: Alamofire.HTTPMethod = Alamofire.HTTPMethod.get,
        encoding: ParameterEncoding = URLEncoding.default,
        headers: [String: String]? = nil
        )
        -> Observable<T>
    {
        return  Observable.create({ (observer) -> Disposable in
            let req = request(url, method: method, parameters: parameters, encoding: encoding, headers: headers).responseModel(completionHandler: { (responseModel:DataResponse<ResponseModel>) in
                switch responseModel.result {
                case .success(var res):
                    
                    let data = res.transformModels(T.self)
                    
                    guard let model = data as? T else {
                        observer.onError(ResponseError.objectSerialization(statusCode: 2000))
                        return
                    }
    
                    observer.onNext(model)
                    observer.onCompleted()
                    
                case .failure(let error):
                    observer.onError(error)
                }
            })

            return Disposables.create {
                req.cancel()
            }
        })
    }
}
