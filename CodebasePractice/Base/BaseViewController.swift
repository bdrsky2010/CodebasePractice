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
    
    deinit {
        print("\(String(describing: type(of: self))) deinit")
    }
    
    func configureView() { view.backgroundColor = .systemBackground }
    func configureHierarchy() { }
    func configureLayout() { }
}
