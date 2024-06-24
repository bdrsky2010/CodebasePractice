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
    
    private var similiarMovieList: [TMDBMovie] = []
    private var recommendationMovieList: [TMDBMovie] = []
    private var tmdbMoviePosterPathList: [String] = []
    
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
        
        if indexPath.section == 0 || indexPath.section == 1 {
            let width: CGFloat = totalWidth / 3 - 20
            return width * 1.5
        } else {
            let width: CGFloat = totalWidth / 2 - 30
            return width * 1.5
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RecommendMovieTableViewCell.identifier, for: indexPath) as? RecommendMovieTableViewCell else { return UITableViewCell() }
        
        let section = indexPath.section
        if section == 0 {
            cell.data = similiarMovieList
        } else if section == 1 {
            cell.data = recommendationMovieList
        } else {
            cell.data = tmdbMoviePosterPathList
        }
        
        return cell
    }
}

extension TMDBRecommendViewController: RequestAPIFromAFProtocol {
    
    private func requestAPI() {
        guard let tmdbMovie else { return }
        
        var urlString = APIURL.tmdbMovieSimiliar(tmdbMovie.id).urlString
        let parameters: Parameters = [
            "language": "ko-KR"
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
                                         type: TMDBMovieTrend.self
        ) { [weak self] value in
            guard let self else { return }
            similiarMovieList = value.results
            movieTableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        } failClosure: { [weak self] _ in
            guard let self else { return }
            presentAlert(option: .oneButton,
                         title: "네트워크 통신 에러",
                         message: "추천 영화 리스트를 가져오는데 실패하였습니다",
                         checkAlertTitle: "확인")
        }
        
        urlString = APIURL.tmdbMovieRecommendations(tmdbMovie.id).urlString
        requestDecodableCustomTypeResult(urlString: urlString,
                                         method: .get,
                                         parameters: parameters,
                                         encoding: URLEncoding.queryString,
                                         headers: headers,
                                         type: TMDBMovieTrend.self
        ) { [weak self] value in
            guard let self else { return }
            recommendationMovieList = value.results
            movieTableView.reloadRows(at: [IndexPath(row: 0, section: 1)], with: .automatic)
        } failClosure: { [weak self] error in
            print(error)
            guard let self else { return }
            presentAlert(option: .oneButton,
                         title: "네트워크 통신 에러",
                         message: "비슷한 영화 리스트를 가져오는데 실패하였습니다",
                         checkAlertTitle: "확인")
        }
        
        urlString = APIURL.tmdbMovieImages(tmdbMovie.id).urlString
        requestDecodableCustomTypeResult(urlString: urlString,
                                         method: .get,
                                         encoding: URLEncoding.queryString,
                                         headers: headers,
                                         type: TMDBMoviePoster.self
        ) { [weak self] value in
            guard let self else { return }
            tmdbMoviePosterPathList = value.backdrops.map { $0.filePath }
            movieTableView.reloadRows(at: [IndexPath(row: 0, section: 2)], with: .automatic)
        } failClosure: { [weak self] error in
            print(error)
            guard let self else { return }
            presentAlert(option: .oneButton,
                         title: "네트워크 통신 에러",
                         message: "영화 포스터를 가져오는데 실패하였습니다",
                         checkAlertTitle: "확인")
        }
    }
}
