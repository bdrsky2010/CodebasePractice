//
//  MovieTrendDetailViewController.swift
//  CodebasePractice
//
//  Created by Minjae Kim on 6/10/24.
//

import UIKit

import Kingfisher
import SnapKit

final class MovieTrendDetailViewController: UIViewController {
    
    private let backdropImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.backgroundColor = .systemIndigo
        return imageView
    }()
    
    private let backdropImageCoverView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.layer.opacity = 0.2
        return view
    }()
    
    private let movieTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.text = "Squid Game"
        label.textColor = .white
        return label
    }()
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .pastelGreen
        return imageView
    }()
    
    private let tmdbMovieInfoTableView = UITableView()
    
    private var isMore = false
    
    var tmdbMovie: TMDBMovie?
    var castList: [Cast] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigation()
        configureHierarchy()
        configureLayout()
        configureTableView()
    }
    
    func configureNavigation() {
        view.backgroundColor = .systemBackground
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
        let tmdbRecommendViewController = TMDBRecommendViewController()
        tmdbRecommendViewController.tmdbMovie = tmdbMovie
        navigationController?.pushViewController(tmdbRecommendViewController, animated: true)
    }
    
    func configureHierarchy() {
        view.addSubview(backdropImageView)
        view.addSubview(backdropImageCoverView)
        view.addSubview(posterImageView)
        view.addSubview(movieTitleLabel)
        view.addSubview(tmdbMovieInfoTableView)
    }
    
    func configureLayout() {
        backdropImageView.snp.makeConstraints { make in
            make.horizontalEdges.top.equalTo(view.safeAreaLayoutGuide)
            make.height.equalToSuperview().multipliedBy(0.25)
        }
        
        backdropImageCoverView.snp.makeConstraints { make in
            make.horizontalEdges.verticalEdges.equalTo(backdropImageView)
        }
        
        posterImageView.snp.makeConstraints { make in
            make.leading.equalTo(backdropImageCoverView.snp.leading).offset(24)
            make.height.equalTo(backdropImageCoverView.snp.height).multipliedBy(0.6)
            make.width.equalTo(posterImageView.snp.height).multipliedBy(0.7)
            make.bottom.equalTo(backdropImageCoverView.snp.bottom).offset(-12)
        }
        
        movieTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(posterImageView.snp.leading)
            make.bottom.equalTo(posterImageView.snp.top).offset(-8)
        }
        
        tmdbMovieInfoTableView.snp.makeConstraints { make in
            make.top.equalTo(backdropImageCoverView.snp.bottom)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func configureTableView() {
        tmdbMovieInfoTableView.delegate = self
        tmdbMovieInfoTableView.dataSource = self
        
        tmdbMovieInfoTableView.register(OverViewTableViewCell.self, forCellReuseIdentifier: OverViewTableViewCell.identifier)
        tmdbMovieInfoTableView.register(CastTableViewCell.self, forCellReuseIdentifier: CastTableViewCell.identifier)
        
        tmdbMovieInfoTableView.allowsSelection = false
        tmdbMovieInfoTableView.rowHeight = UITableView.automaticDimension
    }
    
    func configureContent(backdropImageUrl: URL?, posterImageUrl: URL?, movieTitle: String) {
        
        if let backdropImageUrl { backdropImageView.configureImageWithKF(url: backdropImageUrl) }
        if let posterImageUrl { posterImageView.configureImageWithKF(url: posterImageUrl) }
        movieTitleLabel.text = movieTitle
    }
}

extension MovieTrendDetailViewController: UITableViewDelegate, MediaDelegate {
    
    func reloadOverViewCell() {
        isMore.toggle()
        tmdbMovieInfoTableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
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
            return cell
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CastTableViewCell.identifier, for: indexPath) as? CastTableViewCell else { return UITableViewCell() }
        let cast = castList[index]
        cell.configureContent(cast)
        
        return cell
    }
}
