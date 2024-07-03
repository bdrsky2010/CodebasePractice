//
//  CreateReminderView.swift
//  CodebasePractice
//
//  Created by Minjae Kim on 7/2/24.
//

import UIKit

import SnapKit

final class CreateReminderView: BaseView {
    
    let contentTableView = UITableView(frame: .zero, style: .insetGrouped)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func configureView() {
        backgroundColor = .systemBackground
    }
    
    override func configureHierarchy() {
        addSubview(contentTableView)
    }
    
    override func configureLayout() {
        contentTableView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
    }
}
