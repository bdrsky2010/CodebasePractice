//
//  BoxOfficeViewController.swift
//  CodebasePractice
//
//  Created by Minjae Kim on 6/7/24.
//

import UIKit
import Alamofire
import SnapKit

struct DailyBoxOffice: Decodable {
    let boxOfficeResult: BoxOfficeResult
}

struct BoxOfficeResult: Decodable {
    let dailyBoxOfficeList: [BoxOffice]
}

struct BoxOffice: Decodable {
    let rank: String
    let movieNm: String
    let openDt: String
}

final class BoxOfficeViewController: UIViewController, ConfigureViewProtocol, RequestAPIFromAFProtocol {

    let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "projector")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let backgroundCoverView: UIView = {
       let view = UIView()
        view.backgroundColor = .black
        view.layer.opacity = 0.7
        return view
    }()
    
    let searchButton: UIButton = {
        let button = UIButton()
        button.configuration = .filled()
        button.configuration?.baseBackgroundColor = .white
        button.configuration?.attributedTitle = AttributedString(NSAttributedString(string: "검색", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .regular), NSAttributedString.Key.foregroundColor: UIColor.black]))
        return button
    }()
    
    let searchTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.attributedPlaceholder = NSAttributedString(string: "여기에 날짜를 입력해보세요", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .regular), NSAttributedString.Key.foregroundColor: UIColor.white])
        textField.textColor = .white
        textField.font = .systemFont(ofSize: 14, weight: .regular)
        textField.keyboardType = .numberPad
        return textField
    }()
    
    let underBarView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let boxOfficeTableView = UITableView()
    
    private var boxOfficeList: [BoxOffice] = [] {
        didSet {
            searchTextField.resignFirstResponder()
            boxOfficeTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierarchy()
        configureLayout()
        configureContent()
        configureTableView()
    }
    
    func configureHierarchy() {
        view.addSubview(backgroundImageView)
        view.addSubview(backgroundCoverView)
        view.addSubview(searchButton)
        view.addSubview(searchTextField)
        view.addSubview(underBarView)
        view.addSubview(boxOfficeTableView)
    }
    
    func configureLayout() {
        backgroundImageView.snp.makeConstraints { make in
            make.horizontalEdges.verticalEdges.equalToSuperview()
        }
        
        backgroundCoverView.snp.makeConstraints { make in
            make.horizontalEdges.verticalEdges.equalToSuperview()
        }
        
        searchButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(40)
            make.width.equalTo(80)
        }
        
        searchTextField.snp.makeConstraints { make in
            make.centerY.equalTo(searchButton.snp.centerY)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.trailing.equalTo(searchButton.snp.leading).offset(-20)
        }
        
        underBarView.snp.makeConstraints { make in
            make.height.equalTo(4)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.trailing.equalTo(searchButton.snp.leading).offset(-20)
            make.bottom.equalTo(searchButton.snp.bottom)
        }
        
        boxOfficeTableView.snp.makeConstraints { make in
            make.top.equalTo(underBarView.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func configureContent() {
        searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
    }
    
    @objc
    private func searchButtonTapped() {
        guard let targetDt = searchTextField.text else { return }
        
        requestDecodableCustomTypeResult(urlString: APIURL.kobis(APIKey.kobisAPIKey, targetDt).urlString,
                                         type: DailyBoxOffice.self) { [weak self] value in
            guard let self else { return }
            boxOfficeList = value.boxOfficeResult.dailyBoxOfficeList
        } failClosure: { [weak self] error in
            guard let self else { return }
            presentErrorAlert()
            print(error)
        }
    }
}

extension BoxOfficeViewController: UITableViewDelegate {
    
    private func configureTableView() {
        boxOfficeTableView.delegate = self
        boxOfficeTableView.dataSource = self
        
        boxOfficeTableView.register(BoxOfficeTableViewCell.self, forCellReuseIdentifier: BoxOfficeTableViewCell.identifier)
        
        boxOfficeTableView.backgroundColor = .clear
        boxOfficeTableView.keyboardDismissMode = .onDrag
        boxOfficeTableView.rowHeight = 40
        
        let tableViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        boxOfficeTableView.addGestureRecognizer(tableViewTapGesture)
    }
    
    @objc
    private func tableViewTapped() {
        searchTextField.resignFirstResponder()
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
