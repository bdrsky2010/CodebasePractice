//
//  BaseView.swift
//  CodebasePractice
//
//  Created by Minjae Kim on 6/25/24.
//

import UIKit

class BaseView: UIView, ConfigureViewProtocol {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        configureHierarchy()
        configureLayout()
    }
    
    deinit {
        print("\(String(describing: type(of: self))) deinit")
    }
    
    func configureView() { }
    func configureHierarchy() { }
    func configureLayout() { }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
