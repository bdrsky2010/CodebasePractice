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
    
    static func creadteReminderButton() -> UIButton.Configuration {
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(systemName: "plus.circle.fill")
        configuration.imagePlacement = .leading
        configuration.imagePadding = 8
        configuration.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
        configuration.attributedTitle = AttributedString(NSAttributedString(string: "새로운 미리 알림",
                                                                                            attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)]))
        return configuration
    }
}
