//
//  TMDBRecommendViewController.swift
//  CodebasePractice
//
//  Created by Minjae Kim on 6/24/24.
//

import UIKit

import SnapKit
import Alamofire

final class TMDBRecommendViewController: UIViewController, ConfigureViewProtocol {
    
    private let movieTableView = UITableView()
    private let headers = ["비슷한 영화", "추천 영화", "포스터"]
    
    private var movieList: [[Decodable]] = Array(repeating: [], count: 3)
    
    var tmdbMovie: TMDBMovie?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        
        requestAPI()
        configureTableView()
    }
    
    func configureView() {
        view.backgroundColor = .systemBackground
        configureNavigation()
        configureHierarchy()
        configureLayout()
    }
    
    func configureNavigation() {
        navigationItem.title = tmdbMovie?.title
        
        let leftBarButtonItem = UIBarButtonItem( image: UIImage(systemName: "chevron.backward"),
                                                 style: .plain,
                                                 target: self,
                                                 action: #selector(dismissButtonClicked))
        
        navigationItem.leftBarButtonItem = leftBarButtonItem
    }
    
    @objc
    private func dismissButtonClicked() {
        navigationController?.popViewController(animated: true)
    }
    
    func configureHierarchy() {
        view.addSubview(movieTableView)
    }
    
    func configureLayout() {
        movieTableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func configureTableView() {
        movieTableView.delegate = self
        movieTableView.dataSource = self
        movieTableView.register(RecommendMovieTableViewCell.self,
                                forCellReuseIdentifier: RecommendMovieTableViewCell.identifier)
        movieTableView.separatorStyle = .none
    }
}

extension TMDBRecommendViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return headers.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView()
        view.backgroundColor = .systemBackground
        let label = UILabel()
        label.text = headers[section]
        label.font = UIFont.boldSystemFont(ofSize: 18)
        
        view.addSubview(label)
        
        label.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let totalWidth: CGFloat = tableView.bounds.width
        
        if indexPath.section == 2 {
            let width: CGFloat = totalWidth / 2 - 30
            return width * 1.5
        } else {
            let width: CGFloat = totalWidth / 3 - 20
            return width * 1.5
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RecommendMovieTableViewCell.identifier, for: indexPath) as? RecommendMovieTableViewCell else { return UITableViewCell() }
        print(indexPath.section)
        cell.collectionView.delegate = self
        cell.collectionView.dataSource = self
        cell.collectionView.register(RecommendMovieCollectionViewCell.self,
                                forCellWithReuseIdentifier: RecommendMovieCollectionViewCell.identifier)
        cell.collectionView.tag = indexPath.section
        cell.collectionView.reloadData()
        return cell
    }
}

extension TMDBRecommendViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("collectionView", movieList[collectionView.tag].count)
        return movieList[collectionView.tag].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendMovieCollectionViewCell.identifier, for: indexPath) as? RecommendMovieCollectionViewCell else { return UICollectionViewCell() }
        
        var imagePath = ""
        let index = collectionView.tag
        
        if let tmdbMovieList = movieList[index] as? [TMDBMovie] {
            imagePath = tmdbMovieList[indexPath.row].poster_path
        } else if let posterPathList = movieList[index] as? [String] {
            imagePath = posterPathList[indexPath.row]
        }
        
        cell.configureContent(imagePath: imagePath)
        
        return cell
    }
    
    
}

extension TMDBRecommendViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalWidth = collectionView.bounds.width
        
        if collectionView.tag == 0 || collectionView.tag == 1 {
            let width = totalWidth / 3 - 20
            return CGSize(width: width, height: width * 1.5)
        } else {
            let width = totalWidth / 2 - 30
            return CGSize(width: width, height: width * 1.5)
        }
    }
}

extension TMDBRecommendViewController {
    
    private func requestAPI() {
        guard let tmdbMovie else { return }
        
        let group = DispatchGroup()
        
        group.enter()
        DispatchQueue.global().async {
            let api = APIURL.tmdbMovieSimiliar(tmdbMovie.id)
            NetworkManager.shared.requestAPI(urlString: api.endpoint,
                                             method: .get,
                                             parameters: api.parameters,
                                             encoding: URLEncoding.queryString,
                                             headers: api.headers,
                                             of: TMDBMovieTrend.self) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let value):
                    movieList[0] = value.results
                    group.leave()
                case .failure(let error):
                    print(error)
                    DispatchQueue.main.async { [weak self] in
                        guard let self else { return }
                        presentAlert(option: .oneButton,
                                     title: "네트워크 통신 에러",
                                     message: "비슷한 영화 리스트를 가져오는데 실패하였습니다",
                                     checkAlertTitle: "확인")
                    }
                }
            }
        }
        
        group.enter()
        DispatchQueue.global().async {
            let api = APIURL.tmdbMovieRecommendations(tmdbMovie.id)
            NetworkManager.shared.requestAPI(urlString: api.endpoint,
                                             method: .get,
                                             parameters: api.parameters,
                                             encoding: URLEncoding.queryString,
                                             headers: api.headers,
                                             of: TMDBMovieTrend.self) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let value):
                    movieList[1] = value.results
                    group.leave()
                case .failure(let error):
                    print(error)
                    DispatchQueue.main.async { [weak self] in
                        guard let self else { return }
                        presentAlert(option: .oneButton,
                                     title: "네트워크 통신 에러",
                                     message: "추천 영화 리스트를 가져오는데 실패하였습니다",
                                     checkAlertTitle: "확인")
                    }
                }
            }
        }
        
        group.enter()
        DispatchQueue.global().async {
            let api = APIURL.tmdbMovieImages(tmdbMovie.id)
            NetworkManager.shared.requestAPI(urlString: api.endpoint,
                                             method: .get,
                                             parameters: api.parameters,
                                             encoding: URLEncoding.queryString,
                                             headers: api.headers,
                                             of: TMDBMoviePoster.self) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let value):
                    movieList[2] = value.backdrops.map { $0.filePath }
                    group.leave()
                case .failure(let error):
                    print(error)
                    DispatchQueue.main.async { [weak self] in
                        guard let self else { return }
                        presentAlert(option: .oneButton,
                                     title: "네트워크 통신 에러",
                                     message: "영화 포스터를 가져오는데 실패하였습니다",
                                     checkAlertTitle: "확인")
                    }
                }
            }
        }
        
        group.notify(queue: DispatchQueue.main) { [weak self] in
            guard let self else { return }
            movieTableView.reloadData()
        }
    }
}
