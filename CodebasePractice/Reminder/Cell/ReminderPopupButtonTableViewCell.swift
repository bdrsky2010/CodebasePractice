//
//  ReminderPopupButtonTableViewCell.swift
//  CodebasePractice
//
//  Created by Minjae Kim on 7/3/24.
//

import UIKit

import SnapKit

final class ReminderPopupButtonTableViewCell: BaseTableViewCell {
    
    let titleLabel = UILabel()
    let popupButton = UIButton(type: .system)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        titleLabel.font = UIFont.boldSystemFont(ofSize: 14)
        popupButton.configuration = .plain()
        popupButton.configuration?.baseForegroundColor = UIColor.systemGray
        popupButton.configuration?.image = UIImage(systemName: "chevron.up.chevron.down")
        popupButton.configuration?.imagePlacement = .trailing
        popupButton.configuration?.preferredSymbolConfigurationForImage = .init(pointSize: 10, weight: .bold)
        popupButton.configuration?.imagePadding = 4
        popupButton.configuration?.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
    }
    
    override func configureHierarchy() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(popupButton)
    }
    
    override func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
        }
        
        popupButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
        }
    }
}
