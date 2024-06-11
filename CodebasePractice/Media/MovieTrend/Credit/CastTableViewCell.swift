//
//  CastTableViewCell.swift
//  CodebasePractice
//
//  Created by Minjae Kim on 6/11/24.
//

import UIKit

import Kingfisher
import SnapKit

final class CastTableViewCell: UITableViewCell, ConfigureViewProtocol {
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    private let characterLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.systemGray
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureHierarchy()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureHierarchy() {
        contentView.addSubview(profileImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(characterLabel)
    }
    
    func configureLayout() {
        profileImageView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(8)
            make.leading.equalToSuperview().offset(20)
            make.height.equalTo(60)
            make.width.equalTo(40)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(20)
            make.trailing.equalTo(contentView.snp.trailing).offset(-20)
            make.bottom.equalTo(profileImageView.snp.centerY).offset(-2)
        }
        
        characterLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.centerY).offset(2)
            make.leading.equalTo(profileImageView.snp.trailing).offset(20)
            make.trailing.equalTo(contentView.snp.trailing).offset(-20)
        }
    }
    
    func configureContent(_ cast: Cast) {
        if let profilePath = cast.profile_path,
           let url = ImageURL.tmdbMovie(profilePath).urlString.stringToURL {
            profileImageView.configureImageWithKF(url: url)
        }
        
        nameLabel.text = cast.name
        
        if let character = cast.character {
            characterLabel.text = character
        }
    }
}
