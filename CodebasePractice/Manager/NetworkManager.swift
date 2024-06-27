//
//  NetworkManager.swift
//  CodebasePractice
//
//  Created by Minjae Kim on 6/25/24.
//

import Foundation

import Alamofire

enum NetworkError: Error {
    case failedRequest
    case noData
    case invalidResponse
    case invalidData
}

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
    
    func requestAPI<T: Decodable>(url: URL?, of type: T.Type, completionHandler: @escaping (Result<T, NetworkError>) -> Void) {
        guard let url else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                guard error == nil else {
                    print("Failed Request")
                    completionHandler(.failure(.failedRequest))
                    return
                }
                
                guard let data else {
                    completionHandler(.failure(.noData))
                    return
                }
                
                guard let response = response as? HTTPURLResponse else {
                    print("Unable Response")
                    completionHandler(.failure(.invalidResponse))
                    return
                }
                
                guard response.statusCode == 200 else {
                    print("failed Response")
                    completionHandler(.failure(.invalidResponse))
                    return
                }
                
                let decoder = JSONDecoder()
                do {
                    let result = try decoder.decode(T.self, from: data)
                    completionHandler(.success(result))
                } catch {
                    completionHandler(.failure(.invalidData))
                }
            }
        }.resume()
    }
}
