//
//  RequestAdapter.swift
//  Rx.swiftPractise
//
//  Created by 白海瑞 on 2018/8/11.
//  Copyright © 2018年 Rx.Swift. All rights reserved.
//

import Foundation
import Alamofire


//MARK:网络适配器 可以添加认证信息以及一些默认的请求头信息
struct RequestAdapte: RequestAdapter {
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var request = urlRequest
        request.addValue("", forHTTPHeaderField: "")
        return request
    }
}

