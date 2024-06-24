//
//  OverViewTableViewCell.swift
//  CodebasePractice
//
//  Created by Minjae Kim on 6/11/24.
//

import UIKit
import SnapKit

final class OverViewTableViewCell: UITableViewCell, ConfigureViewProtocol {

    private let overViewLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    private let moreButton: UIButton = {
        let button = UIButton()
        button.configuration = .plain()
        button.configuration?.baseForegroundColor = UIColor.label
        return button
    }()
    
    var mediaDelegate: MediaDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureHierarchy()
        configureLayout()
        configureButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureHierarchy() {
        contentView.addSubview(overViewLabel)
        contentView.addSubview(moreButton)
    }
    
    func configureLayout() {
        overViewLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview().inset(20)
        }
        
        moreButton.snp.makeConstraints { make in
            make.top.equalTo(overViewLabel.snp.bottom).offset(8)
            make.centerX.equalTo(contentView.snp.centerX)
            make.bottom.equalTo(contentView.snp.bottom).offset(-8)
        }
    }
    
    func configureCell(isMore: Bool) {
        moreButton.configuration?.image = UIImage(systemName: isMore ? "chevron.up" : "chevron.down")
        overViewLabel.numberOfLines = isMore ? 0 : 2
    }
    
    private func configureButton() {
        moreButton.addTarget(self, action: #selector(moreButtonClicked), for: .touchUpInside)
    }
    
    @objc
    private func moreButtonClicked() {
        mediaDelegate?.reloadOverViewCell()
    }
    
    func configureContent(overView: String) {
        overViewLabel.text = overView
    }
}
