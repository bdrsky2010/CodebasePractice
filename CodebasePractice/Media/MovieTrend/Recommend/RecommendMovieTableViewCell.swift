//
//  RecommendMovieTableViewCell.swift
//  CodebasePractice
//
//  Created by Minjae Kim on 6/24/24.
//

import UIKit

import SnapKit

final class RecommendMovieTableViewCell: UITableViewCell {
    
    private let collectionView = RecommendMovieCollectionView()
    
    private var movieList: [TMDBMovie] = []
    private var posterPathList: [String] = []
    
    var data: Decodable? {
        didSet {
            if let data = data as? [TMDBMovie] {
                movieList = data
            } else if let data = data as? [String] {
                posterPathList = data
            }
            collectionView.reloadData()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(RecommendMovieCollectionViewCell.self,
                                forCellWithReuseIdentifier: RecommendMovieCollectionViewCell.identifier)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension RecommendMovieTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return !movieList.isEmpty ? movieList.count : posterPathList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendMovieCollectionViewCell.identifier, for: indexPath) as? RecommendMovieCollectionViewCell else { return UICollectionViewCell() }
        
        let index = indexPath.row
        
        var imagePath: String
        
        if !movieList.isEmpty {
            let movie = movieList[index]
            imagePath = movie.poster_path
        } else {
            imagePath = posterPathList[index]
        }
        cell.configureContent(imagePath: imagePath)
        
        return cell
    }
}

extension RecommendMovieTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let totalWidth = collectionView.bounds.width
        
        if !movieList.isEmpty {
            let width = totalWidth / 3 - 20
            return CGSize(width: width, height: width * 1.5)
        } else {
            let width = totalWidth / 2 - 30
            return CGSize(width: width, height: width * 1.5)
        }
    }
}
