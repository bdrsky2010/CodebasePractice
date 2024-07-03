//
//  ReminderModel.swift
//  CodebasePractice
//
//  Created by Minjae Kim on 7/2/24.
//

import Foundation

import RealmSwift

enum Priority: String, PersistableEnum {
    case low = "낮음"
    case mid = "중간"
    case high = "높음"
}

class Reminder: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var title: String
    @Persisted var content: String?
    @Persisted var deadline: Date?
    @Persisted var time: Date?
    @Persisted var tag: List<String>
    @Persisted var flag: Bool
    @Persisted var priority: Priority?
    @Persisted var registerDate: Date
    
    convenience init(title: String, content: String? = nil, deadline: Date? = nil, time: Date? = nil, tag: List<String> = List<String>(), priority: Priority? = nil) {
        self.init()
        self.title = title
        self.content = content
        self.deadline = deadline
        self.time = time
        self.tag = tag
        self.flag = false
        self.priority = priority
        self.registerDate = Date()
    }
}
