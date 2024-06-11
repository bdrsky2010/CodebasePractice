//
//  MovieSearchCollectionViewCell.swift
//  CodebasePractice
//
//  Created by Minjae Kim on 6/11/24.
//

import UIKit

class MovieSearchCollectionViewCell: UICollectionViewCell, ConfigureViewProtocol {
    
    private let shadowBackgoundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.shadowColor = UIColor.systemGray.cgColor
        view.layer.shadowOpacity = 0.8
        view.layer.shadowRadius = 10
        view.layer.shadowOffset = .init(width: 1, height: 1)
        return view
    }()
    
    private let mainCellView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .pastelGreen
        return imageView
    }()
    
    private let posterCoverView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.layer.opacity = 0.5
        return view
    }()
    
    private let starImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "star.fill")
        imageView.tintColor = .systemYellow
        imageView.preferredSymbolConfiguration = .init(pointSize: 13)
        return imageView
    }()
    
    private let voteAverageLable: UILabel = {
        let label = UILabel()
        label.text = "3.3"
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = .white
        return label
    }()
    
    private let titleLable: UILabel = {
        let label = UILabel()
        label.text = "해리의 소동"
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    private let originalTitleLable: UILabel = {
        let label = UILabel()
        label.text = "The Trouble with Harry"
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .white
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        backgroundColor = .pastelPurple
        
        configureHierarchy()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureHierarchy() {
        contentView.addSubview(shadowBackgoundView)
        contentView.addSubview(mainCellView)
        mainCellView.addSubview(posterImageView)
        mainCellView.addSubview(posterCoverView)
        mainCellView.addSubview(starImageView)
        mainCellView.addSubview(voteAverageLable)
        mainCellView.addSubview(titleLable)
        mainCellView.addSubview(originalTitleLable)
    }
    
    func configureLayout() {
        shadowBackgoundView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }
        
        mainCellView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }
        
        posterImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        posterCoverView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        originalTitleLable.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalToSuperview().inset(4)
        }
        
        titleLable.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(4)
            make.bottom.equalTo(originalTitleLable.snp.top)
        }
        
        starImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(4)
            make.width.height.equalTo(13)
            make.centerY.equalTo(voteAverageLable.snp.centerY).offset(-1)
        }
        
        voteAverageLable.snp.makeConstraints { make in
            make.leading.equalTo(starImageView.snp.trailing).offset(2)
            make.trailing.equalToSuperview().offset(-4)
            make.bottom.equalTo(titleLable.snp.top).offset(-4)
        }
    }
    
    private func roundTwo(num: Double) -> Double {
        let digit: Double = 10.0
        return round(num * digit) / digit
    }
    
    func configureContent(_ movie: MovieSearch) {
        if let posterPath = movie.poster_path,
           let url = ImageURL.tmdbMovie(posterPath).urlString.stringToURL {
            posterImageView.configureImageWithKF(url: url)
        }
        
        voteAverageLable.text = "\(roundTwo(num: movie.vote_average))"
        titleLable.text = movie.title
        originalTitleLable.text = movie.original_title
    }
}
