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

fileprivate enum TMDBTrendOption {
    case movie
    case tv
}

final class MediaViewController: BaseViewController {

    private let movieTrendTableView = UITableView()
    
    private var tmdbTrendMovieList: [TMDBMovie] = [] {
        didSet {
            tmdbTrendMovieList.forEach { tmdbMovie in
                requestTMDBMovieGenreAPI(option: tmdbTrendOption)
                requestTMDBMovieCreditAPI(option: tmdbTrendOption, id: tmdbMovie.id)
            }
        }
    }
    private var tmdbTrendTVList: [TMDBTV] = [] {
        didSet {
            tmdbTrendTVList.forEach { tmdbTV in
                requestTMDBMovieGenreAPI(option: tmdbTrendOption)
                requestTMDBMovieCreditAPI(option: tmdbTrendOption, id: tmdbTV.id)
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
    private var tmdbTrendOption: TMDBTrendOption = .movie
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestTMDBMovieTrendAPI(option: tmdbTrendOption, timeWindow: .week)
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.tintColor = .systemBlue
    }
    
    override func configureView() {
        super.configureView()
        configureNavigation()
    }

    func configureNavigation() {
        let rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"),
                                                style: .plain,
                                                target: self,
                                                action: #selector(rightBarButtonClicked))
        
        let firstLeftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "list.triangle"),
                                                     style: .plain,
                                                     target: self,
                                                     action: #selector(firstLeftBarButtonClicked))
        
        let menuActionList = configureMenuAction()
        let menu = UIMenu(title: "Select Movie OR TVShow\n(default: Movie)", children: menuActionList)
        let secondLeftBarButtonItem = UIBarButtonItem(title: "Category", menu: menu)
        
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
        
        let movieAction = UIAction(title: "Movie", handler: { [weak self] _ in
            guard let self else { return }
            tmdbTrendOption = .movie
            requestTMDBMovieTrendAPI(option: tmdbTrendOption, timeWindow: .week)
        })
        let tvShowAction = UIAction(title: "TVShow", handler: { [weak self] _ in
            guard let self else { return }
            tmdbTrendOption = .tv
            requestTMDBMovieTrendAPI(option: tmdbTrendOption, timeWindow: .week)
        })
        
        let menuActionList = [movieAction, tvShowAction]
        
        return menuActionList
    }
    
    override func configureHierarchy() {
        view.addSubview(movieTrendTableView)
    }
    
    override func configureLayout() {
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
        
        switch tmdbTrendOption {
        case .movie:
            
            let tmdbMovie = tmdbTrendMovieList[index]
            let castList = tmdbMovieCreditCastList[tmdbMovie.id] ?? []
            movieTrendDetailViewController.tmdbMovie = tmdbMovie
            movieTrendDetailViewController.castList = castList
            
            let backdropImageUrl = ImageURL.tmdbMovie(tmdbMovie.backdrop_path).urlString.stringToURL
            let posterImageUrl = ImageURL.tmdbMovie(tmdbMovie.poster_path).urlString.stringToURL
            let movieTitle = tmdbMovie.title
            
            movieTrendDetailViewController.configureContent(backdropImageUrl: backdropImageUrl,
                                                            posterImageUrl: posterImageUrl, movieTitle: movieTitle)
            
        case .tv:
            
            let tmdbTV = tmdbTrendTVList[index]
            let castList = tmdbMovieCreditCastList[tmdbTV.id] ?? []
            movieTrendDetailViewController.tmdbTV = tmdbTV
            movieTrendDetailViewController.castList = castList
            
            let backdropImageUrl = ImageURL.tmdbMovie(tmdbTV.backdrop_path).urlString.stringToURL
            let posterImageUrl = ImageURL.tmdbMovie(tmdbTV.poster_path).urlString.stringToURL
            let tvName = tmdbTV.name
            
            movieTrendDetailViewController.configureContent(backdropImageUrl: backdropImageUrl,
                                                            posterImageUrl: posterImageUrl, movieTitle: tvName)
            
        }
        
        navigationController?.pushViewController(movieTrendDetailViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? MovieTrendTableViewCell else { return }
        cell.cancelDownloadImageWithKF()
    }
}

extension MediaViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tmdbTrendOption == .movie ? tmdbTrendMovieList.count : tmdbTrendTVList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieTrendTableViewCell.identifier, for: indexPath) as? MovieTrendTableViewCell else {
            
