//
//  ReminderMainViewController.swift
//  CodebasePractice
//
//  Created by Minjae Kim on 7/2/24.
//

import UIKit

import RealmSwift

fileprivate enum ReminderOption: CaseIterable {
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
        configureCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.tintColor = UIColor.systemBlue
    }
    
    private func configureNavigation() {
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
        navigationController?.setToolbarHidden(false, animated: false)
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
    
    private func configureCollectionView() {
        reminderMainView.reminderMainCollectionView.delegate = self
        reminderMainView.reminderMainCollectionView.dataSource = self
        reminderMainView.reminderMainCollectionView.register(ReminderMainCollectionViewCell.self,
                                                             forCellWithReuseIdentifier: ReminderMainCollectionViewCell.identifier)
    }
}

extension ReminderMainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 2 {
            let allReminderViewController = AllReminderViewController()
            allReminderViewController.delegate = self
            navigationController?.pushViewController(allReminderViewController, animated: true)
        }
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
        
        switch option {
        case .today:
            cell.configureCount(count: 0)
        case .schedule:
            cell.configureCount(count: 0)
        case .all:
            let realm = try! Realm()
            let count = realm.objects(Reminder.self).count
            cell.configureCount(count: count)
        case .flag:
            cell.configureCount(count: 0)
        case .completed:
            cell.configureCount(count: 0)
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
        reminderMainView.reminderMainCollectionView.reloadData()
    }
}
