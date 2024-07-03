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
}

final class CreateReminderViewController: BaseViewController {
    
    private let createReminderView = CreateReminderView()
    
    private var isShowCalendar = false {
        didSet {
            createReminderView.contentTableView.reloadSections(IndexSet(integer: 1), with: .automatic)
        }
    }
    private var reminderTitle = ""
    private var reminderContents: String?
    private var reminderDeadline = Date()
    
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
        let reminder = Reminder(title: reminderTitle, content: reminderContents, deadline: reminderDeadline)
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
        
        createReminderView.contentTableView.register(ReminderTextViewTableViewCell.self,
                                                     forCellReuseIdentifier: ReminderTextViewTableViewCell.identifier)
        createReminderView.contentTableView.register(DeadlineTableViewCell.self,
                                                     forCellReuseIdentifier: DeadlineTableViewCell.identifier)
        createReminderView.contentTableView.register(ReminderDatePickerTableViewCell.self,
                                                     forCellReuseIdentifier: ReminderDatePickerTableViewCell.identifier)
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
            return isShowCalendar ? 2 : 1
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
            if isShowCalendar, indexPath.row == 1 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: ReminderDatePickerTableViewCell.identifier,
                                                               for: indexPath) as? ReminderDatePickerTableViewCell else { return UITableViewCell() }
                
                cell.datePicker.addTarget(self, action: #selector(changedValueDatePicker), for: .valueChanged)
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: DeadlineTableViewCell.identifier,
                                                               for: indexPath) as? DeadlineTableViewCell else { return UITableViewCell() }
                cell.toggleButton.setOn(isShowCalendar, animated: true)
                cell.toggleButton.addTarget(self, action: #selector(changedValuetoggleButton), for: .valueChanged)
                
                if isShowCalendar {
                    cell.remakeConstraintsWithCalendar()
                    cell.deadlineLabel.text = reminderDeadline.reminderString
                }
                return cell
            }
        }
    }
    
    @objc
    private func changedValueDatePicker(sender: UIDatePicker) {
        if let cell = createReminderView.contentTableView.cellForRow(at: IndexPath(row: 0, section: 1)) as? DeadlineTableViewCell {
            cell.deadlineLabel.text = sender.date.reminderString
            reminderDeadline = sender.date
        }
    }
    
    @objc
    private func changedValuetoggleButton(sender: UISwitch) {
        isShowCalendar.toggle()
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
