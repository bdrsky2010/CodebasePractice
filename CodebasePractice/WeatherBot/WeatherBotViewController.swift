//
//  WeatherChatViewController.swift
//  CodebasePractice
//
//  Created by Minjae Kim on 6/19/24.
//

import UIKit
import CoreLocation
import MapKit

import Alamofire
import Kingfisher
import SnapKit


final class WeatherBotViewController: UIViewController, ConfigureViewProtocol {
    
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: WeatherCondition.allCases.randomElement()!.rawValue)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let dateTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "00월 00일 00시 00분"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .white
        return label
    }()
    
    private let locationButton: UIButton = {
        let button = UIButton(type: .system)
        button.configuration = .plain()
        button.configuration?.image = UIImage(systemName: "location.fill")
        button.configuration?.baseForegroundColor = UIColor.white
        button.configuration?.preferredSymbolConfigurationForImage = .init(pointSize: 20)
        return button
    }()
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.text = "ㅁㅁ, ㅁㅁ동"
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .white
        return label
    }()
    
    private let sharedButton: UIButton = {
        let button = UIButton(type: .system)
        button.configuration = .plain()
        button.configuration?.image = UIImage(systemName: "square.and.arrow.up")
        button.configuration?.baseForegroundColor = UIColor.white
        button.configuration?.preferredSymbolConfigurationForImage = .init(pointSize: 14)
        return button
    }()
    
    private let refreshButton: UIButton = {
        let button = UIButton(type: .system)
        button.configuration = .plain()
        button.configuration?.image = UIImage(systemName: "arrow.clockwise")
        button.configuration?.baseForegroundColor = UIColor.white
        button.configuration?.preferredSymbolConfigurationForImage = .init(pointSize: 14)
        return button
    }()
    
    private let messageTableView = UITableView()
    
    private let locationManager = CLLocationManager()
    
    private var coordinate: CLLocationCoordinate2D?
    private var messageList = Array(repeating: "", count: 5)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureButton()
        locationManager.delegate = self
        
    }
    
    func configureView() {
        view.backgroundColor = .white
        configureHierarchy()
        configureLayout()
        configureTableView()
    }
    
    func configureHierarchy() {
        view.addSubview(backgroundImageView)
        view.addSubview(dateTimeLabel)
        view.addSubview(locationButton)
        view.addSubview(locationLabel)
        view.addSubview(refreshButton)
        view.addSubview(sharedButton)
        view.addSubview(messageTableView)
    }
    
    func configureLayout() {
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        dateTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(28)
        }
        
        locationButton.snp.makeConstraints { make in
            make.top.equalTo(dateTimeLabel.snp.bottom).offset(16)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.width.equalTo(30)
        }
        
        locationLabel.snp.makeConstraints { make in
            make.centerY.equalTo(locationButton.snp.centerY)
            make.leading.equalTo(locationButton.snp.trailing).offset(20)
            make.trailing.equalTo(refreshButton.snp.leading).offset(-20)
        }
        
        refreshButton.snp.makeConstraints { make in
            make.centerY.equalTo(locationButton.snp.centerY)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.width.equalTo(20)
        }
        
        sharedButton.snp.makeConstraints { make in
            make.centerY.equalTo(locationButton.snp.centerY)
            make.trailing.equalTo(refreshButton.snp.leading).offset(-20)
            make.width.equalTo(20)
        }
        
        messageTableView.snp.makeConstraints { make in
            make.top.equalTo(locationButton.snp.bottom).offset(8)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func configureButton() {
        locationButton.addTarget(self, action: #selector(locationButtonClicked), for: .touchUpInside)
        refreshButton.addTarget(self, action: #selector(refreshButtonClicked), for: .touchUpInside)
    }
    
    @objc
    private func locationButtonClicked() {
        let popupMapViewController = PopupMapViewController()
        popupMapViewController.modalPresentationStyle = .overFullScreen
        if let coordinate {
            popupMapViewController.setRegion(coordinate: coordinate)
        }
        present(popupMapViewController, animated: true)
    }
    
    @objc
    private func refreshButtonClicked() {
        checkDeviceLocationAuthorization()
    }
    
    private func configureTableView() {
        messageTableView.delegate = self
        messageTableView.dataSource = self
        messageTableView.register(MessageTableViewCell.self, forCellReuseIdentifier: MessageTableViewCell.identifier)
        messageTableView.register(ImageTableViewCell.self, forCellReuseIdentifier: ImageTableViewCell.identifier)
        
        messageTableView.backgroundColor = UIColor.clear
        messageTableView.rowHeight = UITableView.automaticDimension
        messageTableView.separatorStyle = .none
        messageTableView.allowsSelection = false
    }
    
    
}

extension WeatherBotViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        let item = messageList[index]
        if index == 3 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ImageTableViewCell.identifier, for: indexPath) as? ImageTableViewCell else { return UITableViewCell() }
            cell.configureImage(image: item)
            cell.backgroundColor = .clear
            return cell
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MessageTableViewCell.identifier, for: indexPath) as? MessageTableViewCell else { return UITableViewCell() }
        cell.configureMessage(text: item)
        cell.backgroundColor = .clear
        return cell
    }
}

extension WeatherBotViewController {
    
