//
//  LottoViewController.swift
//  CodebasePractice
//
//  Created by Minjae Kim on 6/6/24.
//

import UIKit
import Alamofire
import SnapKit

struct Lotto: Decodable {
    let drwNoDate: String
    let drwtNo1: Int
    let drwtNo2: Int
    let drwtNo3: Int
    let drwtNo4: Int
    let drwtNo5: Int
    let drwtNo6: Int
    let bnusNo: Int
}

class LottoViewController: UIViewController, ConfigureViewProtocol {
    
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
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(coverViewTapped))
        uiView.addGestureRecognizer(tapGestureRecognizer)
        
        return uiView
    }()
    
    let guideLabel: UILabel = {
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
    
    let divider: UIView = {
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
    
    let drawBottomLabelList: [UILabel] = {
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
    
    let drawNumberStackViewList: [UIStackView] = {
        var stackViewList: [UIStackView] =  (0..<8).map { _ in
            let stackView = UIStackView()
            stackView.axis = .vertical
            stackView.spacing = 4
            return stackView
        }
        return stackViewList
    }()
    
    let drawStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 2
        return stackView
    }()
    
    lazy var numeberList: [Int] = (1...calculateRecentNumber()).reversed().map { Int($0) }
    
    private let pastelColorList: [UIColor] = [.pastelRed, .pastelGreen, .pastelBlue, .pastelYellow, .systemGray]
    
    private var lotto: Lotto?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        numberPicker.delegate = self
        numberPicker.dataSource = self
        
        configureHierarchy()
        configureLayout()
        configureContent()
        
        DispatchQueue.main.async {
            self.configureUI()
        }
        
        let rootViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(rootViewTapped))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(rootViewTapGesture)
        
        if let recentNumber = numeberList.first {
            requestAPI(recentNumber)
        }
    }
    
    func configureHierarchy() {
        
        view.addSubview(pickerTextField)
        view.addSubview(textFieldCoverView)
        view.addSubview(guideLabel)
        view.addSubview(drawDateLabel)
        view.addSubview(divider)
        view.addSubview(resultTitleLabel)
        view.addSubview(drawStackView)
        
        (0..<8).forEach { i in
            drawNumberStackViewList[i].addArrangedSubview(drawNumberLabelList[i])
            drawNumberStackViewList[i].addArrangedSubview(drawBottomLabelList[i])
        }
        drawNumberStackViewList.forEach { drawStackView.addArrangedSubview($0) }
    }
    
    func configureLayout() {
        
        pickerTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(32)
            make.height.equalTo(40)
        }
        
        textFieldCoverView.snp.makeConstraints { make in
            make.top.equalTo(pickerTextField.snp.top)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(32)
            make.height.equalTo(40)
        }
        
        guideLabel.snp.makeConstraints { make in
            make.top.equalTo(textFieldCoverView.snp.bottom).offset(24)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
        }
        
        drawDateLabel.snp.makeConstraints { make in
            make.centerY.equalTo(guideLabel.snp.centerY)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        divider.snp.makeConstraints { make in
            make.top.equalTo(guideLabel.snp.bottom).offset(12)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(1)
        }
        
        resultTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(divider.snp.bottom).offset(28)
            make.centerX.equalTo(view.snp.centerX)
        }
        
        drawStackView.snp.makeConstraints { make in
            make.top.equalTo(resultTitleLabel.snp.bottom).offset(28)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        drawNumberLabelList.forEach { label in
            label.snp.makeConstraints { make in
                make.height.equalTo(label.snp.width).multipliedBy(1)
            }
        }
    }
    
    func configureContent() {
        guard let lotto else {
            drawNumberLabelList.enumerated().forEach {
                if $0.offset != 6 {
                    $0.element.text = "??"
                }
            }
            return
        }
        
        drawDateLabel.text = "\(lotto.drwNoDate) 추첨"
        resultTitleLabel.attributedText = "\(pickerTextField.text ?? "??") 당첨결과".changedSearchTextColor("\(pickerTextField.text ?? "??")")
        
        drawNumberLabelList[0].text = "\(lotto.drwtNo1)"
        changeLableBackgroundColor(drawNumberLabelList[0], drwNo: Int(lotto.drwtNo1))
        
        drawNumberLabelList[1].text = "\(lotto.drwtNo2)"
        changeLableBackgroundColor(drawNumberLabelList[1], drwNo: Int(lotto.drwtNo2))
        
        drawNumberLabelList[2].text = "\(lotto.drwtNo3)"
        changeLableBackgroundColor(drawNumberLabelList[2], drwNo: Int(lotto.drwtNo3))
        
        drawNumberLabelList[3].text = "\(lotto.drwtNo4)"
        changeLableBackgroundColor(drawNumberLabelList[3], drwNo: Int(lotto.drwtNo4))
        
        drawNumberLabelList[4].text = "\(lotto.drwtNo5)"
        changeLableBackgroundColor(drawNumberLabelList[4], drwNo: Int(lotto.drwtNo5))
        
        drawNumberLabelList[5].text = "\(lotto.drwtNo6)"
        changeLableBackgroundColor(drawNumberLabelList[5], drwNo: Int(lotto.drwtNo6))
        
        drawNumberLabelList[7].text = "\(lotto.bnusNo)"
        changeLableBackgroundColor(drawNumberLabelList[7], drwNo: Int(lotto.bnusNo))
    }
    
    private func changeLableBackgroundColor(_ label: UILabel, drwNo: Int?) {
        guard let drwNo else { return }
        
        switch drwNo {
        case 1...10: label.backgroundColor = .pastelYellow
        case 11...20: label.backgroundColor = .pastelBlue
        case 21...30: label.backgroundColor = .pastelRed
        case 31...40: label.backgroundColor = .systemGray
        case 41...45: label.backgroundColor = .pastelGreen
        default: label.backgroundColor = .pastelPurple
        }
    }
    
    func configureUI() {
        
        drawNumberLabelList.enumerated().forEach {
            let index = $0.offset
            let label = $0.element
            
            if index != 6 {
                label.backgroundColor = .pastelPurple
            }
            
            label.clipsToBounds = true
            label.layer.cornerRadius = label.frame.width / 2
        }
    }
    
    @objc private func coverViewTapped() {
        pickerTextField.becomeFirstResponder()
    }
    
    @objc private func rootViewTapped() {
        pickerTextField.resignFirstResponder()
    }
    
    // MARK: 날짜를 초단위로 계산해서 최신회차 구하기
    private func calculateRecentNumber() -> Int {
        let firstDateString = "20021207"
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "yyyyMMdd"
        
        let firstDate = dateFormatter.date(from: firstDateString) ?? Date()
        
        let nowDate = Date()
        
        let recentNumber = Int(nowDate.timeIntervalSince(firstDate)) / 86400 / 7 + 1
        
        return recentNumber
    }
}

extension LottoViewController: UIPickerViewDelegate, RequestAPIFromAFProtocol {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(numeberList[row]) 회"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let number = numeberList[row]
        
        requestAPI(number)
    }
    
    private func requestAPI(_ number: Int) {
        requestDecodableCustomTypeResult(urlString: APIURL.lotto(number).urlString,
                                         encoding: URLEncoding.queryString,
                                         type: Lotto.self
        ) { [weak self] value in
            guard let self else { return }
            
            lotto = value
            configureContent()
        } failClosure: { [weak self] error in
            guard let self else { return }
            
            presentAlert(option: .oneButton, title: "오류가 발생했어요... 🤔", checkAlertTitle: "확인")
            print(error)
        }
        
        pickerTextField.text = "\(number) 회"
    }
}

extension LottoViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        numeberList.count
    }
}
