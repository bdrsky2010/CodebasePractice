//
//  ReminderLeadingButtonTableViewCell.swift
//  CodebasePractice
//
//  Created by Minjae Kim on 7/3/24.
//

import UIKit

import SnapKit

final class ReminderLeadingButtonTableViewCell: BaseTableViewCell {
    
    let titleButton = UIButton(type: .system)
    let trailingImageView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        titleButton.configuration = .plain()
        titleButton.configuration?.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
    }
    
    override func configureHierarchy() {
        contentView.addSubview(titleButton)
    }
    
    override func configureLayout() {
        titleButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
        }
    }
}
