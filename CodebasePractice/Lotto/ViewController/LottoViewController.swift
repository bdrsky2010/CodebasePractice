//
//  LottoViewController.swift
//  CodebasePractice
//
//  Created by Minjae Kim on 6/6/24.
//

import UIKit

import Alamofire

class LottoViewController: UIViewController {
    
    private let lottoView = LottoView()
    
    lazy var numeberList: [Int] = (1...calculateRecentNumber()).reversed().map { Int($0) }
    
    private let pastelColorList: [UIColor] = [.pastelRed, .pastelGreen, .pastelBlue, .pastelYellow, .systemGray]
    
    private var lotto: Lotto?
    
    override func loadView() {
        view = lottoView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lottoView.numberPicker.delegate = self
        lottoView.numberPicker.dataSource = self
        
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            configureUI()
        }
        
        let rootViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(rootViewTapped))
        lottoView.isUserInteractionEnabled = true
        lottoView.addGestureRecognizer(rootViewTapGesture)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(coverViewTapped))
        lottoView.textFieldCoverView.addGestureRecognizer(tapGestureRecognizer)
        
        if let recentNumber = numeberList.first {
            requestAPI(recentNumber)
        }
    }
    
    private func configureContent() {
        guard let lotto else {
            lottoView.drawNumberLabelList.enumerated().forEach {
                if $0.offset != 6 {
                    $0.element.text = "??"
                }
            }
            return
        }
        
        lottoView.drawDateLabel.text = "\(lotto.drwNoDate) 추첨"
        lottoView.resultTitleLabel.attributedText = "\(lottoView.pickerTextField.text ?? "??") 당첨결과".changedSearchTextColor("\(lottoView.pickerTextField.text ?? "??")")
        
        lottoView.drawNumberLabelList[0].text = "\(lotto.drwtNo1)"
        changeLableBackgroundColor(lottoView.drawNumberLabelList[0], drwNo: Int(lotto.drwtNo1))
        
        lottoView.drawNumberLabelList[1].text = "\(lotto.drwtNo2)"
        changeLableBackgroundColor(lottoView.drawNumberLabelList[1], drwNo: Int(lotto.drwtNo2))
        
        lottoView.drawNumberLabelList[2].text = "\(lotto.drwtNo3)"
        changeLableBackgroundColor(lottoView.drawNumberLabelList[2], drwNo: Int(lotto.drwtNo3))
        
        lottoView.drawNumberLabelList[3].text = "\(lotto.drwtNo4)"
        changeLableBackgroundColor(lottoView.drawNumberLabelList[3], drwNo: Int(lotto.drwtNo4))
        
        lottoView.drawNumberLabelList[4].text = "\(lotto.drwtNo5)"
        changeLableBackgroundColor(lottoView.drawNumberLabelList[4], drwNo: Int(lotto.drwtNo5))
        
        lottoView.drawNumberLabelList[5].text = "\(lotto.drwtNo6)"
        changeLableBackgroundColor(lottoView.drawNumberLabelList[5], drwNo: Int(lotto.drwtNo6))
        
        lottoView.drawNumberLabelList[7].text = "\(lotto.bnusNo)"
        changeLableBackgroundColor(lottoView.drawNumberLabelList[7], drwNo: Int(lotto.bnusNo))
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
        
        lottoView.drawNumberLabelList.enumerated().forEach {
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
        lottoView.pickerTextField.becomeFirstResponder()
    }
    
    @objc private func rootViewTapped() {
        lottoView.pickerTextField.resignFirstResponder()
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

extension LottoViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(numeberList[row]) 회"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let number = numeberList[row]
        
        requestAPI(number)
    }
    
    private func requestAPI(_ number: Int) {
        let api = APIURL.lotto(number)
        
        NetworkManager.shared.requestAPI(urlString: api.endpoint,
                                         method: .get,
                                         parameters: api.parameters,
                                         encoding: URLEncoding.queryString,
                                         headers: api.headers,
                                         of: Lotto.self) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let value):
                lotto = value
                configureContent()
            case .failure(let error):
                presentAlert(option: .oneButton, title: "오류가 발생했어요... 🤔", checkAlertTitle: "확인")
                print(error)
            }
        }
        lottoView.pickerTextField.text = "\(number) 회"
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
