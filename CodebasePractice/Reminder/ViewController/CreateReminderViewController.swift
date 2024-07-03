//
//  CreateReminderViewController.swift
//  CodebasePractice
//
//  Created by Minjae Kim on 7/2/24.
//

import UIKit

import RealmSwift

fileprivate enum ReminderCategory: String, CaseIterable {
    case content
    case deadline = "마감일"
    case tag = "태그"
    case flag = "깃발"
    case priority = "우선 순위"
    case image = "이미지 추가"
}

final class CreateReminderViewController: BaseViewController {
    
    private let createReminderView = CreateReminderView()
    
    private var isShowDatePicker = false {
        didSet {
            createReminderView.contentTableView.reloadSections(IndexSet(integer: 1), with: .automatic)
        }
    }
    private var reminderTitle = ""
    private var reminderContents: String?
    private var reminderDeadline = Date()
    private var reminderFlag = false
    private var reminderPriority = Priority.none
    
    weak var delegate: ReminderUpdateDelegate?
    
    override func loadView() {
        view = createReminderView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigation()
        configureTableView()
    }
    
    private func configureNavigation() {
        navigationItem.title = "새로운 미리 알림"
        
        let leftBarButtonItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(cancelButtonClicked))
        let rightBarButtonItem = UIBarButtonItem(title: "추가", style: .plain, target: self, action: #selector(addButtonClicked))
        navigationItem.leftBarButtonItem = leftBarButtonItem
        navigationItem.rightBarButtonItem = rightBarButtonItem
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    @objc
    private func cancelButtonClicked() {
        dismiss(animated: true)
    }
    
    @objc
    private func addButtonClicked() {
        let realm = try! Realm()
        let reminder = Reminder(title: reminderTitle, content: reminderContents, deadline: reminderDeadline, flag: reminderFlag, priority: reminderPriority)
        try! realm.write {
            realm.add(reminder)
            print("Realm Create Succeed")
        }
        delegate?.reloadMainCollectionView()
        dismiss(animated: true)
    }
    
    private func configureTableView() {
        createReminderView.contentTableView.delegate = self
        createReminderView.contentTableView.dataSource = self
        createReminderView.contentTableView.rowHeight = UITableView.automaticDimension
        createReminderView.contentTableView.keyboardDismissMode = .onDrag
        let tableViewCellList = [
            ReminderTextViewTableViewCell.self,
            ReminderSwitchTableViewCell.self,
            ReminderDatePickerTableViewCell.self,
            ReminderImageTableViewCell.self,
            ReminderLeadingButtonTableViewCell.self,
            ReminderPopupButtonTableViewCell.self
        ]
        tableViewCellList.forEach {
            createReminderView.contentTableView.register($0.self, forCellReuseIdentifier: $0.identifier)
        }
    }
}

extension CreateReminderViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return ReminderCategory.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch ReminderCategory.allCases[section] {
        case .content:
            return 2
        case .deadline:
            return isShowDatePicker ? 2 : 1
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let category = ReminderCategory.allCases[indexPath.section]
        
        switch category {
        case .content:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ReminderTextViewTableViewCell.identifier,
                                                           for: indexPath) as? ReminderTextViewTableViewCell else { return UITableViewCell() }
            cell.textView.delegate = self
            cell.textView.tag = indexPath.row
            
            if indexPath.row == 0 {
                cell.configureLayout(option: .title)
                configureTextViewPlaceholder(cell.textView, placeholder: "제목")
            } else {
                cell.configureLayout(option: .content)
                configureTextViewPlaceholder(cell.textView, placeholder: "메모")
            }
            return cell
            
        case .deadline:
            if isShowDatePicker, indexPath.row == 1 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: ReminderDatePickerTableViewCell.identifier,
                                                               for: indexPath) as? ReminderDatePickerTableViewCell else { return UITableViewCell() }
                
                cell.datePicker.addTarget(self, action: #selector(changedValueDatePicker), for: .valueChanged)
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: ReminderSwitchTableViewCell.identifier,
                                                               for: indexPath) as? ReminderSwitchTableViewCell else { return UITableViewCell() }
                cell.titleLabel.text = category.rawValue
                cell.toggleButton.setOn(isShowDatePicker, animated: true)
                cell.toggleButton.addTarget(self, action: #selector(changedValueIsShowDatePickerSwitch), for: .valueChanged)
                
                if isShowDatePicker {
                    cell.remakeConstraintsWithCalendar()
                    cell.deadlineLabel.text = reminderDeadline.reminderString
                }
                return cell
            }
            
