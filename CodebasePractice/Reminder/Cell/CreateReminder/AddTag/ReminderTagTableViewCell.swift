//
//  ReminderTagTableViewCell.swift
//  CodebasePractice
//
//  Created by Minjae Kim on 7/7/24.
//

import UIKit

import SnapKit

final class ReminderTagTableViewCell: BaseTableViewCell {
    
    let addTagCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    override func configureHierarchy() {
        contentView.addSubview(addTagCollectionView)
    }
    
    override func configureLayout() {
        addTagCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
