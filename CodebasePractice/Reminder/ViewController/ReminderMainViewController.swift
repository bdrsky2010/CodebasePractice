//
//  ReminderMainViewController.swift
//  CodebasePractice
//
//  Created by Minjae Kim on 7/2/24.
//

import UIKit

import RealmSwift

enum ReminderOption: Int, CaseIterable {
    case today
    case schedule
    case all
    case flag
    case completed
    
    var image: UIImage? {
        switch self {
        case .today:
            return UIImage(systemName: "calendar.circle.fill")
        case .schedule:
            return UIImage(systemName: "calendar.circle.fill")
        case .all:
            return UIImage(systemName: "tray.circle.fill")
        case .flag:
            return UIImage(systemName: "flag.circle.fill")
        case .completed:
            return UIImage(systemName: "checkmark.circle.fill")
        }
    }
    
    var tintColor: UIColor {
        switch self {
        case .today:
            return UIColor.systemBlue
        case .schedule:
            return UIColor.systemRed
        case .all:
            return UIColor.systemGray
        case .flag:
            return UIColor.systemOrange
        case .completed:
            return UIColor.darkGray
        }
    }
    
    var title: String {
        switch self {
        case .today:
            return "오늘"
        case .schedule:
            return "예정"
        case .all:
            return "전체"
        case .flag:
            return "깃발 표시"
        case .completed:
            return "완료됨"
        }
    }
}

final class ReminderMainViewController: BaseViewController {
    
    private let reminderMainView = ReminderMainView()
    
    override func loadView() {
        view = reminderMainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigation()
        configureTableView()
    }
    
    override func configureView() {
        view.backgroundColor = UIColor.secondarySystemBackground
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.tintColor = UIColor.systemBlue
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.setToolbarHidden(false, animated: false)
        
        let navigationAppearance = UINavigationBarAppearance()
        navigationAppearance.backgroundColor = UIColor.secondarySystemBackground
        navigationController?.navigationBar.scrollEdgeAppearance = navigationAppearance
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.setToolbarHidden(true, animated: false)
        
        let navigationAppearance = UINavigationBarAppearance()
        navigationAppearance.backgroundColor = UIColor.systemBackground
        navigationController?.navigationBar.scrollEdgeAppearance = navigationAppearance
    }
    
    private func configureNavigation() {
        navigationItem.title = "목록"
        
        let menu = UIMenu(children: configureMenuAction())
        let rightBarMenuButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), menu: menu)
        navigationItem.rightBarButtonItem = rightBarMenuButton
        
        let searchController = UISearchController()
        searchController.searchBar.placeholder = "검색"
        searchController.searchBar.setValue("취소", forKey: "cancelButtonText")
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        
        let createReminderButton = UIButton(type: .system)
        createReminderButton.configuration = .creadteReminderButton()
        createReminderButton.addTarget(self, action: #selector(createReminderButtonClicked), for: .touchUpInside)
        let leftToolBarItem = UIBarButtonItem(customView: createReminderButton)
        let rightToolBarItem = UIBarButtonItem(title: "목록 추가", style: .plain, target: self, action: #selector(addCatalogButtonClicked))
        let flexibleSpace = UIBarButtonItem(systemItem: .flexibleSpace)
        toolbarItems = [leftToolBarItem, flexibleSpace, rightToolBarItem]
        
        let toolbarAppearance = UIToolbarAppearance()
        toolbarAppearance.backgroundColor = UIColor.secondarySystemBackground
        navigationController?.toolbar.scrollEdgeAppearance = toolbarAppearance
    }
    
    @objc
    private func createReminderButtonClicked() {
        let createReminderViewController = CreateReminderViewController()
        createReminderViewController.delegate = self
        let navigationController = UINavigationController(rootViewController: createReminderViewController)
        present(navigationController, animated: true)
    }
    
    @objc
    private func addCatalogButtonClicked() {
        print(#function)
    }
    
    private func configureTableView() {
        reminderMainView.reminderMainTableView.delegate = self
        reminderMainView.reminderMainTableView.dataSource = self
        reminderMainView.reminderMainTableView.register(ReminderMainTableViewCell.self,
                                                        forCellReuseIdentifier: ReminderMainTableViewCell.identifier)
        reminderMainView.reminderMainTableView.separatorStyle = .none
        reminderMainView.reminderMainTableView.backgroundColor = UIColor.clear
    }
}

extension ReminderMainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            let width = windowScene.screen.bounds.width - 48
            let height = (width / 2 * 0.45) * 3 + (10 * 4)
            return height
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ReminderMainTableViewCell.identifier, for: indexPath) as? ReminderMainTableViewCell else { return UITableViewCell() }
        cell.backgroundColor = .clear
        cell.reminderMainCollectionView.delegate = self
        cell.reminderMainCollectionView.dataSource = self
        cell.reminderMainCollectionView.register(ReminderMainCollectionViewCell.self,
                                                             forCellWithReuseIdentifier: ReminderMainCollectionViewCell.identifier)
        
        return cell
    }
    
    
}

