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

class MovieSearchViewController: BaseViewController {

    private let movieSearchView = MovieSearchView()
    
    private var page = 1
    private var originQuery = ""
    private var isEnd = false
    private var castList: [Cast] = []
    private var tmdbMovieSearch: TMDBMovieSearch = TMDBMovieSearch(page: 0, results: [], total_pages: 0, total_results: 0) {
        didSet {
            movieSearchView.movieCollectionView.reloadData()
        }
    }
    
    override func loadView() {
        view = movieSearchView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureCollectionView()
        configureTextField()
        configureButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    override func configureView() {
        configureNavigation()
    }
    
    func configureNavigation() {
        navigationController?.navigationBar.isHidden = true
    }
    
    private func configureCollectionView() {
        movieSearchView.movieCollectionView.delegate = self
        movieSearchView.movieCollectionView.dataSource = self
        movieSearchView.movieCollectionView.prefetchDataSource = self
        movieSearchView.movieCollectionView.register(MovieSearchCollectionViewCell.self,
                                     forCellWithReuseIdentifier: MovieSearchCollectionViewCell.identifier)
    }
    
    private func configureTextField() {
        movieSearchView.searchTextField.delegate = self
    }
    
    private func configureButton() {
        movieSearchView.backButton.addTarget(self, action: #selector(backButtonClicked), for: .touchUpInside)
    }
    
    @objc
    private func backButtonClicked() {
        navigationController?.popViewController(animated: true)
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
            if tmdbMovieSearch.results.count - 2 == indexPath.item, !isEnd {
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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.row
        let tmdbMovie = tmdbMovieSearch.results[index]
        requestTMDBMovieCreditAPI(tmdbMovie.id)
        
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            let movieTrendDetailViewController = MovieTrendDetailViewController()
            movieTrendDetailViewController.tmdbMovie = tmdbMovie
            movieTrendDetailViewController.castList = castList
            
            let backdropImageUrl = ImageURL.tmdbMovie(tmdbMovie.backdrop_path).urlString.stringToURL
            let posterImageUrl = ImageURL.tmdbMovie(tmdbMovie.poster_path).urlString.stringToURL
            let movieTitle = tmdbMovie.title
            
            movieTrendDetailViewController.configureContent(backdropImageUrl: backdropImageUrl,
                                                            posterImageUrl: posterImageUrl, movieTitle: movieTitle)
            
            navigationController?.pushViewController(movieTrendDetailViewController, animated: true)
            castList = []
        }
    }
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

extension MovieSearchViewController {
    private func requestMovieSearchAPI(_ query: String, page: Int) {
        let api = APIURL.tmdbMovieSearch(query, page)
        
        NetworkManager.shared.requestAPI(urlString: api.endpoint,
                                         method: .get,
                                         parameters: api.parameters,
                                         encoding: URLEncoding.queryString,
                                         headers: api.headers,
                                         of: TMDBMovieSearch.self) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let value):
                isEnd = page == value.total_pages
                
                if page > 1 {
                    tmdbMovieSearch.results.append(contentsOf: value.results)
                } else {
                    tmdbMovieSearch = value
                    movieSearchView.movieCollectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
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
                castList = value.cast
            case .failure(let error):
                print(error)
            }
        }
    }
}
