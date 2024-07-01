//
//  RandomNasaImageView.swift
//  CodebasePractice
//
//  Created by Minjae Kim on 7/1/24.
//

import UIKit

import Kingfisher
import SnapKit

final class RandomNasaImageView: BaseView {
    
    private let nasaImageView = UIImageView()
    private let emptyImageView = UIImageView()
    
    private let downloadLabel = UILabel()
    let downloadButton = UIButton(type: .system)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    override func configureView() {
        backgroundColor = .white
    }
    
    override func configureHierarchy() {
        addSubview(nasaImageView)
        addSubview(emptyImageView)
        addSubview(downloadButton)
        addSubview(downloadLabel)
    }
    
    override func configureLayout() {
        nasaImageView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(safeAreaLayoutGuide)
            make.centerY.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(safeAreaLayoutGuide).multipliedBy(0.5)
        }
        
        emptyImageView.snp.makeConstraints { make in
            make.center.equalTo(safeAreaLayoutGuide)
            make.size.equalTo(safeAreaLayoutGuide.snp.width).multipliedBy(0.5)
        }
        
        downloadButton.snp.makeConstraints { make in
            make.leading.bottom.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(40)
        }
        
        downloadLabel.snp.makeConstraints { make in
            make.centerY.equalTo(downloadButton.snp.centerY)
            make.trailing.equalTo(safeAreaLayoutGuide).inset(16)
        }
    }
    
    private func configureUI() {
        downloadButton.configuration = .plain()
        downloadButton.configuration?.image = UIImage(systemName: "arrow.clockwise.circle.fill")
        downloadButton.configuration?.imagePlacement = .leading
        downloadButton.configuration?.imagePadding = 8
        downloadButton.configuration?.attributedTitle = AttributedString(NSAttributedString(string: "랜덤 나사 이미지 생성",
                                                                                            attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18)]))
        downloadButton.configuration?.baseForegroundColor = UIColor.systemOrange
        
        downloadLabel.font = UIFont.boldSystemFont(ofSize: 18)
        downloadLabel.textColor = UIColor.systemOrange
        
        emptyImageView.image = UIImage(named: "보노보노")
    }
    
    func configureContentImage(_ data: Data) {
        nasaImageView.isHidden = false
        emptyImageView.isHidden = true
        nasaImageView.image = UIImage(data: data)
    }
    
    func configureContentImage() {
        nasaImageView.isHidden = true
        emptyImageView.isHidden = false
    }
    
    func configureContentLabel(_ text: String) {
        downloadLabel.text = text
    }
}
