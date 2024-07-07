//
//  ReminderSwitchTableViewCell.swift
//  CodebasePractice
//
//  Created by Minjae Kim on 7/3/24.
//

import UIKit

import SnapKit

final class ReminderSwitchTableViewCell: BaseTableViewCell {
    
    let toggleButton = UISwitch()
    let titleLabel = UILabel()
    let deadlineLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        titleLabel.font = UIFont.boldSystemFont(ofSize: 14)
        deadlineLabel.font = UIFont.systemFont(ofSize: 12)
        deadlineLabel.textColor = UIColor.systemBlue
        deadlineLabel.isHidden = true
    }
    
    override func configureHierarchy() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(deadlineLabel)
        contentView.addSubview(toggleButton)
    }
    
    override func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
        }
        
        toggleButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
        }
    }
    
    func remakeConstraintsWithCalendar() {
        deadlineLabel.isHidden = false
        titleLabel.snp.remakeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.bottom.equalTo(toggleButton.snp.centerY).offset(-2)
        }
        deadlineLabel.snp.remakeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalTo(toggleButton.snp.centerY).offset(2)
        }
    }
}
