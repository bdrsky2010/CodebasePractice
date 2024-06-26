//
//  NetworkManager.swift
//  CodebasePractice
//
//  Created by Minjae Kim on 6/25/24.
//

import Foundation

import Alamofire

final class NetworkManager {
    static let shared = NetworkManager()
    
    private init() { }
    
    func requestAPI<T: Decodable>(urlString: String,
                                  method: HTTPMethod,
                                  parameters: Parameters?,
                                  encoding: URLEncoding,
                                  headers: HTTPHeaders?,
                                  of type: T.Type,
                                  completionHandler: @escaping(Result<T, Error>) -> Void) {
        AF.request(urlString, method: .get, parameters: parameters, encoding: encoding, headers: headers)
            .responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let value):
                completionHandler(.success(value))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
}