extension ReminderMainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let reminderListViewController = ReminderListViewController()
        reminderListViewController.reminderOption = ReminderOption.allCases[indexPath.row]
        reminderListViewController.delegate = self
//        reminderListViewController.configureList(reminderOption: ReminderOption.allCases[indexPath.row])
        navigationController?.pushViewController(reminderListViewController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ReminderOption.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReminderMainCollectionViewCell.identifier, for: indexPath) as? ReminderMainCollectionViewCell else { return UICollectionViewCell() }
        
        let index = indexPath.row
        let option = ReminderOption.allCases[index]
        if let image = option.image {
            cell.configureImage(image: image, tintColor: option.tintColor)
        }
        cell.configureTitle(title: option.title)
        
        let realm = try! Realm()
        switch option {
        case .today:
            let count = realm.objects(Reminder.self).where { $0.deadline != nil }.filter("deadline >= %@ ").count
            print(count)
//            let count = realm.objects(Reminder.self)
//                .where { $0.deadline != nil }
//                .filter {
//                    if let deadline = $0.deadline {
//                        return deadline.isToday
//                    }
//                    return false
//                }.count
            cell.configureCount(count: count)
        case .schedule:
            let count = realm.objects(Reminder.self)
                .where { $0.deadline != nil }
                .filter {
                    if let deadline = $0.deadline {
                        return deadline.isSchedule
                    }
                    return false
                }.count
            cell.configureCount(count: count)
        case .all:
            let count = realm.objects(Reminder.self).count
            cell.configureCount(count: count)
        case .flag:
            let count = realm.objects(Reminder.self).where { $0.flag }.count
            cell.configureCount(count: count)
        case .completed:
            let count = realm.objects(Reminder.self).where { $0.isComplete }.count
            cell.configureCount(count: count)
        }
        return cell
    }
    
    
}

extension ReminderMainViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        let cancelButton = searchBar.value(forKey: "cancelButton") as? UIButton
        cancelButton?.setTitle("취소", for: .normal)
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("asd")
        
    }
}

extension ReminderMainViewController {
    private func configureMenuAction() -> [UIMenuElement] {
        
        let editListAction = UIAction(title: "목록 편집", image: UIImage(systemName: "pencil")) { [weak self] _ in
            guard let self else { return }
            
        }
        let templateAction = UIAction(title: "템플릿", image: UIImage(systemName: "square.on.square")) { [weak self] _ in
            guard let self else { return }
            
        }
        return [editListAction, templateAction]
    }
}

extension ReminderMainViewController: ReminderUpdateDelegate {
    func reloadMainCollectionView() {
        print(#function)
        let reminderMainCollectionView = (reminderMainView.reminderMainTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? ReminderMainTableViewCell)?.reminderMainCollectionView
        reminderMainCollectionView?.reloadData()
    }
}
