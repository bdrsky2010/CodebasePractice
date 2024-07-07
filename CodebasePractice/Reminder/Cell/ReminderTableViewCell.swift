//
//  ReminderTableViewCell.swift
//  CodebasePractice
//
//  Created by Minjae Kim on 7/3/24.
//

import UIKit

import SnapKit


final class ReminderTableViewCell: BaseTableViewCell {
    let completeButton = UIButton(type: .system)
    let priorityLabel = UILabel()
    let titleLable = UILabel()
    let contentLabel = UILabel()
    let dateLabel = UILabel()
    let flagImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "flag.fill")
        imageView.tintColor = UIColor.systemOrange
        imageView.isHidden = true
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    override func configureHierarchy() {
        contentView.addSubview(completeButton)
        contentView.addSubview(priorityLabel)
        contentView.addSubview(titleLable)
        contentView.addSubview(flagImageView)
        contentView.addSubview(contentLabel)
        contentView.addSubview(dateLabel)
    }
    
    override func configureLayout() {
        completeButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.leading.equalToSuperview().offset(20)
            make.width.equalTo(completeButton.snp.height)
        }
        
        priorityLabel.snp.makeConstraints { make in
            make.centerY.equalTo(completeButton.snp.centerY)
            make.leading.equalTo(completeButton.snp.trailing).offset(8)
            make.trailing.equalTo(titleLable.snp.leading).offset(-8)
        }
        
        titleLable.snp.remakeConstraints { make in
            make.centerY.equalTo(completeButton.snp.centerY)
            make.leading.equalTo(priorityLabel.snp.trailing).offset(8)
            make.trailing.equalToSuperview().offset(-8)
        }
        
        flagImageView.snp.makeConstraints { make in
            make.centerY.equalTo(titleLable.snp.centerY)
            make.size.equalTo(titleLable.snp.height)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLable.snp.bottom).offset(8)
            make.leading.equalTo(titleLable.snp.leading)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(8)
            make.leading.equalTo(titleLable.snp.leading)
            make.bottom.equalToSuperview().inset(12)
        }
    }
    
    private func configureUI() {
        completeButton.configuration = .plain()
        completeButton.configuration?.preferredSymbolConfigurationForImage = .init(pointSize: 14, weight: .bold)
        completeButton.configuration?.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        titleLable.textColor = UIColor.label
        titleLable.font = UIFont.boldSystemFont(ofSize: 14)
        
        priorityLabel.font = UIFont.systemFont(ofSize: 14, weight: .black)
        
        contentLabel.textColor = UIColor.systemGray
        contentLabel.font = UIFont.systemFont(ofSize: 14, weight: .black)
        
        dateLabel.textColor = UIColor.systemGray
        dateLabel.font = UIFont.systemFont(ofSize: 14, weight: .black)
    }
    
    func configureContent(isComplete: Bool, title: String, content: String? = nil, date: Date? = nil, flag: Bool, priority: Priority, optionColor: UIColor) {
        configureButtonContent(isComplete: isComplete)
        titleLable.text = title
        titleLable.numberOfLines = 0
        titleLable.layer.borderColor = UIColor.red.cgColor
        titleLable.layer.borderWidth = 1
        if let content {
            contentLabel.text = content
            contentLabel.numberOfLines = 0
        }
        if let date {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "ko_KR")
            formatter.dateFormat = "yyyy년 M월 d일 EEEE"
            dateLabel.text = formatter.string(from: date)
        }
        if flag {
            flagImageView.isHidden = !flag
            titleLable.snp.remakeConstraints { make in
                make.centerY.equalTo(completeButton.snp.centerY)
                make.leading.equalTo(priorityLabel.snp.trailing).offset(8)
                make.trailing.equalTo(flagImageView.snp.leading).offset(-8)
            }
        }
        
        priorityLabel.text = priority.text
        priorityLabel.textColor = optionColor
    }
    
    private func configureButtonContent(isComplete: Bool) {
        if isComplete {
            completeButton.configuration?.image = UIImage(systemName: "largecircle.fill.circle")
            completeButton.configuration?.baseForegroundColor = UIColor.systemOrange
        } else {
            completeButton.configuration?.image = UIImage(systemName: "circle")
            completeButton.configuration?.baseForegroundColor = UIColor.systemGray
        }
    }
}
