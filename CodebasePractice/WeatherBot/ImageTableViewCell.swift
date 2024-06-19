//
//  ImageTableViewCell.swift
//  CodebasePractice
//
//  Created by Minjae Kim on 6/19/24.
//

import UIKit

import SnapKit


final class ImageTableViewCell: UITableViewCell {
    
    private let imageBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let weatherImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        contentView.backgroundColor = .clear
        contentView.addSubview(imageBackgroundView)
        imageBackgroundView.addSubview(weatherImageView)
        
        imageBackgroundView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(8)
            make.leading.equalToSuperview().offset(20)
            make.width.equalToSuperview().multipliedBy(0.55)
            make.height.equalTo(160)
        }
        
        weatherImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configureImage(image: String) {
        guard let url = URL(string: ImageURL.weatherIcon(image).urlString) else { return }
        weatherImageView.configureImageWithKF(url: url)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
