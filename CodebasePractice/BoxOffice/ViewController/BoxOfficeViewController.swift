//
//  BoxOfficeViewController.swift
//  CodebasePractice
//
//  Created by Minjae Kim on 6/7/24.
//

import UIKit

import Alamofire

final class BoxOfficeViewController: BaseViewController {

    private let boxOfficeView = BoxOfficeView()
    
    private var boxOfficeList: [BoxOffice] = [] {
        didSet {
            boxOfficeView.searchTextField.resignFirstResponder()
            boxOfficeView.boxOfficeTableView.reloadData()
        }
    }
    
    private var yesterdayString: String {
        let yesterday = Date(timeIntervalSinceNow: -86400)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        let yesterdayString = dateFormatter.string(from: yesterday)
        return yesterdayString
    }
    
    override func loadView() {
        view = boxOfficeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigation()
        configureContent()
        configureTableView()
    }
    
    override func configureNavigation() {
        navigationController?.navigationBar.tintColor = .white
    }
    
    func configureContent() {
        boxOfficeView.searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        
        requestAPI(date: yesterdayString)
        boxOfficeView.searchTextField.text = yesterdayString
    }
    
    @objc
    private func searchButtonTapped() {
        guard let targetDt = boxOfficeView.searchTextField.text else { return }
        
        requestAPI(date: targetDt)
    }
    
    private func requestAPI(date targetDt: String) {
        let api = APIURL.kobis(APIKey.kobis, targetDt)
        
        NetworkManager.shared.requestAPI(urlString: api.endpoint,
                                         method: .get,
                                         parameters: api.parameters,
                                         encoding: URLEncoding.queryString,
                                         headers: api.headers,
                                         of: DailyBoxOffice.self) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let value):
                boxOfficeList = value.boxOfficeResult.dailyBoxOfficeList
            case .failure(let error):
                presentAlert(option: .oneButton, title: "오류가 발생했어요... 🤔", checkAlertTitle: "확인")
                print(error)
            }
        }
    }
}

extension BoxOfficeViewController: UITableViewDelegate {
    
    private func configureTableView() {
        boxOfficeView.boxOfficeTableView.delegate = self
        boxOfficeView.boxOfficeTableView.dataSource = self
        
        boxOfficeView.boxOfficeTableView.register(BoxOfficeTableViewCell.self, forCellReuseIdentifier: BoxOfficeTableViewCell.identifier)
        
        boxOfficeView.boxOfficeTableView.backgroundColor = .clear
        boxOfficeView.boxOfficeTableView.keyboardDismissMode = .onDrag
        boxOfficeView.boxOfficeTableView.rowHeight = 40
        
        let tableViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        boxOfficeView.boxOfficeTableView.addGestureRecognizer(tableViewTapGesture)
    }
    
    @objc
    private func tableViewTapped() {
        boxOfficeView.searchTextField.resignFirstResponder()
    }
}

extension BoxOfficeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        boxOfficeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = BoxOfficeTableViewCell.identifier
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! BoxOfficeTableViewCell
        
        let index = indexPath.row
        let movie = boxOfficeList[index]
        
        cell.numberLabel.text = movie.rank
        cell.movieTitleLabel.text = movie.movieNm
        cell.dateLabel.text = movie.openDt
        return cell
    }
}
