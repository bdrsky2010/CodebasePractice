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
                requestTMDBMovieGenreAPI()
                requestTMDBMovieCreditAPI(tmdbMovie.id)
            }
        }
    }
    private var tmdbMovieCreditCastList: [Int: [Cast]] = [:] {
        didSet {
            movieTrendTableView.reloadData()
            movieTrendTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }
    }
    private var tmdbMovieGenreList: [Int: String] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestTMDBMovieTrendAPI(timeWindow: .week)
        
        configureNavigation()
        configureHierarchy()
        configureLayout()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.tintColor = .systemBlue
    }

    func configureNavigation() {
        view.backgroundColor = .systemBackground
        
        let rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"),
                                                style: .plain,
                                                target: self,
                                                action: #selector(rightBarButtonClicked))
        
        let firstLeftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "list.triangle"),
                                                     style: .plain,
                                                     target: self,
                                                     action: #selector(firstLeftBarButtonClicked))
        
        let menuActionList = configureMenuAction()
        let menu = UIMenu(title: "Select Time Window Type\n(default: week)", children: menuActionList)
        let secondLeftBarButtonItem = UIBarButtonItem(title: "sort", menu: menu)
        
        navigationItem.leftBarButtonItems = [firstLeftBarButtonItem, secondLeftBarButtonItem]
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    @objc
    private func firstLeftBarButtonClicked() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func rightBarButtonClicked() {
        let movieSearchViewController = MovieSearchViewController()
        navigationController?.pushViewController(movieSearchViewController, animated: true)
    }
    
    private func configureMenuAction() -> [UIMenuElement] {
        
        let dayAction = UIAction(title: "Day", handler: { [weak self] _ in
            guard let self else { return }
            navigationItem.leftBarButtonItem?.title = "Day"
            requestTMDBMovieTrendAPI(timeWindow: .day)
        })
        let weekAction = UIAction(title: "Week", handler: { [weak self] _ in
            guard let self else { return }
            navigationItem.leftBarButtonItem?.title = "Week"
            requestTMDBMovieTrendAPI(timeWindow: .week)
        })
        
        let menuActionList = [dayAction, weekAction]
        
        return menuActionList
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
        
        let movieTrendDetailViewController = MovieTrendDetailViewController()
        let index = indexPath.row
        let tmdbMovie = tmdbTrendMovieList[index]
        let castList = tmdbMovieCreditCastList[tmdbMovie.id] ?? []
        movieTrendDetailViewController.tmdbMovie = tmdbMovie
        movieTrendDetailViewController.castList = castList
        
        let backdropImageUrl = ImageURL.tmdbMovie(tmdbMovie.backdrop_path).urlString.stringToURL
        let posterImageUrl = ImageURL.tmdbMovie(tmdbMovie.poster_path).urlString.stringToURL
        let movieTitle = tmdbMovie.title
        
        movieTrendDetailViewController.configureContent(backdropImageUrl: backdropImageUrl,
                                                        posterImageUrl: posterImageUrl, movieTitle: movieTitle)
        
        navigationController?.pushViewController(movieTrendDetailViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? MovieTrendTableViewCell else { return }
        cell.cancelDownloadImageWithKF()
    }
}

extension MediaViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tmdbTrendMovieList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieTrendTableViewCell.identifier, for: indexPath) as? MovieTrendTableViewCell else {
            
            return UITableViewCell()
        }
        
        let index = indexPath.row
        let tmdbMovie = tmdbTrendMovieList[index]
        
        let releaseDate = tmdbMovie.release_date
        let genre = tmdbMovie.genre_ids.map { "#\(tmdbMovieGenreList[$0] ?? "")" }.joined(separator: " ")
        let imageUrl = ImageURL.tmdbMovie(tmdbMovie.backdrop_path).urlString.stringToURL
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

extension MediaViewController {
    
    private func requestTMDBMovieTrendAPI(timeWindow: TimeWindowType) {
        let api = APIURL.tmdbMovie(timeWindow.string)
        
        NetworkManager.shared.requestAPI(urlString: api.endpoint,
                                         method: .get,
                                         parameters: api.parameters,
                                         encoding: URLEncoding.queryString,
                                         headers: api.headers,
                                         of: TMDBMovieTrend.self) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let value):
                tmdbTrendMovieList = value.results
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func requestTMDBMovieGenreAPI() {
        
        let api = APIURL.tmdbMovieGenre(APIKey.tmdb)
        
        NetworkManager.shared.requestAPI(urlString: api.endpoint,
                                         method: .get,
                                         parameters: api.parameters,
                                         encoding: URLEncoding.queryString,
                                         headers: api.headers,
                                         of: TMDBMovieGenre.self) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let value):
                value.genres.forEach { [weak self] genre in
                    guard let self else { return }
                    tmdbMovieGenreList[genre.id] = genre.name
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func requestTMDBMovieCreditAPI(_ id: Int) {
        let api = APIURL.tmdbMovieCredit(id)
        
        NetworkManager.shared.requestAPI(urlString: api.endpoint,
                                         method: .get,
                                         parameters: api.parameters,
                                         encoding: URLEncoding.queryString,
                                         headers: api.headers,
                                         of: TMDBMovieCredit.self) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let value):
                tmdbMovieCreditCastList[id] = value.cast
                movieTrendTableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
}