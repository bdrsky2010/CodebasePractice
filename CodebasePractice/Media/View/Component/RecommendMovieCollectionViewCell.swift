//
//  RecommendMovieCollectionViewCell.swift
//  CodebasePractice
//
//  Created by Minjae Kim on 6/24/24.
//

import UIKit

import SnapKit
import Kingfisher

final class RecommendMovieCollectionViewCell: UICollectionViewCell, ConfigureViewProtocol {
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    func configureView() {
        configureHierarchy()
        configureLayout()
    }
    
    func configureHierarchy() {
        contentView.addSubview(posterImageView)
    }
    
    func configureLayout() {
        posterImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configureContent(imagePath: String) {
        guard let url = ImageURL.tmdbMovie(imagePath).urlString.stringToURL else { return }
        posterImageView.configureImageWithKF(url: url)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
