//
//  ReminderMainTableViewCell.swift
//  CodebasePractice
//
//  Created by Minjae Kim on 7/3/24.
//

import UIKit

import SnapKit

final class ReminderMainTableViewCell: BaseTableViewCell {
    
    lazy var reminderMainCollectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
    
    func collectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            let width = windowScene.screen.bounds.width - 48
            layout.itemSize = CGSize(width: width / 2, height: width / 2 * 0.45)
            layout.scrollDirection = .vertical
            layout.minimumLineSpacing = 10
            layout.minimumInteritemSpacing = 10
            layout.sectionInset = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
        }
        return layout
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        reminderMainCollectionView.backgroundColor = UIColor.clear
    }
    
    override func configureHierarchy() {
        contentView.addSubview(reminderMainCollectionView)
    }
    
    override func configureLayout() {
        reminderMainCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