    private func requestWeatherAPI(coordinate: CLLocationCoordinate2D) {
        
        let parameters: Parameters = [
            "lat": coordinate.latitude,
            "lon": coordinate.longitude,
            "lang": "kr",
            "units": "metric",
            "appid": APIKey.openWeather
        ]
        
        AF.request(APIURL.openWeather.urlString, method: .get, parameters: parameters, encoding: URLEncoding.queryString).responseDecodable(of: OpenWeather.self) { [weak self] response in
            guard let self else { return }
            switch response.result {
            case .success(let value):
                if let weather = value.weather.first {
                    messageList[0] = "지금은 \(value.detail.temp)°C에요"
                    messageList[1] = "\(value.detail.humidity)% 만큼 습해요"
                    messageList[2] = "\(value.wind.integerSpeed)m/s의 바람이 불어요"
                    messageList[3] = weather.icon
                    messageList[4] = "오늘도 행복한 하루 보내세요"
                    
                    dateTimeLabel.text = Date.dateTime
                    messageTableView.reloadData()
                    
                    if let type = WeatherCondition(rawValue: weather.type) {
                        backgroundImageView.image = UIImage(named: type.rawValue)
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

// MARK: Configure CLLocationManager Logic
extension WeatherBotViewController {
    
    // 1) 사용자에게 권한 요청을 하기 위해, iOS 위치 서비스 활성화 여부 체크
    private func checkDeviceLocationAuthorization() {
        if CLLocationManager.locationServicesEnabled() {
            checkCurrentLocationAuthorization()
        } else {
            // 1. alert 창 구성
            let title = "위치 권한 요청 에러"
            let message = "사용자의 위치 서비스가 꺼져 있어 위치 권한 요청을 할 수 없어요"
            let alert = UIAlertController(title: title,
                                          message: message,
                                          preferredStyle: .alert)
            // 2. alert button 구성
            let check = UIAlertAction(title: "확인", style: .default)
            
            // 3. alert에 button 추가
            alert.addAction(check)
            
            present(alert, animated: true)
        }
    }
    
    // 2) 현재 사용자 위치 권한 상태 확인
    private func checkCurrentLocationAuthorization() {
        let status = locationManager.authorizationStatus
        
        switch status {
        case .notDetermined:
            print("이 권한에서만 권한 문구를 띄울 수 있음")
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            
        case .denied:
            print("iOS 설정 창으로 이동하라는 얼럿을 띄워주기")
            // 1. alert 창 구성
            let title = "위치 권한 설정"
            let message = "설정 창으로 이동하시겠습니까?"
            let alert = UIAlertController(title: title,
                                          message: message,
                                          preferredStyle: .alert)
            
            let moveSetting: (UIAlertAction) -> Void = { _ in
                guard let settingURL = URL(string: UIApplication.openSettingsURLString) else { return }
                
                if UIApplication.shared.canOpenURL(settingURL) {
                    UIApplication.shared.open(settingURL)
                }
            }
            
            // 2. alert button 구성
            let move = UIAlertAction(title: "이동", style: .default, handler: moveSetting)
            let cancel = UIAlertAction(title: "취소", style: .cancel)
            
            // 3. alert에 button 추가
            alert.addAction(move)
            alert.addAction(cancel)
            
            present(alert, animated: true)

        case .authorizedWhenInUse:
            print("위치 정보 알려달라고 로직을 구성할 수 있음")
            locationManager.startUpdatingLocation()
            
        default:
            print(status)
        }
    }
    
    private func locationDataErrorAlert() {
        // 1. alert 창 구성
        let title = "위치 데이터를 가져오는데 실패하였습니다"
        let message = "다시 요청하시겠습니까?"
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        // 2. alert button 구성
        let check = UIAlertAction(title: "확인", style: .default) { [weak self] _ in
            guard let self else { return }
            checkDeviceLocationAuthorization()
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        // 3. alert에 button 추가
        alert.addAction(check)
        alert.addAction(cancel)
        
        present(alert, animated: true)
    }
    
    private func convertLocationToAddress(coordinate: CLLocationCoordinate2D) {
        let geoCoder = CLGeocoder()
        
        geoCoder.reverseGeocodeLocation(CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)) { [weak self] placemarks, error in
            guard let self, error == nil else { return }
            
            if let placemark = placemarks?.first {
                let location = "\(placemark.locality ?? ""), \(placemark.subLocality ?? "")"
                locationLabel.text = location
            }
        }
    }
}

// MARK: CLLocationManagerDelegate Life Cycle Method
extension WeatherBotViewController: CLLocationManagerDelegate {
    
    // 5. 사용자 위치를 성공적으로 가지고 온 경우
    // 코드 구성에 따라 여러번 호출이 될 수도 있다
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(#function)
        if let coordinate = locations.last?.coordinate {
            // TODO: 받아온 위치로 어떤 거 할 지
            self.coordinate = coordinate
            convertLocationToAddress(coordinate: coordinate)
            requestWeatherAPI(coordinate: coordinate)
        } else {
            checkDeviceLocationAuthorization()
        }
        
        // startUpdatingLocation을 했으면 더이상 위치를 안받아도 되는 시점에서는 stop을 외쳐야한다.
        locationManager.stopUpdatingLocation()
    }
    
    // 6. 사용자 위치를 가지고 오지 못했거나
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print(#function)
    }
    
    // 7. 사용자 권한 상태가 변경될 때(iOS14) + 인스턴스가 생성이 될 때도 호출이 된다.
    //    사용자가 허용해줬다가 아이폰 설정에서 나중에 허용을 거부해버린 경우
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print(#function)
        checkDeviceLocationAuthorization()
    }
}
