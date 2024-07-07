//
//  ReminderImageAddAndEditTableViewCell.swift
//  CodebasePractice
//
//  Created by Minjae Kim on 7/7/24.
//

import UIKit

import SnapKit

final class ReminderImageAddAndEditTableViewCell: BaseTableViewCell {
    
    private let selectedimageView = UIImageView()
    private let titleLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    override func configureHierarchy() {
        contentView.addSubview(selectedimageView)
        contentView.addSubview(titleLabel)
    }
    
    override func configureLayout() {
        selectedimageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
            make.size.equalTo(28)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(selectedimageView.snp.trailing).offset(20)
            make.centerY.equalToSuperview()
        }
    }
    
    private func configureUI() {
        selectedimageView.contentMode = .scaleToFill
        selectedimageView.layer.cornerRadius = 8
        selectedimageView.clipsToBounds = true
        titleLabel.text = "이미지"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 14)
    }
    
    func configureImage(image: UIImage) {
        selectedimageView.image = image
    }
}
