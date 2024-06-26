//
//  NewAndHotViewController.swift
//  CodebasePractice
//
//  Created by Minjae Kim on 6/4/24.
//

import UIKit
import SnapKit

final class NewAndHotViewController: UIViewController {

    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "NEW & HOT 검색"
        label.font = .boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()

    let searchView: UIView = {
        let uiView = UIView()
        uiView.backgroundColor = .darkGray
        uiView.layer.cornerRadius = 5
        return uiView
    }()
    
    let searchImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "magnifyingglass")
        imageView.tintColor = .systemGray
        return imageView
    }()
    
    let searchTextField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(string: "게임, 시리즈, 영화를 검색하세오...", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray])
        textField.borderStyle = .none
        return textField
    }()
    
    let revealButton: UIButton = {
        let button = UIButton()
        button.configuration = .filled()
        button.configuration?.cornerStyle = .capsule
        button.configuration?.image = UIImage(named: "blue")
        button.configuration?.attributedTitle = AttributedString(NSAttributedString(string: "공개 예정",
                                                                                    attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13, weight: .bold),
                                                                                                 NSAttributedString.Key.foregroundColor: UIColor.black]))
        button.configuration?.baseBackgroundColor = .white
        button.tag = 0
        return button
    }()
    
    let popularityButton: UIButton = {
        let button = UIButton()
        button.configuration = .filled()
        button.configuration?.cornerStyle = .capsule
        button.configuration?.image = UIImage(named: "turquoise")
        button.configuration?.attributedTitle = AttributedString(NSAttributedString(string: "모두의 인기 콘텐츠",
                                                                                    attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13, weight: .bold),
                                                                                                 NSAttributedString.Key.foregroundColor: UIColor.white]))
        button.configuration?.baseBackgroundColor = .black
        button.tag = 1
        return button
    }()
    
    let topTenButton: UIButton = {
        let button = UIButton()
        button.configuration = .filled()
        button.configuration?.cornerStyle = .capsule
        button.configuration?.image = UIImage(named: "pink")
        button.configuration?.attributedTitle = AttributedString(NSAttributedString(string: "TOP 10 시리즈",
                                                                                    attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13, weight: .bold),
                                                                                                 NSAttributedString.Key.foregroundColor: UIColor.white]))
        button.configuration?.baseBackgroundColor = .black
        button.tag = 2
        return button
    }()
    
    let noResultLabel: UILabel = {
        let label = UILabel()
        label.text = "이런! 찾으시는 작품이 없습니다."
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    let subLabel: UILabel = {
        let label = UILabel()
        label.text = "다른 영화, 시리즈, 배우, 감독 또는 장르를 검색해보세요."
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .darkGray
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black
        configureHierarchy()
        configureLayout()
//        configureUI()
    }
    
    func configureHierarchy() {
        view.addSubview(titleLabel)
        view.addSubview(searchView)
        searchView.addSubview(searchImageView)
        searchView.addSubview(searchTextField)
        view.addSubview(revealButton)
        view.addSubview(popularityButton)
        view.addSubview(topTenButton)
        view.addSubview(noResultLabel)
        view.addSubview(subLabel)
    }
    
    func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(30)
        }
        
        searchView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(28)
            make.height.equalTo(40)
        }
        
        searchImageView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(4)
            make.leading.equalToSuperview().offset(8)
            make.width.equalTo(searchImageView.snp.height)
        }
        
        searchTextField.snp.makeConstraints { make in
            make.leading.equalTo(searchImageView.snp.trailing).offset(8)
            make.trailing.equalToSuperview().offset(-8)
            make.centerY.equalTo(searchImageView.snp.centerY)
        }
        
        revealButton.snp.makeConstraints { make in
            make.top.equalTo(searchView.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(2)
            make.height.equalTo(30)
        }
        
        popularityButton.snp.makeConstraints { make in
            make.top.equalTo(revealButton.snp.top)
            make.leading.equalTo(revealButton.snp.trailing).offset(4)
            make.height.equalTo(revealButton.snp.height)
        }
        
        topTenButton.snp.makeConstraints { make in
            make.top.equalTo(revealButton.snp.top)
            make.leading.equalTo(popularityButton.snp.trailing).offset(4)
            make.trailing.equalToSuperview().inset(4)
            make.height.equalTo(revealButton.snp.height)
        }
        
        noResultLabel.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
            make.centerY.equalTo(view.snp.centerY)
        }
        
        subLabel.snp.makeConstraints { make in
            make.top.equalTo(noResultLabel.snp.bottom).offset(4)
            make.centerX.equalTo(noResultLabel.snp.centerX)
        }
    }
    
//    func configureUI() {
//        revealButton.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
//        popularityButton.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
//        topTenButton.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
//    }
//    
//    @objc private func buttonClicked(sender: UIButton) {
//        if sender.tag == 0 {
//            revealButton.configuration?.baseBackgroundColor = .white
//            popularityButton.configuration?.baseBackgroundColor = .black
//            topTenButton.configuration?.baseBackgroundColor = .black
//            
//        } else if sender.tag == 1 {
//            revealButton.configuration?.baseBackgroundColor = .black
//            popularityButton.configuration?.baseBackgroundColor = .white
//            topTenButton.configuration?.baseBackgroundColor = .black
//            
//        } else {
//            revealButton.configuration?.baseBackgroundColor = .black
//            popularityButton.configuration?.baseBackgroundColor = .black
//            topTenButton.configuration?.baseBackgroundColor = .white
//            
//        }
//    }
}
