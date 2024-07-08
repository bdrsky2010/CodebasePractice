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
    private let repository = ReminderRepository()
    
    private var reminderList: Results<Reminder>!
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
        allReminderView.reminderTableView.allowsSelection = false
    }
    
    func configureList(reminderOption: ReminderOption) {
        let realm = try! Realm()
        let sortList = realm.objects(Reminder.self).sorted(byKeyPath: "registerDate", ascending: true)
        switch reminderOption {
        case .today:
            reminderList = realm.objects(Reminder.self).where { $0.deadline != nil && !$0.isComplete }.filter("deadline BETWEEN {%@, %@}", Date(timeInterval: -86400, since: Date()), Date())
        case .schedule:
            reminderList = realm.objects(Reminder.self).where { $0.deadline != nil && !$0.isComplete }.filter("deadline BETWEEN {%@, %@} or deadline > %@", Date(timeInterval: -86400, since: Date()), Date(), Date())
        case .all:
            reminderList = realm.objects(Reminder.self).where { !$0.isComplete }
        case .flag:
            reminderList = realm.objects(Reminder.self).where { $0.flag && !$0.isComplete }
        case .completed:
            reminderList = realm.objects(Reminder.self).where { $0.isComplete }
        }
        allReminderView.reminderTableView.reloadData()
    }
}

extension ReminderListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
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
            
            do {
                let value = ["id": reminder.id, "flag": !reminder.flag]
                try repository.updateReminder(value: value)
                tableView.reloadRows(at: [indexPath], with: .automatic)
                delegate?.reloadMainCollectionView()
                success(true)
            } catch {
                if let error = error.asReminderDatabaseError {
                    ReminderManager.shared.presentAlertWithReminderError(viewController: self, error: error)
                }
                success(false)
            }
        }
        flagAction.backgroundColor = UIColor.systemOrange
        
        let deleteAction = UIContextualAction(style: .destructive, title: "삭제") { [weak self] _, _, success in
            guard let self else {
                success(false)
                return
            }

            do {
                try repository.deleteReminder(reminder)
                tableView.deleteRows(at: [indexPath], with: .bottom)
                delegate?.reloadMainCollectionView()
                success(true)
            } catch {
                if let error = error.asReminderDatabaseError {
                    ReminderManager.shared.presentAlertWithReminderError(viewController: self, error: error)
                }
                success(false)
            }
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction, flagAction, detailAction])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reminderList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ReminderTableViewCell.identifier, for: indexPath) as? ReminderTableViewCell else { return UITableViewCell()}
        
        let index = indexPath.row
        let reminder = reminderList[index]
        
        if let reminderOption {
            cell.configureContent(reminder, optionColor: reminderOption.tintColor)
            cell.selectedImageIDs = reminder.imageIDs.map { String($0) }
        }
        
        cell.completeButton.tag = index
        cell.completeButton.addTarget(self, action: #selector(completeButtonClicked), for: .touchUpInside)
        
        cell.imageHorizontalCollectionView.delegate = self
        
        return cell
    }
    
    @objc
    private func completeButtonClicked(sender: UIButton) {
        print(#function)
        let index = sender.tag
        let realm = try! Realm()
        let reminder = reminderList[index]
        
        try! realm.write {
            reminder.isComplete.toggle()
        }
        if let cell = allReminderView.reminderTableView.cellForRow(at: IndexPath(row: index, section: 0)) as? ReminderTableViewCell {
            cell.configureButtonContent(isComplete: reminder.isComplete)
        }
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                allReminderView.reminderTableView.reloadData()
            }
        }
        delegate?.reloadMainCollectionView()
    }
}

extension ReminderListViewController: UICollectionViewDelegate {
    
}
