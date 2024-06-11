//
//  MovieSearchViewController.swift
//  CodebasePractice
//
//  Created by Minjae Kim on 6/11/24.
//

import UIKit

import Alamofire
import Kingfisher
import SnapKit

class MovieSearchViewController: UIViewController, ConfigureViewProtocol {

    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.configuration = buttonConfiguration
        button.addTarget(self, action: #selector(backButtonClicked), for: .touchUpInside)
        return button
    }()
    
    let buttonConfiguration: UIButton.Configuration = {
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(systemName: "chevron.backward")
        configuration.baseForegroundColor = .label
        return configuration
    }()
    
    @objc
    private func backButtonClicked() {
        navigationController?.popViewController(animated: true)
    }
    
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
    
    private let searchTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.textAlignment = .center
        textField.attributedPlaceholder = NSAttributedString(string: "영화를 검색해보세요", attributes: [NSAttributedString.Key.foregroundColor: UIColor.label])
        return textField
    }()
    
    private lazy var movieCollectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
    
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
    
    private var page = 1
    private var originQuery = ""
    private var isEnd = false
    
    private var tmdbMovieSearch: TMDBMovieSearch = TMDBMovieSearch(page: 0, results: [], total_pages: 0, total_results: 0) {
        didSet {
            movieCollectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureNavigation()
        configureHierarchy()
        configureLayout()
        configureCollectionView()
        configureTextField()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    func configureNavigation() {
        
        navigationController?.navigationBar.tintColor = .label
        
        let leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: nil)
        
        navigationItem.leftBarButtonItem = leftBarButtonItem
        navigationController?.navigationBar.isHidden = true
    }
    
    private func configureCollectionView() {
        movieCollectionView.delegate = self
        movieCollectionView.dataSource = self
        movieCollectionView.prefetchDataSource = self
        movieCollectionView.register(MovieSearchCollectionViewCell.self,
                                     forCellWithReuseIdentifier: MovieSearchCollectionViewCell.identifier)
    }
    
    func configureHierarchy() {
        view.addSubview(backButton)
        view.addSubview(searchView)
        searchView.addSubview(searchTextField)
        
        view.addSubview(movieCollectionView)
    }
    
    func configureLayout() {
        
        backButton.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.width.equalTo(20)
            make.centerY.equalTo(searchView.snp.centerY)
        }
        
        searchView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(8)
            make.leading.equalTo(backButton.snp.trailing).offset(20)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.height.equalTo(50)
        }
        
        searchTextField.snp.makeConstraints { make in
            make.centerY.equalTo(searchView.snp.centerY)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        movieCollectionView.snp.makeConstraints { make in
            make.top.equalTo(searchView.snp.bottom).offset(20)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func configureTextField() {
        searchTextField.delegate = self
    }
}

extension MovieSearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let query = textField.text, !query.isEmpty, query != originQuery else { return true }
        
        originQuery = query
        page = 1
        isEnd = false
        requestMovieSearchAPI(query, page: page)
        return true
    }
}

extension MovieSearchViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            print(page, indexPath.item, tmdbMovieSearch.results.count)
            if tmdbMovieSearch.results.count - 11 == indexPath.item, !isEnd {
                page += 1
                requestMovieSearchAPI(originQuery, page: page)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            if let cell = collectionView.cellForItem(at: indexPath) as? MovieSearchCollectionViewCell {
                cell.posterImageView.kf.cancelDownloadTask()
            }
        }
    }
}

extension MovieSearchViewController: UICollectionViewDelegate {
    
}

extension MovieSearchViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tmdbMovieSearch.results.count
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieSearchCollectionViewCell.identifier, 
                                                            for: indexPath) as? MovieSearchCollectionViewCell else { return UICollectionViewCell() }
        let movie = tmdbMovieSearch.results[indexPath.row]
        cell.configureContent(movie)
        return cell
    }
}

extension MovieSearchViewController: RequestAPIFromAFProtocol {
    private func requestMovieSearchAPI(_ query: String, page: Int) {
        
        let urlString = APIURL.tmdbMovieSearch.urlString
        let parameters: Parameters = [
            "language": "ko-KR",
            "page": page,
            "query": query
        ]
        let headers: HTTPHeaders = [
            "accept": "application/json",
            "Authorization": APIKey.tmdbAccessToken
        ]
        
        requestDecodableCustomTypeResult(urlString: urlString,
                                         method: .get,
                                         parameters: parameters,
                                         encoding: URLEncoding.queryString,
                                         headers: headers,
                                         type: TMDBMovieSearch.self
        ) { [weak self] value in
            guard let self else { return }
            isEnd = page == value.total_pages
            
            if page > 1 {
                tmdbMovieSearch.results.append(contentsOf: value.results)
            } else {
                tmdbMovieSearch = value
                movieCollectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            }
            
            
        } failClosure: { error in
            print(error)
        }

    }
}
