//
//  ReminderTagView.swift
//  CodebasePractice
//
//  Created by Minjae Kim on 7/8/24.
//

import UIKit

import SnapKit

final class ReminderTagView: BaseView {
    
    private let tagLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(tagString: String) {
        self.init(frame: .zero)
        configureContent(tagString: tagString)
    }
    
    override func configureView() {
        backgroundColor = UIColor.systemGray
    }
    
    override func configureHierarchy() {
        addSubview(tagLabel)
    }
    
    override func configureLayout() {
        tagLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(8)
            make.horizontalEdges.equalToSuperview().inset(4)
        }
    }
    
    private func configureUI() {
        layer.cornerRadius = 10
        tagLabel.font = UIFont.boldSystemFont(ofSize: 14)
        tagLabel.textColor = UIColor.systemGray6
    }
    
    func configureContent(tagString: String) {
        tagLabel.text = tagString
    }
    
    func changedSelect(isSelect: Bool) {
        if isSelect {
            backgroundColor = UIColor.systemGray
            tagLabel.textColor = UIColor.systemGray6
        } else {
            backgroundColor = UIColor.systemBlue
            tagLabel.textColor = UIColor.white
        }
    }
}
