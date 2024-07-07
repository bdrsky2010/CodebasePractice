//
//  ReminderAddTagViewController.swift
//  CodebasePractice
//
//  Created by Minjae Kim on 7/7/24.
//

import UIKit

fileprivate struct Tag {
    let String: String
    var isSelect: Bool
}

final class ReminderAddTagViewController: BaseViewController {
    
    private let reminderAddTagView = ReminderAddTagView()
    
    private var tagList = [Tag]() {
        didSet {
            if tagList.isEmpty {
                navigationItem.rightBarButtonItem?.isEnabled = false
            } else {
                navigationItem.rightBarButtonItem?.isEnabled = true
            }
        }
    }
    
    var onComplete: (([String]) -> Void)?
    
    override func loadView() {
        view = reminderAddTagView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigation()
        configureTableView()
    }
    
    private func configureNavigation() {
        navigationItem.title = "태그"
        
        let leftBarButtonItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(cancelButtonClicked))
        let rightBarButtonItem = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(completeButtonClicked))
        navigationItem.leftBarButtonItem = leftBarButtonItem
        navigationItem.rightBarButtonItem = rightBarButtonItem
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    @objc
    private func cancelButtonClicked() {
        dismiss(animated: true)
    }
    
    @objc
    private func completeButtonClicked() {
        onComplete?(tagList.filter { $0.isSelect }.map { $0.String })
        dismiss(animated: true)
    }
    
    private func configureTableView() {
        reminderAddTagView.contentTableView.delegate = self
        reminderAddTagView.contentTableView.dataSource = self
        reminderAddTagView.contentTableView.register(ReminderTagTableViewCell.self, forCellReuseIdentifier: ReminderTagTableViewCell.identifier)
        reminderAddTagView.contentTableView.register(ReminderTextFieldTableViewCell.self, forCellReuseIdentifier: ReminderTextFieldTableViewCell.identifier)
        reminderAddTagView.contentTableView.rowHeight = UITableView.automaticDimension
        reminderAddTagView.contentTableView.allowsSelection = false
    }
}

extension ReminderAddTagViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ReminderTagTableViewCell.identifier, for: indexPath) as? ReminderTagTableViewCell else { return UITableViewCell() }
            
            cell.addTagCollectionView.delegate = self
            cell.addTagCollectionView.dataSource = self
            cell.addTagCollectionView.register(ReminderAddTagCollectionViewCell.self, forCellWithReuseIdentifier: ReminderAddTagCollectionViewCell.identifier)
            
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ReminderTextFieldTableViewCell.identifier, for: indexPath) as? ReminderTextFieldTableViewCell else { return UITableViewCell() }
            cell.addTagTextField.delegate = self
            return cell
        }
    }
}

extension ReminderAddTagViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ReminderAddTagCollectionViewCell else { return }
        let index = indexPath.row
        tagList[index].isSelect.toggle()
        cell.tagView.changedSelect(isSelect: tagList[index].isSelect)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tagList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReminderAddTagCollectionViewCell.identifier, for: indexPath) as? ReminderAddTagCollectionViewCell else { return UICollectionViewCell() }
        cell.tagView.configureContent(tagString: tagList[indexPath.row].String)
        return cell
    }
}

extension ReminderAddTagViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let index = indexPath.row
        let text = tagList[index].String
        let size = text.fontSize
        return CGSize(width: size.width + 16, height: size.height + 8)
    }
}

extension ReminderAddTagViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == " " || string == "," {
            if let text = textField.text, !text.isEmpty {
                for tag in tagList {
                    if tag.String == text {
                        textField.text = nil
                        return false
                    }
                }
                tagList.append(Tag(String: text, isSelect: true))
                reloadCollectionView()
            }
            textField.text = nil
            return false
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        defer { textField.text = nil }
        
        if let text = textField.text, !text.isEmpty {
            for tag in tagList {
                if tag.String == text {
                    return true
                }
            }
            tagList.append(Tag(String: text, isSelect: true))
            reloadCollectionView()
        }
        return true
    }
    
    private func reloadCollectionView() {
        guard let cell = reminderAddTagView.contentTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? ReminderTagTableViewCell else { return }
        cell.addTagCollectionView.reloadData()
    }
}
