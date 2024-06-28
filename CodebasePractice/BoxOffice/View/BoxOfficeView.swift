//
//  BoxOfficeView.swift
//  CodebasePractice
//
//  Created by Minjae Kim on 6/26/24.
//

import UIKit

import SnapKit

final class BoxOfficeView: BaseView {
    
    let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "projector")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let backgroundCoverView: UIView = {
       let view = UIView()
        view.backgroundColor = .black
        view.layer.opacity = 0.7
        return view
    }()
    
    let searchButton: UIButton = {
        let button = UIButton()
        button.configuration = .filled()
        button.configuration?.baseBackgroundColor = .white
        button.configuration?.attributedTitle = AttributedString(NSAttributedString(string: "검색", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .regular), NSAttributedString.Key.foregroundColor: UIColor.black]))
        return button
    }()
    
    let searchTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.attributedPlaceholder = NSAttributedString(string: "여기에 날짜를 입력해보세요", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .regular), NSAttributedString.Key.foregroundColor: UIColor.white])
        textField.textColor = .white
        textField.font = .systemFont(ofSize: 14, weight: .regular)
        textField.keyboardType = .numberPad
        return textField
    }()
    
    let underBarView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let boxOfficeTableView = UITableView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func configureView() {
        backgroundColor = .systemBackground
    }
    
    override func configureHierarchy() {
        addSubview(backgroundImageView)
        addSubview(backgroundCoverView)
        addSubview(searchButton)
        addSubview(searchTextField)
        addSubview(underBarView)
        addSubview(boxOfficeTableView)
    }
    
    override func configureLayout() {
        backgroundImageView.snp.makeConstraints { make in
            make.horizontalEdges.verticalEdges.equalToSuperview()
        }
        
        backgroundCoverView.snp.makeConstraints { make in
            make.horizontalEdges.verticalEdges.equalToSuperview()
        }
        
        searchButton.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.trailing.equalTo(safeAreaLayoutGuide).inset(20)
            make.height.equalTo(40)
            make.width.equalTo(80)
        }
        
        searchTextField.snp.makeConstraints { make in
            make.centerY.equalTo(searchButton.snp.centerY)
            make.leading.equalTo(safeAreaLayoutGuide).offset(20)
            make.trailing.equalTo(searchButton.snp.leading).offset(-20)
        }
        
        underBarView.snp.makeConstraints { make in
            make.height.equalTo(4)
            make.leading.equalTo(safeAreaLayoutGuide).offset(20)
            make.trailing.equalTo(searchButton.snp.leading).offset(-20)
            make.bottom.equalTo(searchButton.snp.bottom)
        }
        
        boxOfficeTableView.snp.makeConstraints { make in
            make.top.equalTo(underBarView.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide)
            make.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
}
