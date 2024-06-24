//
//  RecommendMovieCollectionView.swift
//  CodebasePractice
//
//  Created by Minjae Kim on 6/24/24.
//

import UIKit

final class RecommendMovieCollectionView: UICollectionView {
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
    }
    
    convenience init() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumInteritemSpacing = 8
        flowLayout.minimumLineSpacing = 8
        flowLayout.sectionInset = .init(top: 0, left: 8, bottom: 0, right: 8)
        self.init(frame: .zero, collectionViewLayout: flowLayout)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
