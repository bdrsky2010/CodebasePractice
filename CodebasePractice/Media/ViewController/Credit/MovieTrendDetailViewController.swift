//
//  MovieTrendDetailViewController.swift
//  CodebasePractice
//
//  Created by Minjae Kim on 6/10/24.
//

import UIKit

import Kingfisher
import SnapKit

final class MovieTrendDetailViewController: BaseViewController {
    
    private let movieTrendDetailView = MovieTrendDetailView()
    
    private var isMore = false
    
    var tmdbMovie: TMDBMovie?
    var tmdbTV: TMDBTV?
    var castList: [Cast] = []
    
    override func loadView() {
        view = movieTrendDetailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
    }
    
    override func configureView() {
        configureNavigation()
    }
    
    func configureNavigation() {
        navigationController?.navigationBar.tintColor = .label
        navigationItem.title = "출연/제작"
        
        let leftBarButtonItem = UIBarButtonItem( image: UIImage(systemName: "chevron.backward"),
                                                 style: .plain,
                                                 target: self,
                                                 action: #selector(dismissButtonClicked))
        
        let rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "movieclapper"),
                                                 style: .plain,
                                                 target: self,
                                                 action: #selector(rightButtonClicked))
        
        navigationItem.leftBarButtonItem = leftBarButtonItem
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    @objc
    private func dismissButtonClicked() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func rightButtonClicked() {
        if let tmdbMovie {
            let tmdbRecommendViewController = TMDBRecommendViewController()
            tmdbRecommendViewController.tmdbMovie = tmdbMovie
            navigationController?.pushViewController(tmdbRecommendViewController, animated: true)
        }
        if let tmdbTV {
            let tmdbVideoViewController = TMDBVideoViewController()
            tmdbVideoViewController.configureBackdropImageView(backdropPath: tmdbTV.backdrop_path, posterPath: tmdbTV.poster_path, name: tmdbTV.name)
            tmdbVideoViewController.requestTMDBTVVideo(id: tmdbTV.id)
            let navigationController = UINavigationController(rootViewController: tmdbVideoViewController)
            present(navigationController, animated: true)
        }
    }
    
    private func configureTableView() {
        movieTrendDetailView.tmdbMovieInfoTableView.delegate = self
        movieTrendDetailView.tmdbMovieInfoTableView.dataSource = self
        
        movieTrendDetailView.tmdbMovieInfoTableView.register(OverViewTableViewCell.self, forCellReuseIdentifier: OverViewTableViewCell.identifier)
        movieTrendDetailView.tmdbMovieInfoTableView.register(CastTableViewCell.self, forCellReuseIdentifier: CastTableViewCell.identifier)
        
        movieTrendDetailView.tmdbMovieInfoTableView.allowsSelection = false
        movieTrendDetailView.tmdbMovieInfoTableView.rowHeight = UITableView.automaticDimension
    }
    
    func configureContent(backdropImageUrl: URL?, posterImageUrl: URL?, movieTitle: String) {
        
        if let backdropImageUrl { movieTrendDetailView.backdropImageView.configureImageWithKF(url: backdropImageUrl) }
        if let posterImageUrl { movieTrendDetailView.posterImageView.configureImageWithKF(url: posterImageUrl) }
        movieTrendDetailView.movieTitleLabel.text = movieTitle
    }
}

extension MovieTrendDetailViewController: UITableViewDelegate, MediaDelegate {
    
    func reloadOverViewCell() {
        isMore.toggle()
        movieTrendDetailView.tmdbMovieInfoTableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
    }
}

extension MovieTrendDetailViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "OverView" : "Cast"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : castList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let index = indexPath.row
        
        if section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: OverViewTableViewCell.identifier, for: indexPath) as? OverViewTableViewCell else { return UITableViewCell() }
            cell.mediaDelegate = self
            cell.configureCell(isMore: isMore)
            
            if let overView = tmdbMovie?.overview {
                cell.configureContent(overView: overView)
            }
            if let overView = tmdbTV?.overview {
                cell.configureContent(overView: overView)
            }
            return cell
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CastTableViewCell.identifier, for: indexPath) as? CastTableViewCell else { return UITableViewCell() }
        let cast = castList[index]
        cell.configureContent(cast)
        
        return cell
    }
}
