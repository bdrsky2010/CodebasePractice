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
    let reminderSearchTableView = UITableView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        reminderSearchTableView.isHidden = true
    }
    
    override func configureHierarchy() {
        addSubview(reminderMainTableView)
        addSubview(reminderSearchTableView)
    }
    
    override func configureLayout() {
        reminderMainTableView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
        
        reminderSearchTableView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
    }
}
