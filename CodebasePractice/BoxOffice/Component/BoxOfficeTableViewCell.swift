//
//  BoxOfficeTableViewCell.swift
//  CodebasePractice
//
//  Created by Minjae Kim on 6/7/24.
//

import UIKit
import SnapKit

class BoxOfficeTableViewCell: UITableViewCell {
    
    let cellView: UIView = {
        let view = UIView()
        return view
    }()
    
    let numberLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.textColor = .black
        label.backgroundColor = .white
        label.textAlignment = .center
        return label
    }()
    
    let movieTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 11, weight: .bold)
        label.textColor = .systemGray4
        label.textAlignment = .center
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        configureHierarchy()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureHierarchy() {
        contentView.addSubview(cellView)
        contentView.addSubview(numberLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(movieTitleLabel)
    }
    
    func configureLayout() {
        
        cellView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(10)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        numberLabel.snp.makeConstraints { make in
            make.verticalEdges.equalTo(cellView.snp.verticalEdges)
            make.leading.equalTo(cellView)
            make.width.equalTo(36)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.centerY.equalTo(cellView.snp.centerY)
            make.trailing.equalTo(cellView.snp.trailing)
            make.width.equalTo(80)
        }
        
        movieTitleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(cellView.snp.centerY)
            make.leading.equalTo(numberLabel.snp.trailing).offset(20)
            make.trailing.equalTo(dateLabel.snp.leading).offset(-40)
        }
    }
    
    
}
