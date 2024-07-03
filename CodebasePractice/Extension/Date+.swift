//
//  Date+.swift
//  CodebasePractice
//
//  Created by Minjae Kim on 6/19/24.
//

import Foundation

extension Date {
    static var dateTime: String {
        let dateFormmater = DateFormatter()
        dateFormmater.locale = Locale(identifier: "ko_KR")
        dateFormmater.dateFormat = "MM월 dd일 HH시 mm분"
        return dateFormmater.string(from: Date())
    }
    
    var reminderString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 M월 d일 EEEE"
        return formatter.string(from: self)
    }
}
