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


extension Alamofire.SessionManager:ReactiveCompatible{}

extension Reactive where Base: Alamofire.SessionManager {
    ///请求模型
    func requestModel<T>(request req:RequestProtocol)
        -> Observable<ResponseModel<T>>
    {
        return  Observable.create({ (observer) -> Disposable in
            let req = request(req.url, method: req.method , parameters: req.params, encoding: URLEncoding.default, headers: req.headers).responseJSON(completionHandler: { (response) in
                
                let result = response.result.flatMap({ (res) -> ResponseModel<T> in
                    guard let model = ResponseModel<T>.init(Object: res) else {
                        throw ResponseError.objectSerialization
                    }
                    guard !model.isSuccess else {throw ResponseError.codeError}
                    return model
                })
                switch result {
                case .success(let resp):
                    guard let _ = resp.result else {
                        observer.onError(ResponseError.noData)
                        return
                    }
                    observer.onNext(resp)
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
