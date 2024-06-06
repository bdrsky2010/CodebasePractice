//
//  String+.swift
//  CodebasePractice
//
//  Created by Minjae Kim on 6/6/24.
//

import UIKit

extension String {
    
    func changedSearchTextColor(_ text: String?) -> NSAttributedString {
        guard let text, !text.isEmpty else {
            return NSAttributedString(string: self)
        }
        
        let attributedString = NSMutableAttributedString(string: self)
        attributedString.addAttribute(.foregroundColor, value: UIColor.pastelYellow, range: (self as NSString).range(of: text, options: .caseInsensitive))
        
        return attributedString
    }
}
