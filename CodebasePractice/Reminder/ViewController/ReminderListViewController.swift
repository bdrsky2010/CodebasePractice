//
//  ReminderListViewController.swift
//  CodebasePractice
//
//  Created by Minjae Kim on 7/3/24.
//

import UIKit

import RealmSwift

final class ReminderListViewController: BaseViewController {
    
    private let allReminderView = AllReminderView()
    
//    private var reminderList: LazyFilterSequence<Results<Reminder>>!
    private var reminderList: LazyFilterSequence<Results<Reminder>>!
    private var list: [Reminder] = []
    
    weak var delegate: ReminderUpdateDelegate?
    
    var reminderOption: ReminderOption?
    
    override func loadView() {
        view = allReminderView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let reminderOption {
            configureList(reminderOption: reminderOption)
        }
        configureNavigation()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func configureNavigation() {
        navigationItem.title = "전체"
    }
    
    private func configureTableView() {
        allReminderView.reminderTableView.delegate = self
        allReminderView.reminderTableView.dataSource = self
        allReminderView.reminderTableView.register(ReminderTableViewCell.self, forCellReuseIdentifier: ReminderTableViewCell.identifier)
        allReminderView.reminderTableView.rowHeight = UITableView.automaticDimension
    }
    
    func configureList(reminderOption: ReminderOption) {
        let realm = try! Realm()
        let tempList = realm.objects(Reminder.self).sorted(byKeyPath: "registerDate", ascending: true).filter { _ in true }
        switch reminderOption {
        case .today:
            list = tempList.filter {
                if let deadline = $0.deadline {
                    return deadline.isToday
                }
                return false
            }
            reminderList = tempList.filter {
                if let deadline = $0.deadline {
                    return deadline.isToday
                }
                return false
            }
        case .schedule:
            list = tempList.filter {
                if let deadline = $0.deadline {
                    return deadline.isSchedule
                }
                return false
            }
            
            reminderList = tempList.filter {
                if let deadline = $0.deadline {
                    return deadline.isSchedule
                }
                return false
            }
        case .all:
            list = tempList.filter{ _ in true }
            reminderList = tempList
        case .flag:
            list = tempList.filter { $0.flag }
            reminderList = tempList.filter { $0.flag }
        case .completed:
            list = tempList.filter { $0.isComplete }
            reminderList = tempList.filter { $0.isComplete }
        }
        allReminderView.reminderTableView.reloadData()
    }
}

extension ReminderListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // 1. 추가나 삭제 등 데이터가 바뀌면 테이블뷰도 갱신
        // 2. 왜 항상 try 구문 내에서 코드를 써야 하나? transaction
        // 3. 테이블 컬럼이 변경되면 왜 앱이 꺼지지???
        let reminder = reminderList[indexPath.row]
        let realm = try! Realm()
        
        let detailAction = UIContextualAction(style: .normal, title: "세부사항") { [weak self] _, view, success in
            guard let self else {
                success(false)
                return
            }
            print("detailAction")
            success(true)
        }
        detailAction.backgroundColor = UIColor.systemGray
        
        let flagAction = UIContextualAction(style: .normal, title: reminder.flag ? "깃발 제거" : "깃발") { [weak self] _, view, success in
            guard let self else {
                success(false)
                return
            }
            print("flagAction")
            
            try! realm.write {
                reminder.flag.toggle()
            }
            tableView.reloadRows(at: [indexPath], with: .automatic)
            delegate?.reloadMainCollectionView()
            success(true)
        }
        flagAction.backgroundColor = UIColor.systemOrange
        
        let deleteAction = UIContextualAction(style: .destructive, title: "삭제") { [weak self] _, _, success in
            guard let self else {
                success(false)
                return
            }

            try! realm.write {
                realm.delete(reminder)
            }
            tableView.deleteRows(at: [indexPath], with: .bottom)
            delegate?.reloadMainCollectionView()
            success(true)
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction, flagAction, detailAction])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return reminderList.count
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ReminderTableViewCell.identifier, for: indexPath) as? ReminderTableViewCell else { return UITableViewCell()}
        
        let index = indexPath.row
//        let reminder = reminderList[index]
        let reminder = list[index]
        cell.configureContent(title: reminder.title, content: reminder.content, date: reminder.deadline, flag: reminder.flag)
        
        return cell
    }
    
    
}
