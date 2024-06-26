//
//  BaseViewController.swift
//  CodebasePractice
//
//  Created by Minjae Kim on 6/25/24.
//

import UIKit

class BaseViewController: UIViewController, ConfigureViewProtocol {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigation()
        configureView()
        configureHierarchy()
        configureLayout()
    }
    
    func configureNavigation() { }
    func configureView() { }
    func configureHierarchy() { }
    func configureLayout() { }
}
