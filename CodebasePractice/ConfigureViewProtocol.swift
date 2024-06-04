//
//  ConfigureViewProtocol.swift
//  CodebasePractice
//
//  Created by Minjae Kim on 6/4/24.
//

import Foundation

@objc
protocol ConfigureViewProtocol {
    @objc optional func configureHierarchy()
    @objc optional func configureLayout()
    @objc optional func configureUI()
    @objc optional func configureContent()
}
