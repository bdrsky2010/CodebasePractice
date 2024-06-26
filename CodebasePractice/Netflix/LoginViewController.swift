//
//  LoginViewController.swift
//  CodebasePractice
//
//  Created by Minjae Kim on 6/5/24.
//

import UIKit

class LoginViewController: UIViewController {

    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "JACKFLIX"
        label.font = .systemFont(ofSize: 30, weight: .black)
        label.textAlignment = .center
        label.textColor = .red
        return label
    }()
    
    let idTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .darkGray
        textField.attributedPlaceholder = NSAttributedString(string: "이메일 주소 또는 전화번호", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13, weight: .bold),NSAttributedString.Key.foregroundColor: UIColor.white])
        textField.borderStyle = .roundedRect
        textField.textAlignment = .center
        return textField
    }()
    
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .darkGray
        textField.attributedPlaceholder = NSAttributedString(string: "비밀번호", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13, weight: .bold), NSAttributedString.Key.foregroundColor: UIColor.white])
        textField.borderStyle = .roundedRect
        textField.textAlignment = .center
        return textField
    }()
    
    let nicknameTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .darkGray
        textField.attributedPlaceholder = NSAttributedString(string: "닉네임", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13, weight: .bold), NSAttributedString.Key.foregroundColor: UIColor.white])
        textField.borderStyle = .roundedRect
        textField.textAlignment = .center
        return textField
    }()
    
    let locationTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .darkGray
        textField.attributedPlaceholder = NSAttributedString(string: "위치", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13, weight: .bold), NSAttributedString.Key.foregroundColor: UIColor.white])
        textField.borderStyle = .roundedRect
        textField.textAlignment = .center
        return textField
    }()
    
    let recommendCodeTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .darkGray
        textField.attributedPlaceholder = NSAttributedString(string: "추천 코드 입력", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13, weight: .bold), NSAttributedString.Key.foregroundColor: UIColor.white])
        textField.borderStyle = .roundedRect
        textField.textAlignment = .center
        return textField
    }()
    
    let signUpButton: UIButton = {
        let button = UIButton()
        button.configuration = .bordered()
        
        button.configuration?.attributedTitle = AttributedString(NSAttributedString(string: "회원가입", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .bold), NSAttributedString.Key.foregroundColor: UIColor.black]))
        button.configuration?.baseBackgroundColor = .white
        return button
    }()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 16
        return stackView
    }()
    
    let toggleBackgroundView = UIView()
    
    let additionalInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "추가 정보 입력"
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .white
        return label
    }()
    
    let toggleButton: UISwitch = {
        let toggleButton = UISwitch()
        toggleButton.onTintColor = .red
        toggleButton.isOn = true
        return toggleButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        configureHierarchy()
        configureLayout()
        configureNavigation()
    }
    
    func configureNavigation() {
        let dismissBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"),
                                                   style: .plain,
                                                   target: self,
                                                   action: #selector(dismissButtonClicked))
        
        navigationItem.rightBarButtonItem = dismissBarButtonItem
        navigationItem.rightBarButtonItem?.tintColor = .white
    }
    
    @objc
    private func dismissButtonClicked() {
        dismiss(animated: true)
    }
    
    func configureHierarchy() {
        view.addSubview(titleLabel)
        view.addSubview(stackView)
        stackView.addArrangedSubview(idTextField)
        stackView.addArrangedSubview(passwordTextField)
        stackView.addArrangedSubview(nicknameTextField)
        stackView.addArrangedSubview(locationTextField)
        stackView.addArrangedSubview(recommendCodeTextField)
        stackView.addArrangedSubview(signUpButton)
        stackView.addArrangedSubview(toggleBackgroundView)
        toggleBackgroundView.addSubview(additionalInfoLabel)
        toggleBackgroundView.addSubview(toggleButton)
    }
    
    func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(30)
        }
        
        stackView.snp.makeConstraints { make in
            make.center.equalTo(view.snp.center)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(30)
        }
        
        idTextField.snp.makeConstraints { make in
            make.height.equalTo(36)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(idTextField.snp.height)
        }
        
        nicknameTextField.snp.makeConstraints { make in
            make.height.equalTo(idTextField.snp.height)
        }
        
        locationTextField.snp.makeConstraints { make in
            make.height.equalTo(idTextField.snp.height)
        }
        
        recommendCodeTextField.snp.makeConstraints { make in
            make.height.equalTo(idTextField.snp.height)
        }
        
        signUpButton.snp.makeConstraints { make in
            make.height.equalTo(44)
        }
        
        toggleBackgroundView.snp.makeConstraints { make in
            make.height.equalTo(36)
        }
        
        additionalInfoLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.leading.equalToSuperview()
        }
        
        toggleButton.snp.makeConstraints { make in
            make.centerY.equalTo(additionalInfoLabel.snp.centerY)
            make.trailing.equalToSuperview()
        }
    }
}
