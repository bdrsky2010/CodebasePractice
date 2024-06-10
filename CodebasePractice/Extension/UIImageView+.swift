//
//  UIImageView+.swift
//  CodebasePractice
//
//  Created by Minjae Kim on 6/10/24.
//

import UIKit

extension UIImageView {
    func configureImageWithKF(url: URL) {
        self.kf.indicatorType = .activity
        self.kf.setImage(
            with: url,
            options: [.cacheOriginalImage]) { result in
                switch result {
                case .success(let value):
                    print(value.image)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
    }
}
