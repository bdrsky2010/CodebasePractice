//
//  ReminderImageTableViewCell.swift
//  CodebasePractice
//
//  Created by Minjae Kim on 7/3/24.
//

import UIKit

import SnapKit

final class ReminderImageTableViewCell: BaseTableViewCell {
    
    let titleLabel = UILabel()
    let trailingImageView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        titleLabel.font = UIFont.boldSystemFont(ofSize: 14)
        trailingImageView.tintColor = UIColor.systemGray
    }
    
    override func configureHierarchy() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(trailingImageView)
    }
    
    override func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
        }
        
        trailingImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
        }
    }
}
