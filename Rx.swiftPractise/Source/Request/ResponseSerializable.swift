//
//  ResponseSerializable.swift
//  Rx.swiftPractise
//
//  Created by 白海瑞 on 2018/8/12.
//  Copyright © 2018年 Rx.Swift. All rights reserved.
//

import Foundation
import Alamofire
import HandyJSON
enum ResponseError: Error {
    case netWorkError(error:Error)
    case emptyHTTPData(statusCode: Int )
    case objectSerialization(statusCode: Int )
    case inputDataNilOrZeroLength
}

protocol ResponseObjectSerializable {

    associatedtype T
    var result : Any { get }
    var model:T? { get }
    var models:[T]? { get}
    var responseStatus:(statusCode:Int , msg:String) { get }
    var isSuccess:Bool { get }
    init?(Object: Any)
}

private let emptyDataStatusCodes: Set<Int> = [204, 205]

extension Request {
    static func serializeResponseModel<T: ResponseObjectSerializable>(
        options: JSONSerialization.ReadingOptions,
        response: HTTPURLResponse?,
        data: Data?,
        error: Error?)
        -> Result<T>
    {
        guard error == nil else { return .failure(ResponseError.netWorkError(error: error!)) }//http请求错误
        
        if let response = response, emptyDataStatusCodes.contains(response.statusCode) { return .failure(ResponseError.emptyHTTPData(statusCode: (response.statusCode))) }
        
        guard let validData = data, validData.count > 0 else {
            return .failure(ResponseError.inputDataNilOrZeroLength)
        }
        
        do {
            let json = try JSONSerialization.jsonObject(with: validData, options: options)

            //MARK:初始化responseModel 在这里可以抛出接口返回错误类型
            guard let model = T(Object: json) else {
                throw ResponseError.objectSerialization(statusCode: 1000)
            }
            return .success(model)
        } catch {
            return .failure(error)
        }
    }
}

extension DataRequest {
    
    static func modelResponseSerializer<T: ResponseObjectSerializable>(
        options: JSONSerialization.ReadingOptions = .allowFragments)
        -> DataResponseSerializer<T>
    {
        return DataResponseSerializer<T> { _, response, data, error in
            return Request.serializeResponseModel(options: options, response: response, data: data, error: error)
        }
    }
    
    @discardableResult
    func responseModel<T: ResponseObjectSerializable>(
        queue: DispatchQueue? = nil,
        options: JSONSerialization.ReadingOptions = .allowFragments,
        completionHandler: @escaping (DataResponse<T>) -> Void)
        -> Self
    {
        return response(
            queue: queue,
            responseSerializer: DataRequest.modelResponseSerializer(options: options),
            completionHandler: completionHandler
        )
    }
}

extension DownloadRequest {
    static func modelResponseSerializer<T:ResponseObjectSerializable>(
        options: JSONSerialization.ReadingOptions = .allowFragments)
        -> DownloadResponseSerializer<T>
    {
        return DownloadResponseSerializer { _, response, fileURL, error in
            guard error == nil else { return .failure(error!) }
            
            guard let fileURL = fileURL else {
                return .failure(AFError.responseSerializationFailed(reason: .inputFileNil))
            }
            
            do {
                let data = try Data(contentsOf: fileURL)
                return Request.serializeResponseModel(options: options, response: response, data: data, error: error)
            } catch {
                return .failure(AFError.responseSerializationFailed(reason: .inputFileReadFailed(at: fileURL)))
            }
        }
    }
    
    @discardableResult
    func responseModel<T:ResponseObjectSerializable>(
        queue: DispatchQueue? = nil,
        options: JSONSerialization.ReadingOptions = .allowFragments,
        completionHandler: @escaping (DownloadResponse<T>) -> Void)
        -> Self
    {
        return response(
            queue: queue,
            responseSerializer: DownloadRequest.modelResponseSerializer(options: options),
            completionHandler: completionHandler
        )
    }
}




