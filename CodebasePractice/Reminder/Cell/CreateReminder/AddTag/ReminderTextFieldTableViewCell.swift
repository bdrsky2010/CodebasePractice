//
//  ReminderTextFieldTableViewCell.swift
//  CodebasePractice
//
//  Created by Minjae Kim on 7/7/24.
//

import UIKit

import SnapKit

final class ReminderTextFieldTableViewCell: BaseTableViewCell {
    
    let addTagTextField = UITextField()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    override func configureHierarchy() {
        contentView.addSubview(addTagTextField)
    }
    
    override func configureLayout() {
        addTagTextField.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }
    }
    
    private func configureUI() {
        addTagTextField.borderStyle = .none
        addTagTextField.attributedPlaceholder = NSAttributedString(string: "새로운 태그 추가...",
                                                                   attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
    }
}
