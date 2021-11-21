//
//  SignInViewController.swift
//  LifeSocialMediaApp
//
//  Created by Stefan Dojcinovic on 15.11.21..
//

import UIKit

class SignInViewController: UIViewController {
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .systemBackground
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: 700)
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        return view
    }()
    
    private let appNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.text = "-Life-"
        label.font = UIFont(name: "Zapfino", size: 50)
        return label
    }()
    
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Username"
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 50))
        textField.leftViewMode = .always
        textField.backgroundColor = .secondarySystemBackground
        textField.layer.borderWidth = 2
        textField.layer.borderColor = UIColor.label.cgColor
        textField.layer.cornerRadius = 25
        textField.font = .systemFont(ofSize: 20)
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Password"
        textField.isSecureTextEntry = true
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 50))
        textField.leftViewMode = .always
        textField.backgroundColor = .secondarySystemBackground
        textField.layer.borderWidth = 2
        textField.layer.borderColor = UIColor.label.cgColor
        textField.layer.cornerRadius = 25
        textField.font = .systemFont(ofSize: 20)
        return textField
    }()

    private let signInButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Sign In", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 30, weight: .medium)
        button.layer.borderColor = UIColor.label.cgColor
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 30
        return button
    }()
    
    private let signUpButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("No account? Sign Up", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.titleLabel?.font = .systemFont(ofSize: 26, weight: .medium)
        button.layer.cornerRadius = 30
        return button
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Sign In"
        addSubviews()
        addConstraints()
        addTargets()
        scrollView.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
    
    private func addTargets() {
        signInButton.addTarget(self, action: #selector(signInButtonTapped(sender:)), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(signUpButtonTapped(sender:)), for: .touchUpInside)
    }
    
    @objc private func signInButtonTapped(sender: UIButton) {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            let alert = ErrorManager.shared.emptyFieldErrorAlert()
            present(alert, animated: true, completion: nil)
            return
        }
        
        AuthManager.shared.signIn(email: email, password: password) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    let vc = TabBarViewController()
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true, completion: nil)
                    
                }
            case .failure(let error):
                let alert = ErrorManager.shared.errorAlert(error)
                self.present(alert, animated: true, completion: nil)
            }
        }
        
        signInButton.tapEffect(sender: signInButton)
    }
    
    @objc private func signUpButtonTapped(sender: UIButton) {
        signUpButton.tapEffect(sender: signUpButton)
        let vc = SignUpViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func addSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(appNameLabel)
        contentView.addSubview(emailTextField)
        contentView.addSubview(passwordTextField)
        contentView.addSubview(signInButton)
        contentView.addSubview(signUpButton)
    }

    private func addConstraints() {
        // ScrollView
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor).isActive = true
        scrollView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor).isActive = true
        
        // ContentView
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        contentView.heightAnchor.constraint(equalToConstant: 700).isActive = true
        
        // AppNameLabel
        appNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        appNameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        appNameLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        appNameLabel.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        // UsernameTextField
        emailTextField.topAnchor.constraint(equalTo: appNameLabel.bottomAnchor, constant: 50).isActive = true
        emailTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -20).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        // PasswordTextField
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20).isActive = true
        passwordTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -20).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        // SignInButton
        signInButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 100).isActive = true
        signInButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        signInButton.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -20).isActive = true
        signInButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        // SignUpButton
        signUpButton.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 20).isActive = true
        signUpButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        signUpButton.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -20).isActive = true
        signUpButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        self.emailTextField.layer.borderColor = UIColor.label.cgColor
        self.passwordTextField.layer.borderColor = UIColor.label.cgColor
        self.signInButton.layer.borderColor = UIColor.label.cgColor
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        self.navigationItem.largeTitleDisplayMode = .always
        coordinator.animate(
            alongsideTransition: { [weak self] _ in
                guard let self = self else { return }
                self.navigationController?.navigationBar.sizeToFit()
            },
            completion: nil)
    }
}

//MARK: - UIScrollViewDelegate

extension SignInViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x != 0 {
            scrollView.contentOffset.x = 0
        }
    }
    
}
