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
    
    public func presentErrorAlert() {
        // 1. alert 창 구성
        let title = "오류가 발생했어요... 🤔"
        let alert = UIAlertController(title: title,
                                      message: nil,
                                      preferredStyle: .alert)
        // 2. alert button 구성
        let dismiss = UIAlertAction(title: "확인", style: .default)
        
        // 3. alert에 button 추가
        alert.addAction(dismiss)
        
        present(alert, animated: true)
    }
}
