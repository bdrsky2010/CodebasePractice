//
//  PopupMapView.swift
//  CodebasePractice
//
//  Created by Minjae Kim on 6/26/24.
//

import UIKit
import MapKit

import SnapKit

final class PopupMapView: BaseView {
    
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.layer.opacity = 0.5
        return view
    }()
    
    let mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.layer.cornerRadius = 10
        return mapView
    }()
    
    let checkButton: UIButton = {
        let button = UIButton(type: .system)
        button.configuration = .borderedProminent()
        button.configuration?.baseBackgroundColor = UIColor.white
        button.configuration?.baseForegroundColor = UIColor.black
        button.configuration?.attributedTitle = AttributedString(NSAttributedString(string: "확인", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)]))
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func configureView() {
        super.configureView()
    }
    
    override func configureHierarchy() {
        addSubview(backgroundView)
        addSubview(mapView)
        addSubview(checkButton)
    }
    
    override func configureLayout() {
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        mapView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(30)
            make.centerY.equalTo(snp.centerY)
            make.height.equalTo(snp.height).multipliedBy(0.5)
        }
        
        checkButton.snp.makeConstraints { make in
            make.top.equalTo(mapView.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(30)
            make.height.equalTo(44)
        }
    }
}
