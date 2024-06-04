//
//  HomeViewController.swift
//  CodebasePractice
//
//  Created by Minjae Kim on 6/4/24.
//

import UIKit
import SnapKit

final class HomeViewController: UIViewController, ConfigureViewProtocol {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "고래밥님"
        label.font = .boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.backgroundColor = .systemGray
        return imageView
    }()
    
    let posterCoverView: UIView = {
        let uiView = UIView()
        uiView.layer.cornerRadius = 10
        uiView.clipsToBounds = true
        return uiView
    }()
    
    let playButton: UIButton = {
        let button = UIButton()
        button.configuration = .plain()
        button.configuration?.background.cornerRadius = 5
        button.configuration?.attributedTitle = AttributedString(NSAttributedString(string: "재생", 
                                                                                    attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .bold)]))
        button.configuration?.baseForegroundColor = .black
        button.configuration?.background.backgroundColor = .white
        button.configuration?.image = UIImage(named: "play")
        button.configuration?.imagePadding = 4
        return button
    }()
    
    let saveListButton: UIButton = {
        let button = UIButton()
        button.configuration = .plain()
        button.configuration?.background.cornerRadius = 5
        button.configuration?.attributedTitle = AttributedString(NSAttributedString(string: "내가 찜한 리스트",
                                                                                    attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .bold)]))
        button.configuration?.baseForegroundColor = .white
        button.configuration?.background.backgroundColor = .darkGray
        button.configuration?.image = UIImage(systemName: "plus")
        button.configuration?.imagePadding = 4
        return button
    }()
    
    let subTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "지금 뜨는 콘텐츠"
        label.textColor = .white
        return label
    }()
    
    let leftPosterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 5
        imageView.backgroundColor = .systemRed
//        imageView.image = UIImage(named: "범죄도시3")
        return imageView
    }()
    
    let centerPosterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 5
        imageView.backgroundColor = .systemGreen
//        imageView.image = UIImage(named: "범죄도시3")
        return imageView
    }()
    
    let rightPosterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 5
        imageView.backgroundColor = .systemBlue
//        imageView.image = UIImage(named: "범죄도시3")
        return imageView
    }()
    
    private var contents = ["노량", "더퍼스트슬램덩크", "밀수", "범죄도시3", "서울의봄", "스즈메의문단속", "아바타물의길", "오펜하이머", "육사오", "콘크리트유토피아"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black
        configureHierarchy()
        configureLayout()
        configureContent()
    }
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        configureContent()
//    }

    func configureHierarchy() {
        view.addSubview(titleLabel)
        view.addSubview(posterImageView)
        view.addSubview(posterCoverView)
        posterCoverView.addSubview(playButton)
        posterCoverView.addSubview(saveListButton)
        view.addSubview(subTitleLabel)
        view.addSubview(leftPosterImageView)
        view.addSubview(centerPosterImageView)
        view.addSubview(rightPosterImageView)
    }
    
    func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(30)
        }
        
        posterImageView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(view.snp.height).multipliedBy(0.5)
        }
        
        posterCoverView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(posterImageView.snp.height)
        }
        
        playButton.snp.makeConstraints { make in
            make.leading.bottom.equalToSuperview().inset(12)
            make.height.equalTo(40)
        }
        
        saveListButton.snp.makeConstraints { make in
            make.leading.equalTo(playButton.snp.trailing).offset(12)
            make.trailing.bottom.equalToSuperview().inset(12)
            make.width.equalTo(playButton.snp.width)
            make.height.equalTo(40)
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(posterCoverView.snp.bottom).offset(6)
            make.leading.equalToSuperview().offset(4)
        }
        
        leftPosterImageView.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel.snp.bottom).offset(6)
            make.leading.equalToSuperview().offset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-8)
        }
        
        centerPosterImageView.snp.makeConstraints { make in
            make.top.equalTo(leftPosterImageView.snp.top)
            make.leading.equalTo(leftPosterImageView.snp.trailing).offset(4)
            make.width.equalTo(leftPosterImageView.snp.width)
            make.bottom.equalTo(leftPosterImageView.snp.bottom)
        }
        
        rightPosterImageView.snp.makeConstraints { make in
            make.top.equalTo(leftPosterImageView.snp.top)
            make.leading.equalTo(centerPosterImageView.snp.trailing).offset(4)
            make.width.equalTo(leftPosterImageView.snp.width)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalTo(leftPosterImageView.snp.bottom)
        }
    }
    
    func configureContent() {
        randomContentImage()
        
        playButton.addTarget(self, action: #selector(randomContentImage), for: .touchUpInside)
    }
    
    @objc
    private func randomContentImage() {
        contents.shuffle()
        posterImageView.image = UIImage(named: contents[0])
        leftPosterImageView.image = UIImage(named: contents[1])
        centerPosterImageView.image = UIImage(named: contents[2])
        rightPosterImageView.image = UIImage(named: contents[3])
        print(titleLabel.frame.origin)
        print(posterCoverView.frame.origin)
    }
}
