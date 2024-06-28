//
//  UIViewController+.swift
//  CodebasePractice
//
//  Created by Minjae Kim on 6/7/24.
//

import UIKit

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
