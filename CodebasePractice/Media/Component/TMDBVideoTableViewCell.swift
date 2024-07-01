//
//  TMDBVideoTableViewCell.swift
//  CodebasePractice
//
//  Created by Minjae Kim on 7/1/24.
//

import UIKit

import Kingfisher
import SnapKit

final class TMDBVideoTableViewCell: BaseTableViewCell {
    
    private let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.lightGray
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let typeLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.numberOfLines = 2
        label.textColor = UIColor.label
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    override func configureHierarchy() {
        contentView.addSubview(thumbnailImageView)
        contentView.addSubview(typeLabel)
        contentView.addSubview(nameLabel)
    }
    
    override func configureLayout() {
        thumbnailImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.verticalEdges.equalToSuperview().inset(16)
            make.width.equalToSuperview().multipliedBy(0.4)
        }
        
        typeLabel.snp.makeConstraints { make in
            make.top.equalTo(thumbnailImageView.snp.top).offset(4)
            make.leading.equalTo(thumbnailImageView.snp.trailing).offset(16)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(typeLabel.snp.bottom).offset(8)
            make.leading.equalTo(thumbnailImageView.snp.trailing).offset(16)
            make.trailing.equalToSuperview().offset(-20)
        }
    }
    
    func configureContent(key: String, type: String, name: String) {
        if let url = ImageURL.youtubeThumbnail(key).urlString.stringToURL {
            thumbnailImageView.configureImageWithKF(url: url)
        }
        typeLabel.text = type
        nameLabel.text = name
    }
}
