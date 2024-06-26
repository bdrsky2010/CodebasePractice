//
//  SaveContentsViewController.swift
//  CodebasePractice
//
//  Created by Minjae Kim on 6/4/24.
//

import UIKit

class SaveContentsViewController: UIViewController {

    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "저장한 콘텐츠 목록"
        label.font = .boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    let emptyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.image = UIImage(named: "dummy")
        return imageView
    }()
    
    let featureLabel: UILabel = {
        let label = UILabel()
        label.text = "'나만의 자동 저장' 기능"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "취향에 맞는 영화와 시리즈를 자동으로 저장해드립니다.\n디바이스에 언제나 시청할 콘텐츠가 준비되니 지루할 틈이\n없어요."
        label.font = .systemFont(ofSize: 13, weight: .bold)
        label.textColor = .darkGray
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let settingButton: UIButton = {
        let button = UIButton()
        button.configuration = .bordered()
        
        button.configuration?.attributedTitle = AttributedString(NSAttributedString(string: "설정하기",
                                                                                    attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .bold),
                                                                                                 NSAttributedString.Key.foregroundColor: UIColor.white]))
        button.configuration?.baseBackgroundColor = .systemIndigo
        return button
    }()
    
    let storableCheckButton: UIButton = {
        let button = UIButton()
        button.configuration = .bordered()
        
        button.configuration?.attributedTitle = AttributedString(NSAttributedString(string: "저장 가능한 콘텐츠 살펴보기",
                                                                                    attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .bold),
                                                                                                 NSAttributedString.Key.foregroundColor: UIColor.black]))
        button.configuration?.baseBackgroundColor = .white
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black
        configureHierarchy()
        configureLayout()
        
        settingButton.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
    }
    
    @objc
    private func buttonClicked() {
        let loginNavigationContoller = UINavigationController(rootViewController: LoginViewController())
        loginNavigationContoller.modalPresentationStyle = .fullScreen
        present(loginNavigationContoller, animated: true)
    }

    func configureHierarchy() {
        view.addSubview(titleLabel)
        view.addSubview(emptyImageView)
        view.addSubview(featureLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(settingButton)
        view.addSubview(storableCheckButton)
    }
    
    func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(30)
        }
        
        emptyImageView.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
            make.centerY.equalTo(view.snp.centerY)
        }
        
        featureLabel.snp.makeConstraints { make in
            make.centerX.equalTo(emptyImageView.snp.centerX)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(featureLabel.snp.bottom).offset(8)
            make.centerX.equalTo(emptyImageView.snp.centerX)
            make.bottom.equalTo(emptyImageView.snp.top).inset(8)
        }
        
        settingButton.snp.makeConstraints { make in
            make.top.equalTo(emptyImageView.snp.bottom).offset(40)
            make.horizontalEdges.equalToSuperview().inset(70)
        }
        
        storableCheckButton.snp.makeConstraints { make in
            make.top.equalTo(settingButton.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(100)
        }
    }
}
