//
//  PopupMapViewController.swift
//  CodebasePractice
//
//  Created by Minjae Kim on 6/19/24.
//

import UIKit
import CoreLocation
import MapKit

import SnapKit

final class PopupMapViewController: UIViewController, ConfigureViewProtocol {
    
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.layer.opacity = 0.5
        return view
    }()
    
    private let mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.layer.cornerRadius = 10
        return mapView
    }()
    
    private let checkButton: UIButton = {
        let button = UIButton(type: .system)
        button.configuration = .borderedProminent()
        button.configuration?.baseBackgroundColor = UIColor.white
        button.configuration?.baseForegroundColor = UIColor.black
        button.configuration?.attributedTitle = AttributedString(NSAttributedString(string: "확인", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)]))
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureButton()
    }
    
    func configureView() {
        configureHierarchy()
        configureLayout()
    }
    
    func configureHierarchy() {
        view.addSubview(backgroundView)
        view.addSubview(mapView)
        view.addSubview(checkButton)
    }
    
    func configureLayout() {
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        mapView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(30)
            make.centerY.equalTo(view.snp.centerY)
            make.height.equalTo(view.snp.height).multipliedBy(0.5)
        }
        
        checkButton.snp.makeConstraints { make in
            make.top.equalTo(mapView.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(30)
            make.height.equalTo(44)
        }
    }
    
    private func configureButton() {
        checkButton.addTarget(self, action: #selector(checkButtonClicked), for: .touchUpInside)
    }
    
    @objc
    private func checkButtonClicked() {
        dismiss(animated: true)
    }
    
    func setRegion(coordinate: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.setRegion(region, animated: true)
        mapView.addAnnotation(annotation)
    }
}
