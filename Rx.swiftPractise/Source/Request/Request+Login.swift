//
//  Request+Login.swift
//  Rx.swiftPractise
//
//  Created by 白海瑞 on 2018/8/15.
//  Copyright © 2018年 Rx.Swift. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

struct LoginService {
    typealias CompletionLogin = (MainModel) -> Swift.Void
    static func login(params:[String : Any] ,completion: @escaping CompletionLogin) -> Disposable?{
        
        let req = RequestSettings(ServiceURL.Login.base, params:params)
        return SessionManager.default.rx.requestModel(request: req)
            .subscribe(onNext: { (res:ResponseModel<[String:Any]>) in
                do {
                    let data = try JSONSerialization.data(withJSONObject: res.result!, options: .prettyPrinted)
                    let model = try JSONDecoder().decode(MainModel.self, from: data)
                    completion(model)
                }catch {
                    
                }
            }, onError: { (error) in
                
            })
    }
}

struct RequestSettings: RequestProtocol {
    var url: String
    var method: Alamofire.HTTPMethod
    var headers: [String : String]?
    var params: [String : Any]?
    init(_ url: String, method: HTTPMethod = .post, params: [String : Any]?, headers: [String : String]? = nil) {
        self.url = url
        self.method = method
        self.params = params
        self.headers = headers
    }

}
