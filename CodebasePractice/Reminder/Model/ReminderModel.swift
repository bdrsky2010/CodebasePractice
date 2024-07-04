//
//  ReminderModel.swift
//  CodebasePractice
//
//  Created by Minjae Kim on 7/2/24.
//

import Foundation

import RealmSwift

enum Priority: String, PersistableEnum {
    case none = "없음"
    case low = "낮음"
    case mid = "중간"
    case high = "높음"
}

class Reminder: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var isComplete: Bool
    @Persisted var title: String
    @Persisted var content: String?
    @Persisted var deadline: Date?
    @Persisted var tag: List<String>
    @Persisted var flag: Bool
    @Persisted var priority: Priority
    @Persisted var imageIDs: List<String>
    @Persisted var registerDate: Date
    
    convenience init(title: String, content: String? = nil, deadline: Date? = nil, tag: List<String>, flag: Bool, priority: Priority, imageIDs: List<String>) {
        self.init()
        self.isComplete = false
        self.title = title
        self.content = content
        self.deadline = deadline
        self.tag = tag
        self.flag = flag
        self.priority = priority
        self.imageIDs = imageIDs
        self.registerDate = Date()
    }
}
