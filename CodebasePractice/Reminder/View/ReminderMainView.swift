//
//  ReminderMainView.swift
//  CodebasePractice
//
//  Created by Minjae Kim on 7/2/24.
//

import UIKit

import SnapKit

final class ReminderMainView: BaseView {
    
    let reminderMainTableView = UITableView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func configureHierarchy() {
        addSubview(reminderMainTableView)
    }
    
    override func configureLayout() {
        reminderMainTableView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
    }
}
