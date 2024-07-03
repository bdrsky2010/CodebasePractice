//
//  ReminderTextViewTableViewCell.swift
//  CodebasePractice
//
//  Created by Minjae Kim on 7/3/24.
//

import UIKit

import SnapKit

enum ReminderTextViewOption {
    case title
    case content
}

final class ReminderTextViewTableViewCell: BaseTableViewCell {
    
    let textView = UITextView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        textView.backgroundColor = .clear
    }
    
    override func configureHierarchy() {
        contentView.addSubview(textView)
    }
    
    func configureLayout(option: ReminderTextViewOption) {
        switch option {
        case .title:
            textView.snp.makeConstraints { make in
                make.horizontalEdges.equalToSuperview().inset(12)
                make.verticalEdges.equalToSuperview()
                make.height.equalTo(44)
            }
        case .content:
            textView.snp.makeConstraints { make in
                make.horizontalEdges.equalToSuperview().inset(12)
                make.verticalEdges.equalToSuperview()
                make.height.equalTo(88)
            }
        }
    }
}
