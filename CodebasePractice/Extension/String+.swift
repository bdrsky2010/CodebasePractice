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
    
    var movieTrendConvertDateToString: String {
        let originDateFormatter = DateFormatter()
        originDateFormatter.dateFormat = "yyyy-MM-dd"
        guard let originDate = originDateFormatter.date(from: self) else { return "" }
        
        let newDateFormatter = DateFormatter()
        newDateFormatter.dateFormat = "MM/dd/yyyy"
        newDateFormatter.locale = Locale(identifier: "ko_KR")
        let convertDate = newDateFormatter.string(from: originDate)
        return convertDate
    }
    
    var stringToURL: URL? {
        return URL(string: self)
    }
}

extension String {
    var fontSize: CGSize {
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12, weight: .medium)]
        let size = (self as NSString).size(withAttributes: attributes)
        return size
    }
}
