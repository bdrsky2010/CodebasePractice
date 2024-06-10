//
//  RequestAPIFromAFProtocol.swift
//  CodebasePractice
//
//  Created by Minjae Kim on 6/7/24.
//

import UIKit
import Alamofire

protocol RequestAPIFromAFProtocol where Self: UIViewController {
    func requestDecodableCustomTypeResult<T: Decodable>(urlString url: String,
                                                        method: HTTPMethod,
                                                        parameters: Parameters?,
                                                        encoding: ParameterEncoding,
                                                        headers: HTTPHeaders?,
                                                        type: T.Type,
                                                        successClosure: ((_ value: T) -> Void)?,
                                                        failClosure: ((_ error: AFError) -> Void)?)
    
    func requestStringResult(urlString url: String,
                             method: HTTPMethod,
                             parameters: Parameters?,
                             encoding: ParameterEncoding,
                             headers: HTTPHeaders?,
                             successClosure: ((_ value: String) -> Void)?,
                             failClosure: ((_ error: AFError) -> Void)?)
}

extension RequestAPIFromAFProtocol where Self: UIViewController {
    func requestDecodableCustomTypeResult<T: Decodable>(urlString url: String,
                                                        method: HTTPMethod = .get,
                                                        parameters: Parameters? = nil,
                                                        encoding: ParameterEncoding,
                                                        headers: HTTPHeaders? = nil,
                                                        type: T.Type,
                                                        successClosure: ((_ value: T) -> Void)? = nil,
                                                        failClosure: ((_ error: AFError) -> Void)? = nil) {
        
        AF.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers)
            .responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let value):
                successClosure?(value)
            case .failure(let error):
                failClosure?(error)
            }
        }
    }
    
    func requestStringResult(urlString url: String,
                             method: HTTPMethod = .get,
                             parameters: Parameters? = nil,
                             encoding: ParameterEncoding,
                             headers: HTTPHeaders? = nil,
                             successClosure: ((_ value: String) -> Void)? = nil,
                             failClosure: ((_ error: AFError) -> Void)? = nil) {
        AF.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers)
            .responseString { response in
            switch response.result {
            case .success(let value):
                successClosure?(value)
            case .failure(let error):
                failClosure?(error)
            }
        }
    }
}
