//
//  LoginViewController.swift
//  CodebasePractice
//
//  Created by Minjae Kim on 6/5/24.
//

import UIKit

class LoginViewController: UIViewController, ConfigureViewProtocol {

    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "JACKFLIX"
        label.font = .systemFont(ofSize: 20, weight: .black)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    let idTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .darkGray
        textField.attributedPlaceholder = NSAttributedString(string: "이메일 주소 또는 전화번호", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13, weight: .bold),
                                                                                                    NSAttributedString.Key.foregroundColor: UIColor.white])
        return textField
    }()
    
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .darkGray
        textField.attributedPlaceholder = NSAttributedString(string: "이메일 주소 또는 전화번호", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13, weight: .bold),
                                                                                                    NSAttributedString.Key.foregroundColor: UIColor.white])
        return textField
    }()
    
    let nicknameTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .darkGray
        textField.attributedPlaceholder = NSAttributedString(string: "이메일 주소 또는 전화번호", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13, weight: .bold),
                                                                                                    NSAttributedString.Key.foregroundColor: UIColor.white])
        return textField
    }()
    
    let locationTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .darkGray
        textField.attributedPlaceholder = NSAttributedString(string: "이메일 주소 또는 전화번호", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13, weight: .bold),
                                                                                                    NSAttributedString.Key.foregroundColor: UIColor.white])
        return textField
    }()
    
    let recommendCodeTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .darkGray
        textField.attributedPlaceholder = NSAttributedString(string: "이메일 주소 또는 전화번호", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13, weight: .bold),
                                                                                                    NSAttributedString.Key.foregroundColor: UIColor.white])
        return textField
    }()
    
    let signUpButton: UIButton = {
        let button = UIButton()
        button.configuration = .bordered()
        
        button.configuration?.attributedTitle = AttributedString(NSAttributedString(string: "회원가입",
                                                                                    attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .bold),
                                                                                                 NSAttributedString.Key.foregroundColor: UIColor.black]))
        button.configuration?.baseBackgroundColor = .white
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureHierarchy()
        configureLayout()
    }
    
    func configureHierarchy() {
        view.addSubview(titleLabel)
        view.addSubview(idTextField)
        view.addSubview(passwordTextField)
        view.addSubview(nicknameTextField)
        view.addSubview(locationTextField)
        view.addSubview(recommendCodeTextField)
        view.addSubview(signUpButton)
        
    }
    
    func configureLayout() {
        
    }
}
