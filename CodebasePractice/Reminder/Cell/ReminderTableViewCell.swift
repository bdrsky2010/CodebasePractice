//
//  ReminderTableViewCell.swift
//  CodebasePractice
//
//  Created by Minjae Kim on 7/3/24.
//

import UIKit

import SnapKit


final class ReminderTableViewCell: BaseTableViewCell {
    lazy var imageHorizontalCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    
    private let layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 4
        layout.itemSize = CGSize(width: 28, height: 28)
        return layout
    }()
    
    let completeButton = UIButton(type: .system)
    
    private let priorityLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        return label
    }()
    
    private let flagImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "flag.fill")
        imageView.tintColor = UIColor.systemOrange
        imageView.isHidden = true
        return imageView
    }()
    
    private let titleLable = UILabel()
    private let contentLabel = UILabel()
    private let dateLabel = UILabel()
    private let tagLabel = UILabel()
    
    var selectedImageIDs: [String] = [] {
        didSet {
            if !selectedImageIDs.isEmpty {
                configureImageCollectionView()
                
                imageHorizontalCollectionView.snp.makeConstraints { make in
                    make.top.equalTo(tagLabel.snp.bottom).offset(8)
                    make.height.equalTo(28)
                    make.leading.equalTo(completeButton.snp.trailing).offset(8)
                    make.trailing.equalToSuperview().offset(-20)
                    make.bottom.equalToSuperview().offset(-8)
                }
                
                tagLabel.snp.remakeConstraints { make in
                    make.top.equalTo(dateLabel.snp.bottom)
                    make.leading.equalTo(completeButton.snp.trailing).offset(8)
                    make.bottom.equalTo(imageHorizontalCollectionView.snp.top).offset(-8)
                }
            } else {
                imageHorizontalCollectionView.isHidden = true
            }
        }
    }
    
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
        contentView.addSubview(tagLabel)
        contentView.addSubview(imageHorizontalCollectionView)
    }
    
    override func configureLayout() {
        print(#function)
        completeButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.equalToSuperview().offset(20)
            make.width.equalTo(completeButton.snp.height)
        }
        
        titleLable.snp.makeConstraints { make in
            make.centerY.equalTo(completeButton.snp.centerY)
            make.leading.equalTo(completeButton.snp.trailing).offset(8)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLable.snp.bottom)
            make.leading.equalTo(completeButton.snp.trailing).offset(8)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom)
            make.leading.equalTo(completeButton.snp.trailing).offset(8)
        }
        
        tagLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom)
            make.leading.equalTo(completeButton.snp.trailing).offset(8)
            make.bottom.equalToSuperview().offset(-8)
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
        
        tagLabel.textColor = UIColor.systemIndigo
        tagLabel.font = UIFont.systemFont(ofSize: 12, weight: .bold)
    }
    
    func configureContent(_ reminder: Reminder, optionColor: UIColor) {
        print(#function)
        configureButtonContent(isComplete: reminder.isComplete)
        
        priorityLabel.text = reminder.priority.text
        priorityLabel.textColor = optionColor
        
        if !reminder.priority.text.isEmpty {
            priorityLabel.isHidden = false
               
            priorityLabel.snp.makeConstraints { make in
                make.centerY.equalTo(completeButton.snp.centerY)
                make.leading.equalTo(completeButton.snp.trailing).offset(8)
                make.trailing.equalTo(titleLable.snp.leading).offset(-8)
            }
            
            titleLable.snp.remakeConstraints { make in
                make.centerY.equalTo(completeButton.snp.centerY)
                make.leading.equalTo(priorityLabel.snp.trailing).offset(8)
                make.trailing.equalToSuperview().offset(-20)
            }
        }
        
        if reminder.flag {
            flagImageView.isHidden = false
            flagImageView.snp.makeConstraints { make in
                make.centerY.equalTo(titleLable.snp.centerY)
                make.size.equalTo(titleLable.snp.height)
                make.trailing.equalToSuperview().offset(-20)
            }
            
            if reminder.priority.text.isEmpty {
                titleLable.snp.remakeConstraints { make in
                    make.centerY.equalTo(completeButton.snp.centerY)
                    make.leading.equalTo(completeButton.snp.trailing).offset(8)
                    make.trailing.equalTo(flagImageView.snp.leading).offset(-8)
                }
            } else {
                titleLable.snp.remakeConstraints { make in
                    make.centerY.equalTo(completeButton.snp.centerY)
                    make.leading.equalTo(priorityLabel.snp.trailing).offset(8)
                    make.trailing.equalTo(flagImageView.snp.leading).offset(-8)
                }
            }
        }
        
        titleLable.text = reminder.title
        titleLable.numberOfLines = 0
        
        if let content = reminder.content {
            contentLabel.text = content
            contentLabel.numberOfLines = 0
        }
        
        if let date = reminder.deadline {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "ko_KR")
            formatter.dateFormat = "yyyy년 M월 d일 EEEE"
            dateLabel.text = formatter.string(from: date)
        }
        
        tagLabel.text = reminder.tag.map { "#" + $0 }.joined(separator: " ")
        tagLabel.numberOfLines = 0
    }
    
    private func configureImageCollectionView() {
        imageHorizontalCollectionView.allowsSelection = false
        imageHorizontalCollectionView.dataSource = self
        imageHorizontalCollectionView.register(ReminderSelectedImageCollectionViewCell.self, forCellWithReuseIdentifier: ReminderSelectedImageCollectionViewCell.identifier)
    }
    
    func configureButtonContent(isComplete: Bool) {
        if isComplete {
            completeButton.configuration?.image = UIImage(systemName: "largecircle.fill.circle")
            completeButton.configuration?.baseForegroundColor = UIColor.systemOrange
        } else {
            completeButton.configuration?.image = UIImage(systemName: "circle")
            completeButton.configuration?.baseForegroundColor = UIColor.systemGray
        }
    }
}

extension ReminderTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedImageIDs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = imageHorizontalCollectionView.dequeueReusableCell(withReuseIdentifier: ReminderSelectedImageCollectionViewCell.identifier, for: indexPath) as? ReminderSelectedImageCollectionViewCell else { return UICollectionViewCell() }
        let id = selectedImageIDs[indexPath.row]
        cell.configureImage(image: ReminderManager.shared.loadImageToDocument(filename: id))
        return cell
    }
}
