//
//  UIImageView+.swift
//  CodebasePractice
//
//  Created by Minjae Kim on 6/10/24.
//

import UIKit

import Kingfisher

extension UIImageView {
    func configureImageWithKF(url: URL) {
        self.kf.indicatorType = .activity
        self.kf.setImage(
            with: url,
            options: [.cacheOriginalImage])
    }
}