        case .tag:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ReminderImageTableViewCell.identifier,
                                                           for: indexPath) as? ReminderImageTableViewCell else { return UITableViewCell() }
            cell.titleLabel.text = category.rawValue
            cell.trailingImageView.image = UIImage(systemName: "chevron.forward")
            return cell
            
        case .flag:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ReminderSwitchTableViewCell.identifier,
                                                           for: indexPath) as? ReminderSwitchTableViewCell else { return UITableViewCell() }
            cell.titleLabel.text = category.rawValue
            cell.toggleButton.setOn(isShowDatePicker, animated: true)
            cell.toggleButton.addTarget(self, action: #selector(changedValueReminderFlagSwitch), for: .valueChanged)
            return cell
            
        case .priority:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ReminderPopupButtonTableViewCell.identifier,
                                                           for: indexPath) as? ReminderPopupButtonTableViewCell else { return UITableViewCell() }
            let popButtonHandler = { [weak self] (action: UIAction) in
                guard let self else { return }
                switch action.title {
                case Priority.none.rawValue:
                    reminderPriority = .none
                case Priority.low.rawValue:
                    reminderPriority = .low
                case Priority.mid.rawValue:
                    reminderPriority = .mid
                case Priority.high.rawValue:
                    reminderPriority = .high
                default:
                    reminderPriority = .none
                }
                tableView.reloadRows(at: [indexPath], with: .none)
            }
            cell.titleLabel.text = category.rawValue
            cell.popupButton.configuration?.attributedTitle = AttributedString(NSAttributedString(string: reminderPriority.rawValue,
                                                                                                  attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)]))
            cell.popupButton.menu = UIMenu(children: Priority.allCases.map { UIAction(title: $0.rawValue, handler: popButtonHandler) })
            cell.popupButton.showsMenuAsPrimaryAction = true
            return cell
            
        case .image:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ReminderLeadingButtonTableViewCell.identifier,
                                                           for: indexPath) as? ReminderLeadingButtonTableViewCell else { return UITableViewCell() }
            cell.titleButton.configuration?.attributedTitle = AttributedString(NSAttributedString(string: category.rawValue,
                                                                                                  attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)]))
            cell.titleButton.addTarget(self, action: #selector(addImageButtonClicked), for: .touchUpInside)
            return cell
        }
    }
    
    @objc
    private func changedValueDatePicker(sender: UIDatePicker) {
        if let cell = createReminderView.contentTableView.cellForRow(at: IndexPath(row: 0, section: 1)) as? ReminderSwitchTableViewCell {
            cell.deadlineLabel.text = sender.date.reminderString
            reminderDeadline = sender.date
        }
    }
    
    @objc
    private func changedValueIsShowDatePickerSwitch(sender: UISwitch) {
        isShowDatePicker.toggle()
    }
    
    @objc
    private func changedValueReminderFlagSwitch(sender: UISwitch) {
        reminderFlag.toggle()
    }
    
    @objc
    private func addImageButtonClicked() {
        print(#function)
    }
    
    private func configureTextViewPlaceholder(_ textView: UITextView, placeholder: String) {
        textView.text = placeholder
        textView.textColor = UIColor.systemGray
        textView.font = UIFont.boldSystemFont(ofSize: 14)
    }
}

extension CreateReminderViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if textView.tag == 0 {
            if !textView.text.isEmpty {
                navigationItem.rightBarButtonItem?.isEnabled = true
            } else {
                navigationItem.rightBarButtonItem?.isEnabled = false
            }
            reminderTitle = textView.text
        } else {
            reminderContents = textView.text
        }
    }
    
    // 편집 시작, 커서 깜빡임
    func textViewDidBeginEditing(_ textView: UITextView) {
        var check = false
        
        if textView.tag == 0 {
            if textView.text == "제목",
               textView.textColor == UIColor.systemGray {
                check = true
            }
        } else {
            if textView.text == "메모",
               textView.textColor == UIColor.systemGray {
                check = true
            }
        }
        
        if check {
            textView.text = nil
            textView.font = UIFont.systemFont(ofSize: 14)
            textView.textColor = .label
        }
    }
    
    // 편집 끝, 커서 안깜빡임
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            
            if textView.tag == 0 {
                configureTextViewPlaceholder(textView, placeholder: "제목")
            } else {
                configureTextViewPlaceholder(textView, placeholder: "메모")
            }
        }
    }
}
