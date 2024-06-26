//
//  MovieSearchView.swift
//  CodebasePractice
//
//  Created by Minjae Kim on 6/26/24.
//

import UIKit

import SnapKit

final class MovieSearchView: BaseView {
    
    let backButton: UIButton = {
        let button = UIButton()
        button.configuration = .blackBackButton()
        return button
    }()
    
    private let searchView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemGray6.cgColor
        view.layer.cornerRadius = 25
        
        view.layer.shadowColor = UIColor.systemGray.cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowRadius = 4
        view.layer.shadowOffset = .init(width: 1, height: 1)
        return view
    }()
    
    let searchTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.textAlignment = .center
        textField.attributedPlaceholder = NSAttributedString(string: "영화를 검색해보세요", attributes: [NSAttributedString.Key.foregroundColor: UIColor.label])
        return textField
    }()
    
    lazy var movieCollectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
    
    func collectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            let width = windowScene.screen.bounds.width - 60
            layout.itemSize = CGSize(width: width / 2, height: width / 1.5)
            layout.scrollDirection = .vertical
            layout.minimumLineSpacing = 10
            layout.minimumInteritemSpacing = 10
            layout.sectionInset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        }
        return layout
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func configureView() {
        super.configureView()
    }
    
    override func configureHierarchy() {
        addSubview(backButton)
        addSubview(searchView)
        searchView.addSubview(searchTextField)
        
        addSubview(movieCollectionView)
    }
    
    override func configureLayout() {
        
        backButton.snp.makeConstraints { make in
            make.leading.equalTo(safeAreaLayoutGuide).offset(20)
            make.width.equalTo(20)
            make.centerY.equalTo(searchView.snp.centerY)
        }
        
        searchView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(8)
            make.leading.equalTo(backButton.snp.trailing).offset(20)
            make.trailing.equalTo(safeAreaLayoutGuide).offset(-20)
            make.height.equalTo(50)
        }
        
        searchTextField.snp.makeConstraints { make in
            make.centerY.equalTo(searchView.snp.centerY)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        movieCollectionView.snp.makeConstraints { make in
            make.top.equalTo(searchView.snp.bottom).offset(20)
            make.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
}
