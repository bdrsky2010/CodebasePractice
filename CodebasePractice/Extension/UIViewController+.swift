//
//  UIViewController+.swift
//  CodebasePractice
//
//  Created by Minjae Kim on 6/7/24.
//

import UIKit

extension UIViewController {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UIViewController {
    
    enum AlertActionType {
        case oneButton
        case twoButton
    }
    
    func presentAlert(option alertActionType: AlertActionType,
                      title: String,
                      message: String? = nil,
                      checkAlertTitle: String,
                      completionHandler: ((UIAlertAction) -> Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        switch alertActionType {
        case .oneButton:
            let check = UIAlertAction(title: checkAlertTitle, style: .default)
            alert.addAction(check)
        case .twoButton:
            let cancel = UIAlertAction(title: "취소", style: .cancel)
            let check = UIAlertAction(title: checkAlertTitle, style: .default, handler: completionHandler)
            alert.addAction(cancel)
            alert.addAction(check)
        }
        
        present(alert, animated: true)
    }
    
    func presentNetworkErrorAlert(error: NetworkError) {
        let title = error.alertTitle
        let message = error.alertMessage
        
        presentAlert(option: .oneButton, title: title, message: message, checkAlertTitle: "확인")
    }
}

// MARK: 공통적으로 사용되는 API 요청 메서드 통합
extension UIViewController {
    
    // MARK: qos 설정 불가능한 메서드
    func requestAPI<T: Decodable>(api: APIURL, completionHandler: @escaping (T) -> Void) {
        guard let url = api.urlComponents?.url else { return }
        
        do {
            let request = try URLRequest(url: url, method: .get, headers: api.headers)
            
            DispatchQueue.global().async {
                NetworkManager.shared.requestAPI(request: request, of: T.self) { [weak self] result in
                    guard let self else { return }
                    
                    switch result {
                    case .success(let value):
                        completionHandler(value)
                    case .failure(let error):
                        presentNetworkErrorAlert(error: error)
                    }
                }
            }
        } catch {
            presentNetworkErrorAlert(error: .failedRequest)
        }
    }
    
    // MARK: qos 설정 가능한 메서드
    func requestAPI<T: Decodable>(qos: DispatchQoS.QoSClass, api: APIURL, completionHandler: @escaping (T) -> Void) {
        guard let url = api.urlComponents?.url else { return }
        
        do {
            let request = try URLRequest(url: url, method: .get, headers: api.headers)
            
            DispatchQueue.global(qos: qos).async {
                NetworkManager.shared.requestAPI(request: request, of: T.self) { [weak self] result in
                    guard let self else { return }
                    
                    switch result {
                    case .success(let value):
                        completionHandler(value)
                    case .failure(let error):
                        presentNetworkErrorAlert(error: error)
                    }
                }
            }
        } catch {
            presentNetworkErrorAlert(error: .failedRequest)
        }
    }
}
