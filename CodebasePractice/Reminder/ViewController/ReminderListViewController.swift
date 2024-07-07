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
    
    private var reminderList: Results<Reminder>!
//    private var reminderList: LazyFilterSequence<Results<Reminder>>!
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
        let appearance = UINavigationBarAppearance()
        appearance.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: reminderOption?.tintColor ?? UIColor.label]
        appearance.backgroundColor = UIColor.systemBackground.withAlphaComponent(1)
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func configureNavigation() {
        if let reminderOption {
            navigationItem.title = reminderOption.title
        }
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
            reminderList = realm.objects(Reminder.self).where { $0.deadline != nil }.filter("deadline BETWEEN {%@, %@}", Date(timeInterval: -86400, since: Date()), Date())
        case .schedule:
            reminderList = realm.objects(Reminder.self).where { $0.deadline != nil }.filter("deadline BETWEEN {%@, %@} or deadline > %@", Date(timeInterval: -86400, since: Date()), Date(), Date())
        case .all:
            reminderList = realm.objects(Reminder.self)
        case .flag:
            list = tempList.filter { $0.flag }
            reminderList = realm.objects(Reminder.self).where { $0.flag }
        case .completed:
            list = tempList.filter { $0.isComplete }
            reminderList = realm.objects(Reminder.self).where { $0.isComplete }
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
        return reminderList.count
//        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ReminderTableViewCell.identifier, for: indexPath) as? ReminderTableViewCell else { return UITableViewCell()}
        
        let index = indexPath.row
        let reminder = reminderList[index]
//        let reminder = list[index]
        if let reminderOption {
            cell.configureContent(reminder, optionColor: reminderOption.tintColor)
            cell.selectedImageIDs = reminder.imageIDs.map { String($0) }
        }
        
        cell.imageHorizontalCollectionView.delegate = self
        
        return cell
    }
}

extension ReminderListViewController: UICollectionViewDelegate {
    
}