            return UITableViewCell()
        }
        
        let index = indexPath.row
        
        switch tmdbTrendOption {
        case .movie:
            let tmdbMovie = tmdbTrendMovieList[index]
            
            let releaseDate = tmdbMovie.release_date
            let genre = tmdbMovie.genre_ids.map { "#\(tmdbMovieGenreList[$0] ?? "")" }.joined(separator: " ")
            let imageUrl = ImageURL.tmdbMovie(tmdbMovie.backdrop_path).urlString.stringToURL
            let voteAverage = roundTwo(num: tmdbMovie.vote_average)
            let movieTitle = tmdbMovie.title
            let cast = (tmdbMovieCreditCastList[tmdbMovie.id] ?? []).map { $0.name }.joined(separator: ", ")
            cell.configureContent(releaseDate: releaseDate, genre: genre, imageUrl: imageUrl, voteAverage: voteAverage, movieTitle: movieTitle, cast: cast)
            
        case .tv:
            let tmdbTV = tmdbTrendTVList[index]
            
            let releaseDate = tmdbTV.first_air_date
            let genre = tmdbTV.genre_ids.map { "#\(tmdbMovieGenreList[$0] ?? "")" }.joined(separator: " ")
            let imageUrl = ImageURL.tmdbMovie(tmdbTV.backdrop_path).urlString.stringToURL
            let voteAverage = roundTwo(num: tmdbTV.vote_average)
            let movieTitle = tmdbTV.name
            let cast = (tmdbMovieCreditCastList[tmdbTV.id] ?? []).map { $0.name }.joined(separator: ", ")
            
            cell.configureContent(releaseDate: releaseDate, genre: genre, imageUrl: imageUrl, voteAverage: voteAverage, movieTitle: movieTitle, cast: cast)
        }
        
        return cell
    }
    
    private func roundTwo(num: Double) -> Double {
        let digit: Double = 10.0
        return round(num * digit) / digit
    }
}

extension MediaViewController {
    
    private func requestTMDBMovieTrendAPI(option tmdbTrendOption: TMDBTrendOption, timeWindow: TimeWindowType) {
        let api = tmdbTrendOption == .movie ? APIURL.tmdbMovie(TimeWindowType.week.string) : APIURL.tmdbTV(TimeWindowType.week.string)
        
        switch tmdbTrendOption {
        case .movie:
            NetworkManager.shared.requestAPIWithAlertOnViewController(viewController: self, api: api) { [weak self] (movieTrend: TMDBMovieTrend) in
                guard let self else { return }
                tmdbTrendMovieList = movieTrend.results
            }
        case .tv:
            NetworkManager.shared.requestAPIWithAlertOnViewController(viewController: self, api: api) { [weak self] (tvTrend: TMDBTVTrend) in
                guard let self else { return }
                tmdbTrendTVList = tvTrend.results
            }
        }
    }
    
    private func requestTMDBMovieGenreAPI(option tmdbTrendOption: TMDBTrendOption) {
        let api = tmdbTrendOption == .movie ? APIURL.tmdbMovieGenre : APIURL.tmdbTVGenre
        
        NetworkManager.shared.requestAPIWithAlertOnViewController(viewController: self, api: api) { [weak self] (movieGenre: TMDBMovieGenre) in
            movieGenre.genres.forEach { [weak self] genre in
                guard let self else { return }
                tmdbMovieGenreList[genre.id] = genre.name
            }
        }
    }
    
    private func requestTMDBMovieCreditAPI(option tmdbTrendOption: TMDBTrendOption, id: Int) {
        let api = tmdbTrendOption == .movie ? APIURL.tmdbMovieCredit(id) : APIURL.tmdbTVCredit(id)
        
        NetworkManager.shared.requestAPIWithAlertOnViewController(viewController: self, api: api) { [weak self] (movieCredit: TMDBMovieCredit) in
            guard let self else { return }
            tmdbMovieCreditCastList[id] = movieCredit.cast
            movieTrendTableView.reloadData()
        }
    }
}
