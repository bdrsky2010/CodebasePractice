//
//  MediaViewController.swift
//  CodebasePractice
//
//  Created by Minjae Kim on 6/10/24.
//

import UIKit

import Alamofire
import Kingfisher
import SnapKit

class MediaViewController: UIViewController, ConfigureViewProtocol {

    private let movieTrendTableView = UITableView()
    
    private var tmdbTrendMovieList: [TMDBMovie] = [] {
        didSet {
            tmdbTrendMovieList.forEach { tmdbMovie in
                requestTMDBMovieCreditAPI(tmdbMovie.id)
            }
        }
    }
    private var tmdbMovieCreditCastList: [Int: [Cast]] = [:]
    private var tmdbMovieGenreList: [Int: String] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestTMDBMovieTrendAPI(timeWindow: .week)
        requestTMDBMovieGenreAPI()
        
        configureNavigation()
        configureHierarchy()
        configureLayout()
        configureTableView()
    }

    func configureNavigation() {
        
        navigationController?.navigationBar.tintColor = .systemBlue
        
        view.backgroundColor = .systemBackground
        
        let menu = UIMenu(title: "Select Time Window Type", children: [
            UIAction(title: "Day", handler: { [weak self] _ in
                guard let self else { return }
                navigationItem.leftBarButtonItem?.title = "Day"
                requestTMDBMovieTrendAPI(timeWindow: .day)
            }),
            UIAction(title: "Week", handler: { [weak self] _ in
                guard let self else { return }
                navigationItem.leftBarButtonItem?.title = "Week"
                requestTMDBMovieTrendAPI(timeWindow: .week)
            })
        ])
        let leftBarButtonItem = UIBarButtonItem(title: "Week", menu: menu)
        let rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"),
                                                style: .plain,
                                                target: self,
                                                action: #selector(rightBarButtonClicked))
        navigationItem.leftBarButtonItem = leftBarButtonItem
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    @objc
    private func rightBarButtonClicked() {
        print(#function)
    }
    
    func configureHierarchy() {
        view.addSubview(movieTrendTableView)
    }
    
    func configureLayout() {
        movieTrendTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func configureTableView() {
        movieTrendTableView.delegate = self
        movieTrendTableView.dataSource = self
        
        movieTrendTableView.register(MovieTrendTableViewCell.self,
                                     forCellReuseIdentifier: MovieTrendTableViewCell.identifier)
        
        movieTrendTableView.rowHeight = UITableView.automaticDimension
        movieTrendTableView.separatorStyle = .none
    }
}

extension MediaViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}

extension MediaViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tmdbTrendMovieList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieTrendTableViewCell.identifier, for: indexPath) as? MovieTrendTableViewCell else {
            print("aaa")
            return UITableViewCell()
        }
        
        let index = indexPath.row
        let tmdbMovie = tmdbTrendMovieList[index]
        
        let releaseDate = tmdbMovie.release_date
        let genre = tmdbMovie.genre_ids.map { "#\(tmdbMovieGenreList[$0] ?? "")" }.joined(separator: " ")
        let imageUrl = ImageURL.tmdbMovie(tmdbMovie.poster_path).urlString.stringToURL
        let voteAverage = roundTwo(num: tmdbMovie.vote_average)
        let movieTitle = tmdbMovie.title
        let cast = (tmdbMovieCreditCastList[tmdbMovie.id] ?? []).map { $0.name }.joined(separator: ", ")
        
        
        cell.configureContent(releaseDate: releaseDate, genre: genre, imageUrl: imageUrl, voteAverage: voteAverage, movieTitle: movieTitle, cast: cast)
        
        return cell
    }
    
    private func roundTwo(num: Double) -> Double {
        let digit: Double = 10.0
        return round(num * digit) / digit
    }
}

extension MediaViewController: RequestAPIFromAFProtocol {
    
    private func requestTMDBMovieTrendAPI(timeWindow: TimeWindowType) {
        
        let urlString = APIURL.tmdbMovie(timeWindow.string).urlString
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
            tmdbTrendMovieList = value.results
            movieTrendTableView.reloadData()
        } failClosure: { error in
            print(error)
        }
    }
    
    private func requestTMDBMovieGenreAPI() {
        
        let urlString = APIURL.tmdbMovieGenre(APIKey.tmdbAPIKey).urlString
        
        requestDecodableCustomTypeResult(urlString: urlString,
                                         encoding: URLEncoding.queryString,
                                         type: TMDBMovieGenre.self
        ) { value in
            value.genres.forEach { [weak self] genre in
                guard let self else { return }
                tmdbMovieGenreList[genre.id] = genre.name
            }
        } failClosure: { error in
            print(error)
        }
    }
    
    private func requestTMDBMovieCreditAPI(_ id: Int) {
        
        let urlString = APIURL.tmdbMovieCredit(id).urlString
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
                                         type: TMDBMovieCredit.self
        ) { [weak self] value in
            guard let self else { return }
            tmdbMovieCreditCastList[id] = value.cast
        } failClosure: { error in
            print(error)
        }
    }
}
