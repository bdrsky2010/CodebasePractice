//
//  PopupMapViewController.swift
//  CodebasePractice
//
//  Created by Minjae Kim on 6/19/24.
//

import UIKit
import MapKit

final class PopupMapViewController: BaseViewController {
    
    private let popupMapView = PopupMapView()
    
    override func loadView() {
        view = popupMapView
    }
    
    override func viewDidLoad() {
        configureButton()
    }
    
    private func configureButton() {
        popupMapView.checkButton.addTarget(self, action: #selector(checkButtonClicked), for: .touchUpInside)
    }
    
    @objc
    private func checkButtonClicked() {
        dismiss(animated: true)
    }
    
    func setRegion(coordinate: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        popupMapView.mapView.setRegion(region, animated: true)
        popupMapView.mapView.addAnnotation(annotation)
    }
}
