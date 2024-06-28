//
//  LottoView.swift
//  CodebasePractice
//
//  Created by Minjae Kim on 6/26/24.
//

import UIKit

import SnapKit

final class LottoView: BaseView {
    
    let numberPicker = UIPickerView()
    
    lazy var pickerTextField: UITextField = {
        let textField = UITextField()
        textField.inputView = numberPicker
        textField.tintColor = .clear
        textField.borderStyle = .roundedRect
        textField.attributedPlaceholder = NSAttributedString(string: "여기를 탭 하여 로또 추첨번호 회차를 선택하세요", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .bold)])
        textField.textAlignment = .center
        return textField
    }()
    
    lazy var textFieldCoverView: UIView = {
        let uiView = UIView()
        uiView.isUserInteractionEnabled = true
        return uiView
    }()
    
    private let guideLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.text = "당첨번호 안내"
        return label
    }()
    
    let drawDateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 11, weight: .bold)
        label.textColor = .systemGray
        label.text = "추첨날짜"
        return label
    }()
    
    private let divider: UIView = {
        let divider = UIView()
        divider.backgroundColor = .systemGray5
        return divider
    }()
    
    let resultTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.attributedText = "?? 회 당첨결과".changedSearchTextColor("??")
        return label
    }()
    
    let drawNumberLabelList: [UILabel] = {
        var labelList: [UILabel] = (0..<8).map {
            let label = UILabel()
            if $0 == 6 {
                label.text = "+"
            } else {
                label.text = "??"
                label.textColor = .white
            }
            label.font = .systemFont(ofSize: 14, weight: .bold)
            label.textAlignment = .center
            return label
        }
        return labelList
    }()
    
    private let drawBottomLabelList: [UILabel] = {
        var labelList: [UILabel] = (0..<8).map {
            let label = UILabel()
            if $0 == 7 {
                label.text = "보너스"
                label.font = .systemFont(ofSize: 13, weight: .bold)
                label.textColor = .systemGray
                label.textAlignment = .center
            } else {
                label.text = "없음"
                label.font = .systemFont(ofSize: 13, weight: .bold)
                label.textColor = .clear
                label.textAlignment = .center
            }
            return label
        }
        return labelList
    }()
    
    private let drawNumberStackViewList: [UIStackView] = {
        var stackViewList: [UIStackView] =  (0..<8).map { _ in
            let stackView = UIStackView()
            stackView.axis = .vertical
            stackView.spacing = 4
            return stackView
        }
        return stackViewList
    }()
    
    private let drawStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 2
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func configureView() {
        backgroundColor = .systemBackground
    }
    
    override func configureHierarchy() {
        
        addSubview(pickerTextField)
        addSubview(textFieldCoverView)
        addSubview(guideLabel)
        addSubview(drawDateLabel)
        addSubview(divider)
        addSubview(resultTitleLabel)
        addSubview(drawStackView)
        
        (0..<8).forEach { i in
            drawNumberStackViewList[i].addArrangedSubview(drawNumberLabelList[i])
            drawNumberStackViewList[i].addArrangedSubview(drawBottomLabelList[i])
        }
        drawNumberStackViewList.forEach { drawStackView.addArrangedSubview($0) }
    }
    
    override func configureLayout() {
        
        pickerTextField.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(32)
            make.height.equalTo(40)
        }
        
        textFieldCoverView.snp.makeConstraints { make in
            make.top.equalTo(pickerTextField.snp.top)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(32)
            make.height.equalTo(40)
        }
        
        guideLabel.snp.makeConstraints { make in
            make.top.equalTo(textFieldCoverView.snp.bottom).offset(24)
            make.leading.equalTo(safeAreaLayoutGuide).offset(16)
        }
        
        drawDateLabel.snp.makeConstraints { make in
            make.centerY.equalTo(guideLabel.snp.centerY)
            make.trailing.equalTo(safeAreaLayoutGuide).inset(16)
        }
        
        divider.snp.makeConstraints { make in
            make.top.equalTo(guideLabel.snp.bottom).offset(12)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(16)
            make.height.equalTo(1)
        }
        
        resultTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(divider.snp.bottom).offset(28)
            make.centerX.equalTo(snp.centerX)
        }
        
        drawStackView.snp.makeConstraints { make in
            make.top.equalTo(resultTitleLabel.snp.bottom).offset(28)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(16)
        }
        
        drawNumberLabelList.forEach { label in
            label.snp.makeConstraints { make in
                make.height.equalTo(label.snp.width).multipliedBy(1)
            }
        }
    }
}
