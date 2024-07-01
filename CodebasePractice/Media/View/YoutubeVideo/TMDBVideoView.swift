//
//  TMDBVideoView.swift
//  CodebasePractice
//
//  Created by Minjae Kim on 7/1/24.
//

import UIKit

import Kingfisher
import SnapKit

final class TMDBVideoView: BaseView {
    
    let backdropImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.backgroundColor = .systemIndigo
        return imageView
    }()
    
    let backdropImageCoverView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.layer.opacity = 0.2
        return view
    }()
    
    let videoNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let tmdbVideoTableView = UITableView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func configureView() {
        backgroundColor = .white
    }
    
    override func configureHierarchy() {
        addSubview(backdropImageView)
        addSubview(backdropImageCoverView)
        addSubview(posterImageView)
        addSubview(videoNameLabel)
        addSubview(tmdbVideoTableView)
    }
    
    override func configureLayout() {
        backdropImageView.snp.makeConstraints { make in
            make.horizontalEdges.top.equalTo(safeAreaLayoutGuide)
            make.height.equalToSuperview().multipliedBy(0.3)
        }
        
        backdropImageCoverView.snp.makeConstraints { make in
            make.horizontalEdges.verticalEdges.equalTo(backdropImageView)
        }
        
        posterImageView.snp.makeConstraints { make in
            make.leading.equalTo(backdropImageCoverView.snp.leading).offset(24)
            make.height.equalTo(backdropImageCoverView.snp.height).multipliedBy(0.6)
            make.width.equalTo(posterImageView.snp.height).multipliedBy(0.7)
            make.bottom.equalTo(backdropImageCoverView.snp.bottom).offset(-12)
        }
        
        videoNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(posterImageView.snp.leading)
            make.bottom.equalTo(posterImageView.snp.top).offset(-8)
        }
        
        tmdbVideoTableView.snp.makeConstraints { make in
            make.top.equalTo(backdropImageView.snp.bottom)
            make.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
}
