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
                                             type: T.Type,
                                             successClosure: @escaping (_ value: T) -> Void,
                                             failClosure: @escaping (_ error: AFError) -> Void)
}

extension RequestAPIFromAFProtocol where Self: UIViewController {
    func requestDecodableCustomTypeResult<T: Decodable>(urlString url: String,
                                             type: T.Type,
                                             successClosure: @escaping (_ value: T) -> Void,
                                                        failClosure: @escaping (_ error: AFError) -> Void) {
        
        AF.request(url).responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let value):
                successClosure(value)
            case .failure(let error):
                failClosure(error)
            }
        }
    }
}
