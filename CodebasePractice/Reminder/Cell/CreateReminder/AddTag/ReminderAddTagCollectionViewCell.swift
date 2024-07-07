//
//  ReminderAddTagCollectionViewCell.swift
//  CodebasePractice
//
//  Created by Minjae Kim on 7/7/24.
//

import UIKit

import SnapKit

final class ReminderAddTagCollectionViewCell: BaseCollectionViewCell {
    
    let tagView = ReminderTagView()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func configureHierarchy() {
        contentView.addSubview(tagView)
    }
    
    override func configureLayout() {
        tagView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(4)
        }
    }
}
