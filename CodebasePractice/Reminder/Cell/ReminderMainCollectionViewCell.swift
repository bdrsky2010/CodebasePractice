//
//  ReminderMainCollectionViewCell.swift
//  CodebasePractice
//
//  Created by Minjae Kim on 7/3/24.
//

import UIKit

import SnapKit


final class ReminderMainCollectionViewCell: BaseCollectionViewCell {
    
    let cellBackgroundView = UIView()
    let imageBackgroundView = UIView()
    let imageView = UIImageView()
    let titleLabel = UILabel()
    let countLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    override func configureView() {
        cellBackgroundView.backgroundColor = UIColor.systemBackground
        imageBackgroundView.backgroundColor = UIColor.white
    }
    
    override func configureHierarchy() {
        addSubview(cellBackgroundView)
        cellBackgroundView.addSubview(imageBackgroundView)
        cellBackgroundView.addSubview(imageView)
        cellBackgroundView.addSubview(titleLabel)
        cellBackgroundView.addSubview(countLabel)
    }
    
    override func configureLayout() {
        cellBackgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        imageBackgroundView.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().offset(12)
            make.size.equalTo(24)
        }
        
        imageView.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().offset(8)
            make.size.equalTo(32)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.bottom.equalToSuperview().inset(8)
        }
        
        countLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(8)
            make.trailing.equalToSuperview().inset(16)
        }
    }
    
    private func configureUI() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            imageBackgroundView.layer.cornerRadius = imageBackgroundView.bounds.width / 2
            imageView.layer.cornerRadius = imageView.bounds.width / 2
        }
        cellBackgroundView.layer.cornerRadius = 10
        titleLabel.textColor = UIColor.systemGray
        titleLabel.font = UIFont.boldSystemFont(ofSize: 14)
        countLabel.font = UIFont.systemFont(ofSize: 28, weight: .black)
    }
    
    func configureImage(image: UIImage, tintColor: UIColor) {
        imageView.image = image
        imageView.tintColor = tintColor
    }
    
    func configureTitle(title: String) {
        titleLabel.text = title
    }
    
    func configureCount(count: Int) {
        countLabel.text = "\(count)"
    }
}
