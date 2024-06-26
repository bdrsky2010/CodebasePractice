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
        configureView()
        configureHierarchy()
        configureLayout()
    }
    
    func configureView() { }
    func configureHierarchy() { }
    func configureLayout() { }
}
