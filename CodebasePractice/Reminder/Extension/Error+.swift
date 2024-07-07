//
//  Error+.swift
//  CodebasePractice
//
//  Created by Minjae Kim on 7/7/24.
//

import Foundation

extension Error {
    var asReminderDatabaseError: ReminderDatabaseError? {
        return self as? ReminderDatabaseError
    }
}
