//
//  ReminderManager.swift
//  CodebasePractice
//
//  Created by Minjae Kim on 7/7/24.
//

import UIKit

final class ReminderManager {
    static let shared = ReminderManager()
    
    private init() { }
    
    func presentAlertWithReminderError(viewController: UIViewController, error: ReminderDatabaseError) {
        viewController.presentAlert(option: .oneButton, title: error.title, message: error.message, checkAlertTitle: "확인")
    }
}
