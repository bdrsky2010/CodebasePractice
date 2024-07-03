//
//  DeadlineTableViewCell.swift
//  CodebasePractice
//
//  Created by Minjae Kim on 7/3/24.
//

import UIKit

import SnapKit


final class DeadlineTableViewCell: BaseTableViewCell {
    
    let toggleButton = UISwitch()
    let titleLabel = UILabel()
    let deadlineLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(deadlineLabel)
        contentView.addSubview(toggleButton)
        
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
        }
        
        toggleButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
        }
        
        titleLabel.text = "마감일"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 14)
        deadlineLabel.font = UIFont.systemFont(ofSize: 12)
        deadlineLabel.textColor = UIColor.systemBlue
        deadlineLabel.isHidden = true
    }
}
