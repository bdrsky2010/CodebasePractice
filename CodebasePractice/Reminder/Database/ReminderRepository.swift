//
//  ReminderRepository.swift
//  CodebasePractice
//
//  Created by Minjae Kim on 7/7/24.
//

import Foundation

import RealmSwift

enum ReminderDatabaseError: Error {
    case create
    case read
    case update
    case delete
    case schemaVesion
    
    var title: String {
        return "데이터베이스 오류"
    }
    
    var message: String {
        switch self {
        case .create:
            return "데이터베이스 생성에 문제가 발생했습니다."
        case .read:
            return "데이터베이스를 읽어오는데 문제가 발생했습니다"
        case .update:
            return "데이터베이스 업데이트에 문제가 발생했습니다"
        case .delete:
            return "데이터베이스 삭제에 문제가 발생했습니다"
        case .schemaVesion:
            return "스키마 버젼을 읽어오는데 문제가 발생했습니다"
        }
    }
}

final class ReminderRepository {
    private let realm = try! Realm()
    
    func createReminder(_ reminder: Reminder) throws {
        do {
            try realm.write {
                realm.add(reminder)
                print("Realm Create Succeed")
            }
        } catch {
            throw ReminderDatabaseError.create
        }
    }
    
    func updateReminder(value: [String: Any]) throws {
        do {
            try realm.write {
                realm.create(Reminder.self, value: value, update: .modified)
                print("Realm Update Succeed")
            }
        } catch {
            throw ReminderDatabaseError.update
        }
    }
    
    func deleteReminder(_ reminder: Reminder) throws {
        do {
            try realm.write {
                realm.delete(reminder)
                print("Realm Delete Succeed")
            }
        } catch {
            throw ReminderDatabaseError.delete
        }
    }
}
