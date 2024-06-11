//
//  MovieTrendTableViewCell.swift
//  CodebasePractice
//
//  Created by Minjae Kim on 6/10/24.
//

import UIKit

import Kingfisher
import SnapKit

class MovieTrendTableViewCell: UITableViewCell, ConfigureViewProtocol {

    private let releaseDateLabel: UILabel = {
        let label = UILabel()
        label.text = "12/10/2020"
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = UIColor.darkGray
        return label
    }()
    
    private let genreLabel: UILabel = {
        let label = UILabel()
        label.text = "#Mystery"
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = UIColor.label
        return label
    }()
    
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
    
    private let backdropImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.lightGray
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let voteAverageStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 0
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private let voteAverageTitleLable: UILabel = {
        let label = UILabel()
        label.text = "평점"
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = .white
        label.textAlignment = .center
        label.backgroundColor = .systemIndigo
        return label
    }()
    
    private let voteAverageLable: UILabel = {
        let label = UILabel()
        label.text = "3.3"
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textAlignment = .center
        label.backgroundColor = .white
        return label
    }()
    
    private let movieTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "안녕안녕안녕"
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    private let castLabel: UILabel = {
        let label = UILabel()
        label.text = "안녕안녕안녕안녕안녕안녕안녕안녕안녕안녕안녕안녕안녕안녕안녕안녕안녕안녕안녕"
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        return label
    }()
    
    private let dividerBackgroundView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let divider: UIView = {
        let view = UIView()
        view.backgroundColor = .label
        return view
    }()
    
    private let showDetailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.text = "자세히 보기"
        return label
    }()
    
    private let showDetailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.forward")
        imageView.tintColor = .label
        return imageView
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
        contentView.addSubview(releaseDateLabel)
        contentView.addSubview(genreLabel)
        contentView.addSubview(shadowBackgoundView)
        contentView.addSubview(mainCellView)
        
        mainCellView.addSubview(backdropImageView)
        mainCellView.addSubview(voteAverageStackView)
        
        voteAverageStackView.addArrangedSubview(voteAverageTitleLable)
        voteAverageStackView.addArrangedSubview(voteAverageLable)
        
        mainCellView.addSubview(movieTitleLabel)
        mainCellView.addSubview(castLabel)
        
        mainCellView.addSubview(dividerBackgroundView)
        dividerBackgroundView.addSubview(divider)
        
        mainCellView.addSubview(showDetailLabel)
        mainCellView.addSubview(showDetailImageView)
    }
    
    func configureLayout() {
        releaseDateLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(20)
            make.leading.equalTo(contentView.snp.leading).offset(20)
        }
        
        genreLabel.snp.makeConstraints { make in
            make.top.equalTo(releaseDateLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        shadowBackgoundView.snp.makeConstraints { make in
            make.top.equalTo(genreLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(shadowBackgoundView.snp.width).multipliedBy(1)
            make.bottom.bottom.equalToSuperview().offset(-20)
        }
        
        mainCellView.snp.makeConstraints { make in
            make.edges.equalTo(shadowBackgoundView)
        }
        
        backdropImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(mainCellView).multipliedBy(0.6)
        }
        
        voteAverageStackView.snp.makeConstraints { make in
            make.leading.bottom.equalTo(backdropImageView).inset(16)
            make.width.equalTo(60)
            make.height.equalTo(20)
        }
        
        movieTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(backdropImageView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        castLabel.snp.makeConstraints { make in
            make.top.equalTo(movieTitleLabel.snp.bottom).offset(4)
            make.leading.trailing.equalTo(movieTitleLabel)
        }
        
        showDetailImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(12)
        }
        
        showDetailLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalTo(showDetailImageView.snp.centerY)
        }
        
        dividerBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(castLabel.snp.bottom)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalTo(showDetailImageView.snp.top)
        }
        
        divider.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    func configureContent(releaseDate: String, genre: String, imageUrl: URL?, voteAverage: Double, movieTitle: String, cast: String) {
        releaseDateLabel.text = releaseDate.movieTrendConvertDateToString
        genreLabel.text = genre
        
        if let imageUrl {
            backdropImageView.configureImageWithKF(url: imageUrl)
        }
        voteAverageLable.text = "\(voteAverage)"
        movieTitleLabel.text = movieTitle
        castLabel.text = cast
    }
}
