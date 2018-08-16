//
//  Request.swift
//  Rx.swiftPractise
//
//  Created by 白海瑞 on 2018/8/15.
//  Copyright © 2018年 Rx.Swift. All rights reserved.
//

import Foundation
import Alamofire
protocol RequestProtocol {
    var url: String { get }
    var method: Alamofire.HTTPMethod { get }
    var headers: [String: String]? { get }
    var params: [String: Any]? { get }
    init(_ url: String, method: Alamofire.HTTPMethod, params: [String: Any]?, headers: [String: String]?)
}
