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
    
    func configureNavigation() {
        navigationController?.navigationBar.tintColor = .white
    }
    
    func configureContent() {
        boxOfficeView.searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        
        requestKobisAPI(date: yesterdayString)
        boxOfficeView.searchTextField.text = yesterdayString
    }
    
    @objc
    private func searchButtonTapped() {
        guard let targetDt = boxOfficeView.searchTextField.text else { return }
        
        requestKobisAPI(date: targetDt)
    }
    
    private func requestKobisAPI(date targetDt: String) {
        let api = APIURL.kobis(targetDt)
        
        NetworkManager.shared.requestAPIWithAlertOnViewController(viewController: self, api: api) { [weak self] (boxOffice: DailyBoxOffice) in
            guard let self else { return }
            boxOfficeList = boxOffice.boxOfficeResult.dailyBoxOfficeList
        }
        
//        requestAPI(api: api) { [weak self] (boxOffice: DailyBoxOffice) in
//            guard let self else { return }
//            boxOfficeList = boxOffice.boxOfficeResult.dailyBoxOfficeList
//        }
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
