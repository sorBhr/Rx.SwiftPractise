//
//  ResponseModel.swift
//  Rx.swiftPractise
//
//  Created by 白海瑞 on 2018/8/11.
//  Copyright © 2018年 Rx.Swift. All rights reserved.
//

import Foundation
import Alamofire
import HandyJSON

struct ResponseModel :ResponseObjectSerializable ,CustomStringConvertible{
    
    typealias T = HandyJSON
    //根据后台返回值 看是否需要声明为可选类型
    let result: Any
    
    var model: T?

    var models: [T]?
    
    let responseStatus: (statusCode: Int, msg: String)
    
    var isSuccess: Bool { return responseStatus.statusCode == 1 }
    
    var description: String {
        return """
               code = \(responseStatus.statusCode)
               msg = \(responseStatus.msg)
               model = \(String(describing: model?.toJSONString()))
               models = \(String(describing: models))
               """
    }

    @discardableResult
    mutating func transformModels<U>(_: U.Type?) -> Any? where U:HandyJSON{
        //guard let data = result else { return }
        //MARK:初始化模型
        if result is Array<Any> {
            //初始化数组模型
            models = [U].deserialize(from: result as? [Any])?.compactMap({ $0 })
            return models
        }else if result is Dictionary<String, Any> {
            //初始化字典模型
            model = U.deserialize(from: result as? [String : Any])
            return model
        }else{
            //其它类型直接用result转换
            return result
        }
        
    }
    init?(Object: Any) {
        guard let data = Object as? [String:Any] else {return nil}
        //MARK:初始化responseModel 根据后台返回字段设置
        guard
             let result = data["result"],//如果后台返回错误并不反回result 则注释掉此判断
             let code = data["code"] as? Int,
             let msg = data["msg"] as? String
        else { return nil }
        self.responseStatus = (code , msg)
        self.result = result
    }
}
