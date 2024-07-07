//
//  CreateReminderViewController.swift
//  CodebasePractice
//
//  Created by Minjae Kim on 7/2/24.
//

import UIKit
import AVFoundation
import PhotosUI

import RealmSwift

fileprivate enum ReminderCategory: String, CaseIterable {
    case content
    case deadline = "마감일"
    case tag = "태그"
    case flag = "깃발"
    case priority = "우선 순위"
    case image = "이미지 추가"
}

fileprivate enum ImageAddOption: String, CaseIterable {
    case film = "사진 찍기"
    case album = "사진 보관함"
    
    var image: UIImage? {
        switch self {
        case .film:
            return UIImage(systemName: "camera")
        case .album:
            return UIImage(systemName: "photo.on.rectangle")
        }
    }
}

final class CreateReminderViewController: BaseViewController {
    
    private let createReminderView = CreateReminderView()
    private let repository = ReminderRepository()
    
    private var isShowDatePicker = false {
        didSet {
            createReminderView.contentTableView.reloadSections(IndexSet(integer: 1), with: .automatic)
        }
    }
    private var reminderTitle = ""
    private var reminderContents: String?
    private var reminderDeadline: Date?
    private var reminderTag = List<String>()
    private var reminderFlag = false
    private var reminderPriority = Priority.none
    private var reminderImageIDs = List<String>()
    private var selectedImageList = [UIImage]()
    
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
        let reminder = Reminder(title: reminderTitle, content: reminderContents, deadline: reminderDeadline, tag: reminderTag, flag: reminderFlag, priority: reminderPriority, imageIDs: reminderImageIDs)
        
        do {
            try repository.createReminder(reminder)
        } catch {
            if let error = error.asReminderDatabaseError {
                ReminderManager.shared.presentAlertWithReminderError(viewController: self, error: error)
            }
        }
        
        delegate?.reloadMainCollectionView()
        dismiss(animated: true)
    }
    
    private func configureTableView() {
        createReminderView.contentTableView.delegate = self
        createReminderView.contentTableView.dataSource = self
        createReminderView.contentTableView.rowHeight = UITableView.automaticDimension
        createReminderView.contentTableView.keyboardDismissMode = .onDrag
        createReminderView.contentTableView.allowsSelection = false
        createReminderView.contentTableView.isEditing = true
        
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
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        selectedImageList.remove(at: indexPath.row - 1)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        selectedImageList.swapAt(sourceIndexPath.row - 1, destinationIndexPath.row - 1)
    }
    
    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        return proposedDestinationIndexPath
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section == 5 && indexPath.row > 0
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section == 5 && indexPath.row > 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return ReminderCategory.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch ReminderCategory.allCases[section] {
        case .content:
            return 2
        case .deadline:
            return isShowDatePicker ? 2 : 1
        case .image:
            return selectedImageList.isEmpty ? 1 : selectedImageList.count + 1
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
                    cell.deadlineLabel.text = reminderDeadline?.reminderString
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
            let popupButtonHandler = { [weak self] (action: UIAction) in
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
            cell.popupButton.configuration?.attributedTitle = AttributedString(NSAttributedString(string: reminderPriority.rawValue, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)]))
            cell.popupButton.menu = UIMenu(children: Priority.allCases.map { UIAction(title: $0.rawValue, handler: popupButtonHandler) })
            cell.popupButton.showsMenuAsPrimaryAction = true
            return cell
            
        case .image:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ReminderLeadingButtonTableViewCell.identifier,
                                                           for: indexPath) as? ReminderLeadingButtonTableViewCell else { return UITableViewCell() }
            let pulldownButtonHandler = { [weak self] (action: UIAction) in
                guard let self else { return }
                switch action.title {
                case ImageAddOption.film.rawValue:
                    presentCamera()
                case ImageAddOption.album.rawValue:
                    presentPHPicker()
                default:
                    presentPHPicker()
                }
            }
            
            cell.titleButton.configuration?.attributedTitle = AttributedString(NSAttributedString(string: category.rawValue, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)]))
            cell.titleButton.menu = UIMenu(children: ImageAddOption.allCases.map {
                UIAction(title: $0.rawValue, image: $0.image, handler: pulldownButtonHandler)
            })
            cell.titleButton.showsMenuAsPrimaryAction = true
            return cell
        }
    }
    
    private func presentCamera() {
        AVCaptureDevice.requestAccess(for: .video) { [weak self] isAuthorized in
            guard let self else { return }
            guard isAuthorized else {
                presentAlertMoveToSetting()
                return
            }
        }
    }
    
    private func presentAlertMoveToSetting() {
        
    }
    
    private func presentPHPicker() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .any(of: [.images, .livePhotos, .screenshots])
        let photoPicker = PHPickerViewController(configuration: configuration)
        photoPicker.delegate = self
        present(photoPicker, animated: true)
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
        if !isShowDatePicker { // 데이트 피커가 화면에 사라지면 데이트 피커 데이터를 받아왔던 프로퍼티에 nil 대입
            reminderDeadline = nil
        } else { // 데이트 피커가 화면에 보여지면 데이트 피커의 날짜 데이터를 받아오고 테이블뷰를 리로드하여 날짜 레이블을 갱신
            if let cell = createReminderView.contentTableView.cellForRow(at: IndexPath(row: 1, section: 1)) as? ReminderDatePickerTableViewCell {
                reminderDeadline = cell.datePicker.date
                createReminderView.contentTableView.reloadRows(at: [IndexPath(row: 0, section: 1)], with: .none)
            }
        }
    }
    
    @objc
    private func changedValueReminderFlagSwitch(sender: UISwitch) {
        reminderFlag.toggle()
    }
    
    private func configureTextViewPlaceholder(_ textView: UITextView, placeholder: String) {
        textView.text = placeholder
        textView.textColor = UIColor.systemGray
        textView.font = UIFont.boldSystemFont(ofSize: 14)
    }
}

extension CreateReminderViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        if let itemProvider = results.first?.itemProvider,
           itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                if let error {
                    print(error)
                } else {
                    DispatchQueue.main.async { [weak self] in
                        guard let self, let image = image as? UIImage else { return }
                        selectedImageList.append(image)
                        createReminderView.contentTableView.reloadSections(IndexSet(integer: 5), with: .automatic)
                        print(selectedImageList)
                    }
                }
            }
        }
        dismiss(animated: true)
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
