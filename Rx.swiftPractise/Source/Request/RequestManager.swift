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




extension Reactive  where Base : Alamofire.SessionManager {
    
    func modelSerializer<T:Codable>(
        _ url: URLConvertible,
        parameters: [String: Any]? = nil,
        _ method: Alamofire.HTTPMethod = Alamofire.HTTPMethod.get,
        encoding: ParameterEncoding = URLEncoding.default,
        headers: [String: String]? = nil
        )
        -> Observable<(T,ResponseModel)>
    {
        return  Observable.create({ (observer) -> Disposable in
            let req = request(url, method: method, parameters: parameters, encoding: encoding, headers: headers).responseJSON(completionHandler: { (response) in
                
                let result = response.result.flatMap({ (res) -> ResponseModel in
                    guard let model = ResponseModel.init(Object: res) else {
                        throw ResponseError.objectSerialization(statusCode: 2000)
                    }
                    guard !model.isSuccess else {throw ResponseError.codeError}
                    return model
                })
                switch result {
                case .success(let res):
                    do{
                        let decoder = JSONDecoder()
                        let data = try JSONSerialization.data(withJSONObject: res.result ?? "", options: .prettyPrinted)
                        let model = try decoder.decode(T.self, from: data)
                        observer.onNext((model,res))
                        observer.onCompleted()
                    }catch {
                        observer.onError(error)
                    }

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
