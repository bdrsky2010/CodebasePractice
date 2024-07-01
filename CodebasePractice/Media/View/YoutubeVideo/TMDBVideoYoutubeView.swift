//
//  TMDBVideoYoutubeView.swift
//  CodebasePractice
//
//  Created by Minjae Kim on 7/1/24.
//

import UIKit
import WebKit

import SnapKit

final class TMDBVideoYoutubeView: BaseView {
    
    let youtubeWebView = WKWebView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func configureView() {
        backgroundColor = .white
    }
    
    override func configureHierarchy() {
        addSubview(youtubeWebView)
    }
    
    override func configureLayout() {
        youtubeWebView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
    }
}
