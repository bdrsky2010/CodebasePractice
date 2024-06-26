//
//  RecommendMovieTableViewCell.swift
//  CodebasePractice
//
//  Created by Minjae Kim on 6/24/24.
//

import UIKit

import SnapKit

final class RecommendMovieTableViewCell: UITableViewCell {
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout())
    
    static func flowLayout() -> UICollectionViewFlowLayout {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 8
        flowLayout.sectionInset = .init(top: 0, left: 8, bottom: 0, right: 8)
        return flowLayout
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
