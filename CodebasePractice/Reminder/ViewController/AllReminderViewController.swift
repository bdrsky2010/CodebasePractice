//
//  AllReminderViewController.swift
//  CodebasePractice
//
//  Created by Minjae Kim on 7/3/24.
//

import UIKit

import RealmSwift

final class AllReminderViewController: BaseViewController {
    
    private let allReminderView = AllReminderView()
    
    private var allReminderList: Results<Reminder>!
    
    var delegate: ReminderUpdateDelegate?
    
    override func loadView() {
        view = allReminderView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let realm = try! Realm()
        allReminderList = realm.objects(Reminder.self).sorted(byKeyPath: "registerDate", ascending: true)
        
        configureNavigation()
        configureTableView()
    }
    
    private func configureNavigation() {
        
    }
    
    private func configureTableView() {
        allReminderView.reminderTableView.delegate = self
        allReminderView.reminderTableView.dataSource = self
        allReminderView.reminderTableView.register(ReminderTableViewCell.self, forCellReuseIdentifier: ReminderTableViewCell.identifier)
        allReminderView.reminderTableView.rowHeight = UITableView.automaticDimension
    }
}

extension AllReminderViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // 1. 추가나 삭제 등 데이터가 바뀌면 테이블뷰도 갱신
        // 2. 왜 항상 try 구문 내에서 코드를 써야 하나? transaction
        // 3. 테이블 컬럼이 변경되면 왜 앱이 꺼지지???
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, success in
            guard let self else {
                success(false)
                return
            }
            let realm = try! Realm()

            let reminder = allReminderList[indexPath.row]
            try! realm.write {
                realm.delete(reminder)
            }
            tableView.deleteRows(at: [indexPath], with: .bottom)
            delegate?.reloadMainCollectionView()
            success(true)
        }
        deleteAction.image = UIImage(systemName: "trash.fill")
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allReminderList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ReminderTableViewCell.identifier, for: indexPath) as? ReminderTableViewCell else { return UITableViewCell()}
        
        let index = indexPath.row
        let reminder = allReminderList[index]
        cell.configureContent(title: reminder.title, content: reminder.content, date: reminder.deadline)
        
        return cell
    }
    
    
}
