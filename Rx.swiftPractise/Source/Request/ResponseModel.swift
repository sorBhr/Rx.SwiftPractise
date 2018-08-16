//
//  ResponseModel.swift
//  Rx.swiftPractise
//
//  Created by 白海瑞 on 2018/8/11.
//  Copyright © 2018年 Rx.Swift. All rights reserved.
//

import Foundation
import Alamofire


typealias Dict = Dictionary<String,Any>


enum ResponseError: Error {
    case netWorkError(error:Error)
    case emptyHTTPData
    case objectSerialization
    case inputDataNilOrZeroLength
    case codeError
    case noData
}


struct ResponseModel <U>:ResponseObjectSerializable ,CustomStringConvertible{
    //根据后台返回值 看是否需要声明为可选类型
    var result: U?
    
    let responseStatus: (statusCode: Int, msg: String)
    
    var isSuccess: Bool { return responseStatus.statusCode == 1 }
    
    var description: String {
        return """
               code = \(responseStatus.statusCode)
               msg = \(responseStatus.msg)
               result = \(String(describing: result))
               """
    }

    init?(Object: Any) {
        guard let data = Object as? [String:Any] else {return nil}
        //MARK:初始化responseModel 根据后台返回字段设置
        guard
             let code = data["code"] as? Int,
             let msg = data["msg"] as? String
        else { return nil }
        self.responseStatus = (code , msg)
        self.result = data["result"] as? U
    }
}
