//
//  RequestRetrier.swift
//  Rx.swiftPractise
//
//  Created by 白海瑞 on 2018/8/13.
//  Copyright © 2018年 Rx.Swift. All rights reserved.
//

import Foundation
import Alamofire


struct RequestRetrie: RequestRetrier{
    func should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion) {
        if let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 {
            completion(true, 1.0)
        } else {
            completion(false, 0.0)
        }
    }
    
}
