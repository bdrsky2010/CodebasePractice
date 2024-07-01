//
//  TMDBVideoYoutubeViewController.swift
//  CodebasePractice
//
//  Created by Minjae Kim on 7/1/24.
//

import UIKit

final class TMDBVideoYoutubeViewController: BaseViewController {
    
    private let tmdbVideoYoutubeView = TMDBVideoYoutubeView()
    
    override func loadView() {
        view = tmdbVideoYoutubeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigation()
    }
    
    private  func configureNavigation() {
        let leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"),
                                                     style: .plain,
                                                     target: self,
                                                     action: #selector(leftBarButtonClicked))
        navigationItem.leftBarButtonItem = leftBarButtonItem
        navigationController?.navigationBar.tintColor = UIColor.label
    }
    
    @objc
    private func leftBarButtonClicked() {
        navigationController?.popViewController(animated: true)
    }
    
    func requestWebView(key: String) {
        guard let url = WebURL.youtube(key).urlString.stringToURL else { return }
        let request = URLRequest(url: url)
        tmdbVideoYoutubeView.youtubeWebView.load(request)
    }
}
