//
//  NetworkManager.swift
//  CodebasePractice
//
//  Created by Minjae Kim on 6/25/24.
//

import UIKit

import Alamofire

enum NetworkError: Error {
    case unknown
    case noData
    case failedRequest
    case invalidData
    case invalidClientResponse
    case invalidServerResponse
    
    var alertTitle: String {
        switch self {
        case .unknown:
            return "알 수 없는 에러"
        case .noData:
            return "존재하지 않는 데이터"
        case .failedRequest:
            return "요청 실패"
        case .invalidData:
            return "알 수 없는 데이터"
        case .invalidClientResponse:
            return "클라이언트 요청 에러"
        case .invalidServerResponse:
            return "서버 에러"
        }
    }
    
    var alertMessage: String {
        switch self {
        case .unknown:
            return "알 수 없는 에러로 데이터를 받아오지 못하였습니다...🤔"
        case .noData:
            return "데이터가 존재하지 않아 에러가 발생하였습니다...🥲"
        case .failedRequest:
            return "요청에 실패하여 데이터를 받아오지 못하였습니다...🥺"
        case .invalidData:
            return "알 수 없는 데이터로 인해 에러가 발생하였습니다...😥"
        case .invalidClientResponse:
            return "클라이언트에서의 네트워크 연결 혹은 입력값이 잘못되어 데이터를 받아오지 못하였습니다...😭"
        case .invalidServerResponse:
            return "서버의 문제가 생겨 데이터를 받아오지 못하였습니다...😤"
        }
    }
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
    
    private func requestAPI<T: Decodable>(url: URL?, of type: T.Type, completionHandler: @escaping (Result<T, NetworkError>) -> Void) {
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
                    completionHandler(.failure(.invalidClientResponse))
                    return
                }
                
                switch response.statusCode {
                case 200..<300:
                    break
                case 400..<500:
                    print("failed response")
                    completionHandler(.failure(.invalidClientResponse))
                    return
                case 500..<600:
                    print("failed response")
                    completionHandler(.failure(.invalidServerResponse))
                    return
                default:
                    print("failed response")
                    completionHandler(.failure(.unknown))
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
    
    private func requestAPI<T: Decodable>(request: URLRequest, of type: T.Type, completionHandler: @escaping (Result<T, NetworkError>) -> Void) {
        URLSession.shared.dataTask(with: request) { data, response, error in
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
                    completionHandler(.failure(.invalidClientResponse))
                    return
                }
                
                switch response.statusCode {
                case 200..<300:
                    break
                case 400..<500:
                    print("failed response")
                    completionHandler(.failure(.invalidClientResponse))
                    return
                case 500..<600:
                    print("failed response")
                    completionHandler(.failure(.invalidServerResponse))
                    return
                default:
                    print("failed response")
                    completionHandler(.failure(.unknown))
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

// MARK: 공통적으로 사용되는 API 요청 메서드 통합 & 에러 발생 시 뷰컨트롤러에 alert 보여줌
extension NetworkManager {
    
    // MARK: qos 설정 불가능한 메서드
    func requestAPIWithAlertOnViewController<T: Decodable>(viewController: UIViewController,
                                                           api: APIURL,
                                                           completionHandler: @escaping (T) -> Void,
                                                           failureCompletionHandler: ((NetworkError) -> Void)? = nil) {
        guard let url = api.urlComponents?.url else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = api.headers
        DispatchQueue.global().async {
            NetworkManager.shared.requestAPI(request: request, of: T.self) { result in
                switch result {
                case .success(let value):
                    completionHandler(value)
                case .failure(let error):
                    failureCompletionHandler?(error)
                    viewController.presentNetworkErrorAlert(error: error)
                }
            }
        }
    }
    
    // MARK: qos 설정 가능한 메서드
    func requestAPIWithAlertOnViewController<T: Decodable>(qos: DispatchQoS.QoSClass,
                                                           viewController: UIViewController,
                                                           api: APIURL,
                                                           completionHandler: @escaping (T) -> Void,
                                                           failureCompletionHandler: ((NetworkError) -> Void)?) {
        guard let url = api.urlComponents?.url else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = api.headers
        DispatchQueue.global(qos: qos).async {
            NetworkManager.shared.requestAPI(request: request, of: T.self) { result in
                switch result {
                case .success(let value):
                    completionHandler(value)
                case .failure(let error):
                    failureCompletionHandler?(error)
                    viewController.presentNetworkErrorAlert(error: error)
                }
            }
        }
    }
}
