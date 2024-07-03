//
//  AllReminderView.swift
//  CodebasePractice
//
//  Created by Minjae Kim on 7/3/24.
//

import UIKit

import SnapKit

final class AllReminderView: BaseView {
    
    let reminderTableView = UITableView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func configureView() {
        backgroundColor = .systemBackground
    }
    
    override func configureHierarchy() {
        addSubview(reminderTableView)
    }
    
    override func configureLayout() {
        reminderTableView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
    }
}
