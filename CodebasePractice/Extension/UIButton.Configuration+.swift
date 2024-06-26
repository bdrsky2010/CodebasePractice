//
//  UIButton.Configuration+.swift
//  CodebasePractice
//
//  Created by Minjae Kim on 6/26/24.
//

import UIKit

extension UIButton.Configuration {
    static func blackBackButton() -> UIButton.Configuration {
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(systemName: "chevron.backward")
        configuration.baseForegroundColor = .label
        return configuration
    }
}
