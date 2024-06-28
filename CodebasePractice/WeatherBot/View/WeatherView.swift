//
//  WeatherView.swift
//  CodebasePractice
//
//  Created by Minjae Kim on 6/26/24.
//

import UIKit

import SnapKit


final class WeatherView: BaseView {
    
    let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: WeatherCondition.allCases.randomElement()!.rawValue)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let dateTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .white
        return label
    }()
    
    let locationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .white
        return label
    }()
    
    let locationButton: UIButton = {
        let button = UIButton(type: .system)
        button.configuration = .plain()
        button.configuration?.image = UIImage(systemName: "location.fill")
        button.configuration?.baseForegroundColor = UIColor.white
        button.configuration?.preferredSymbolConfigurationForImage = .init(pointSize: 20)
        return button
    }()
    
    let sharedButton: UIButton = {
        let button = UIButton(type: .system)
        button.configuration = .plain()
        button.configuration?.image = UIImage(systemName: "square.and.arrow.up")
        button.configuration?.baseForegroundColor = UIColor.white
        button.configuration?.preferredSymbolConfigurationForImage = .init(pointSize: 14)
        return button
    }()
    
    let refreshButton: UIButton = {
        let button = UIButton(type: .system)
        button.configuration = .plain()
        button.configuration?.image = UIImage(systemName: "arrow.clockwise")
        button.configuration?.baseForegroundColor = UIColor.white
        button.configuration?.preferredSymbolConfigurationForImage = .init(pointSize: 14)
        return button
    }()
    
    let messageTableView = UITableView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func configureHierarchy() {
        addSubview(backgroundImageView)
        addSubview(dateTimeLabel)
        addSubview(locationButton)
        addSubview(locationLabel)
        addSubview(refreshButton)
        addSubview(sharedButton)
        addSubview(messageTableView)
    }
    
    override func configureView() {
        backgroundColor = .systemBackground
    }
    
    override func configureLayout() {
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        dateTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.leading.equalTo(safeAreaLayoutGuide).offset(28)
        }
        
        locationButton.snp.makeConstraints { make in
            make.top.equalTo(dateTimeLabel.snp.bottom).offset(16)
            make.leading.equalTo(safeAreaLayoutGuide).offset(20)
            make.width.equalTo(30)
        }
        
        locationLabel.snp.makeConstraints { make in
            make.centerY.equalTo(locationButton.snp.centerY)
            make.leading.equalTo(locationButton.snp.trailing).offset(20)
            make.trailing.equalTo(refreshButton.snp.leading).offset(-20)
        }
        
        refreshButton.snp.makeConstraints { make in
            make.centerY.equalTo(locationButton.snp.centerY)
            make.trailing.equalTo(safeAreaLayoutGuide).offset(-20)
            make.width.equalTo(20)
        }
        
        sharedButton.snp.makeConstraints { make in
            make.centerY.equalTo(locationButton.snp.centerY)
            make.trailing.equalTo(refreshButton.snp.leading).offset(-20)
            make.width.equalTo(20)
        }
        
        messageTableView.snp.makeConstraints { make in
            make.top.equalTo(locationButton.snp.bottom).offset(8)
            make.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
}
