//
//  RequestManager.swift
//  Rx.swiftPractise
//
//  Created by 白海瑞 on 2018/8/10.
//  Copyright © 2018年 Rx.Swift. All rights reserved.
//

import Foundation
import Alamofire

class SessionManager {
    func test () {
        //MARK:网络请求统一接口 (Model.Type可以从中间层传进来也可以从最外层直接作为参数)
        let url = "https://example.com/users/mattt"
        request(url).responseModel { (response:DataResponse<ResponseModel>) in
            switch response.result {
            case .success(var res):
            //MARK:直接初始化模型
                res.transformModels(MainModel.self)
            case .failure(let error):
                print("error = \(error)")
            }

        }
    }
}
