//
//  ResponseSerializable.swift
//  Rx.swiftPractise
//
//  Created by 白海瑞 on 2018/8/12.
//  Copyright © 2018年 Rx.Swift. All rights reserved.
//

import Foundation
import Alamofire


protocol ResponseObjectSerializable {
    var responseStatus:(statusCode:Int , msg:String) { get }
    var isSuccess:Bool { get }
    init?(Object: Any)
}





