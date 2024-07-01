//
//  TMDBVideoViewController.swift
//  CodebasePractice
//
//  Created by Minjae Kim on 7/1/24.
//

import UIKit

final class TMDBVideoViewController: BaseViewController {
    
    private let tmdbVideoView = TMDBVideoView()
    
    private var tmdbVideoList: [TMDBVideo] = []
    
    override func loadView() {
        view = tmdbVideoView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    private func configureTableView() {
        tmdbVideoView.tmdbVideoTableView.delegate = self
        tmdbVideoView.tmdbVideoTableView.dataSource = self
        tmdbVideoView.tmdbVideoTableView.register(TMDBVideoTableViewCell.self, forCellReuseIdentifier: TMDBVideoTableViewCell.identifier)
        tmdbVideoView.tmdbVideoTableView.rowHeight = 120
    }
    
    func configureBackdropImageView(backdropPath: String, posterPath: String, name: String) {
        if let url = ImageURL.tmdbMovie(backdropPath).urlString.stringToURL {
            tmdbVideoView.backdropImageView.configureImageWithKF(url: url)
        }
        if let url = ImageURL.tmdbMovie(posterPath).urlString.stringToURL {
            tmdbVideoView.posterImageView.configureImageWithKF(url: url)
        }
        tmdbVideoView.videoNameLabel.text = name
    }
    
    func requestTMDBTVVideo(id: Int) {
        let api = APIURL.tmdbVideo(id)
        
        NetworkManager.shared.requestAPIWithAlertOnViewController(viewController: self, api: api) { [weak self] (tmdbTrendTVVideo: TMDBTrendTVVideo) in
            guard let self else { return }
            tmdbVideoList = tmdbTrendTVVideo.results
            tmdbVideoView.tmdbVideoTableView.reloadData()
        } failureCompletionHandler: { [weak self] error in
            guard let self else { return }
            presentNetworkErrorAlert(error: error)
        }

    }
}

extension TMDBVideoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        let tmdbVideo = tmdbVideoList[index]
        let tmdbVideoYoutubeViewController = TMDBVideoYoutubeViewController()
        tmdbVideoYoutubeViewController.requestWebView(key: tmdbVideo.key)
        navigationController?.pushViewController(tmdbVideoYoutubeViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tmdbVideoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TMDBVideoTableViewCell.identifier, for: indexPath) as? TMDBVideoTableViewCell else { return UITableViewCell() }
        let index = indexPath.row
        let tmdbVideo = tmdbVideoList[index]
        cell.configureContent(key: tmdbVideo.key, type: tmdbVideo.type, name: tmdbVideo.name)
        return cell
    }
}
