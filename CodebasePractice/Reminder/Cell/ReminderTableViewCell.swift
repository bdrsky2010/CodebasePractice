//
//  ReminderTableViewCell.swift
//  CodebasePractice
//
//  Created by Minjae Kim on 7/3/24.
//

import UIKit

import SnapKit


final class ReminderTableViewCell: BaseTableViewCell {
    
    let titleLable = UILabel()
    let contentLabel = UILabel()
    let dateLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(titleLable)
        contentView.addSubview(contentLabel)
        contentView.addSubview(dateLabel)
        
        titleLable.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(8)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLable.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(8)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().inset(8)
        }
        
        titleLable.textColor = UIColor.label
        titleLable.font = UIFont.boldSystemFont(ofSize: 16)
        
        contentLabel.textColor = UIColor.systemGray
        contentLabel.font = UIFont.systemFont(ofSize: 14)
        dateLabel.textColor = UIColor.systemGray
        dateLabel.font = UIFont.systemFont(ofSize: 14)
    }
    
    func configureContent(title: String, content: String? = nil, date: Date? = nil) {
        titleLable.text = title
        if let content {
            contentLabel.text = content
        }
        if let date {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "ko_KR")
            formatter.dateFormat = "yyyy년 M월 d일 EEEE"
            dateLabel.text = formatter.string(from: date)
        }
    }
}
