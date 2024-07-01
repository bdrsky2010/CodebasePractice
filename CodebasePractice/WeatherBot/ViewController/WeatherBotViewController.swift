//
//  WeatherChatViewController.swift
//  CodebasePractice
//
//  Created by Minjae Kim on 6/19/24.
//

import UIKit
import CoreLocation

import Alamofire
import SnapKit


final class WeatherBotViewController: BaseViewController {
    
    private let weatherView = WeatherView()
    
    private let locationManager = CLLocationManager()
    
    private var coordinate: CLLocationCoordinate2D?
    private var messageList = Array(repeating: "", count: 5)
    
    override func loadView() {
        view = weatherView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureButton()
        configureTableView()
        locationManager.delegate = self
    }
    
    private func configureButton() {
        weatherView.locationButton.addTarget(self, action: #selector(locationButtonClicked), for: .touchUpInside)
        weatherView.refreshButton.addTarget(self, action: #selector(refreshButtonClicked), for: .touchUpInside)
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
        weatherView.messageTableView.delegate = self
        weatherView.messageTableView.dataSource = self
        weatherView.messageTableView.register(MessageTableViewCell.self, forCellReuseIdentifier: MessageTableViewCell.identifier)
        weatherView.messageTableView.register(ImageTableViewCell.self, forCellReuseIdentifier: ImageTableViewCell.identifier)
        
        weatherView.messageTableView.backgroundColor = UIColor.clear
        weatherView.messageTableView.rowHeight = UITableView.automaticDimension
        weatherView.messageTableView.separatorStyle = .none
        weatherView.messageTableView.allowsSelection = false
    }
    
    private func configureContent(openWeather: OpenWeather) {
        guard let weather = openWeather.weather.first else { return }
        messageList[0] = "지금은 \(openWeather.detail.temp)°C에요"
        messageList[1] = "\(openWeather.detail.humidity)% 만큼 습해요"
        messageList[2] = "\(openWeather.wind.integerSpeed)m/s의 바람이 불어요"
        messageList[3] = weather.icon
        messageList[4] = "오늘도 행복한 하루 보내세요"
        
        weatherView.dateTimeLabel.text = Date.dateTime
        weatherView.messageTableView.reloadData()
        
        if let type = WeatherCondition(rawValue: weather.type) {
            weatherView.backgroundImageView.image = UIImage(named: type.rawValue)
        }
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
        let api = APIURL.openWeather(coordinate.latitude, coordinate.longitude, "kr", "metric")
        
        NetworkManager.shared.requestAPIWithAlertOnViewController(viewController: self, api: api) { [weak self] (openWeather: OpenWeather) in
            guard let self else { return }
            configureContent(openWeather: openWeather)
        }
    }
}

// MARK: Configure CLLocationManager Logic
extension WeatherBotViewController {
    
    // 1) 사용자에게 권한 요청을 하기 위해, iOS 위치 서비스 활성화 여부 체크
    private func checkDeviceLocationAuthorization() {
        DispatchQueue.global().async { [weak self] in
            guard let self else { return }
            if CLLocationManager.locationServicesEnabled() {
                checkCurrentLocationAuthorization()
            } else {
                let title = "위치 권한 요청 에러"
                let message = "사용자의 위치 서비스가 꺼져 있어 위치 권한 요청을 할 수 없어요"
                presentAlert(option: .oneButton, title: title, message: message, checkAlertTitle: "확인")
            }
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
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                
                let title = "위치 권한 설정"
                let message = "설정 창으로 이동하시겠습니까?"
                let moveSetting: (UIAlertAction) -> Void = { _ in
                    guard let settingURL = URL(string: UIApplication.openSettingsURLString) else { return }
                    
                    if UIApplication.shared.canOpenURL(settingURL) {
                        UIApplication.shared.open(settingURL)
                    }
                }
                
                presentAlert(option: .twoButton,
                             title: title,
                             message: message,
                             checkAlertTitle: "이동",
                             completionHandler: moveSetting)
            }
            
        case .authorizedWhenInUse:
            print("위치 정보 알려달라고 로직을 구성할 수 있음")
            locationManager.startUpdatingLocation()
            
        default:
            print(status)
        }
    }
    
    private func convertLocationToAddress(coordinate: CLLocationCoordinate2D) {
        let geoCoder = CLGeocoder()
        
        geoCoder.reverseGeocodeLocation(CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)) { [weak self] placemarks, error in
            guard let self, error == nil else { return }
            
            if let placemark = placemarks?.first {
                let location = "\(placemark.locality ?? ""), \(placemark.subLocality ?? "")"
                weatherView.locationLabel.text = location
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
        
        let title = "위치 데이터를 가져오는데 실패하였습니다"
        let message = "다시 요청하시겠습니까?"
        
        presentAlert(option: .twoButton,
                     title: title,
                     message: message,
                     checkAlertTitle: "확인"
        ) { [weak self] _ in
            guard let self else { return }
            checkDeviceLocationAuthorization()
        }
    }
    
    // 7. 사용자 권한 상태가 변경될 때(iOS14) + 인스턴스가 생성이 될 때도 호출이 된다.
    //    사용자가 허용해줬다가 아이폰 설정에서 나중에 허용을 거부해버린 경우
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print(#function)
        checkDeviceLocationAuthorization()
    }
}
