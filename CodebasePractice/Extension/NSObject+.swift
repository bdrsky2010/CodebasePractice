//
//  NSObject+.swift
//  CodebasePractice
//
//  Created by Minjae Kim on 6/28/24.
//

import UIKit

protocol ReuseIdentifier {
    static var identifier: String { get }
}

extension NSObject: ReuseIdentifier {
    static var identifier: String {
        return self.description()
    }
}
